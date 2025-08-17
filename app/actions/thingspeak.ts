"use server";

import {createClient as createServerClient} from "@/utils/supabase/server";

/* =========================
 * Tipos
 * ========================= */

type IngestLatestResult =
  | {
  ok: true;
  requested: number;
  inserted: number;
  skipped: number;
  maxSaved: number;
  newestFetched: number | null;
}
  | { ok: false; error: string };

type BackfillResult =
  | {
  ok: true;
  inserted: number;
  fetched: number;
  reachedEnd?: boolean;
  newOldest: string | null;
}
  | { ok: false; error: string };

type LoopBackfillResult =
  | {
  ok: true;
  iterations: number;
  totalInserted: number;
  lastNewOldest: string | null;
  stoppedReason: "empty" | "limit" | "error";
}
  | { ok: false; error: string };

// Tipos de ThingSpeak
type ThingSpeakFeed = {
  created_at: string; // ISO
  entry_id: number;
  field1?: string | null;
  field2?: string | null;
  field3?: string | null;
  field4?: string | null;
  field5?: string | null;
  field6?: string | null;
  field7?: string | null;
  field8?: string | null;
};

type ThingSpeakResponse = {
  channel: { id: number; last_entry_id?: number | null };
  feeds: ThingSpeakFeed[];
};

/* =========================
 * Utils
 * ========================= */

const toNum = (v: string | null | undefined): number | null => {
  if (v === null || v === undefined || v === "") return null;
  const n = Number(v);
  return Number.isFinite(n) ? n : null;
};

async function requireUser() {
  const supabase = await createServerClient();
  const {
    data: {user},
  } = await supabase.auth.getUser();
  if (!user) throw new Error("Unauthorized");
  return supabase;
}

function getEnv() {
  return {
    channelId: Number(process.env.THINGSPEAK_CHANNEL_ID ?? 2621081),
    apiKey: process.env.THINGSPEAK_API_KEY ?? "DS0O5JWOPSREYKM7",
    timezone: process.env.THINGSPEAK_TIMEZONE || "America/Asuncion",
  };
}

// mayor entry_id ya guardado
async function getMaxEntryId(channelId: number) {
  const supabase = await createServerClient();
  const {data, error} = await supabase
    .from("thingspeak_feed")
    .select("entry_id")
    .eq("channel_id", channelId)
    .order("entry_id", {ascending: false})
    .limit(1)
    .maybeSingle();
  if (error) throw error;
  return data?.entry_id ?? 0;
}

// menor ts_iso ya guardado (para backfill hacia atrás)
async function getMinTsIso(channelId: number) {
  const supabase = await createServerClient();
  const {data, error} = await supabase
    .from("thingspeak_feed")
    .select("ts_iso")
    .eq("channel_id", channelId)
    .order("ts_iso", {ascending: true})
    .limit(1)
    .maybeSingle();
  if (error) throw error;
  return data?.ts_iso ?? null; // string ISO o null si no hay filas
}

/* =========================
 * Acción: últimos N (forward-only)
 * ========================= */

export async function ingestLatestFeeds(results = 20): Promise<IngestLatestResult> {
  try {
    const supabase = await requireUser();
    const {channelId, apiKey, timezone} = getEnv();

    // 1) último entry_id en BD
    const maxSaved = await getMaxEntryId(channelId);

    // 2) pedir a ThingSpeak (desc)
    const url = new URL(`https://api.thingspeak.com/channels/${channelId}/feeds.json`);
    url.searchParams.set("api_key", apiKey);
    url.searchParams.set("results", String(results));
    url.searchParams.set("sort", "desc");
    url.searchParams.set("timezone", timezone);

    const res = await fetch(url.toString(), {cache: "no-store"});
    if (!res.ok) return {ok: false, error: `ThingSpeak error ${res.status}`};

    const data = (await res.json()) as ThingSpeakResponse;

    // 3) mapear y filtrar nuevos
    const rows = (data.feeds || [])
      .filter((f) => f.entry_id > maxSaved)
      .map((f) => ({
        channel_id: data.channel?.id ?? channelId,
        entry_id: f.entry_id,
        ts_iso: new Date(f.created_at).toISOString(),
        field1: toNum(f.field1),
        field2: toNum(f.field2),
        field3: toNum(f.field3),
        field4: toNum(f.field4),
        field5: toNum(f.field5),
        field6: toNum(f.field6),
        field7: toNum(f.field7),
        field8: toNum(f.field8),
        raw: f ? (JSON.parse(JSON.stringify(f)) as object) : null,
      }));

    if (rows.length === 0) {
      return {ok: true, requested: results, inserted: 0, skipped: results, maxSaved, newestFetched: null};
    }

    // 4) upsert idempotente
    const {data: upserted, error} = await supabase
      .from("thingspeak_feed")
      .upsert(rows, {ignoreDuplicates: true, onConflict: "channel_id,entry_id"})
      .select();
    if (error) return {ok: false, error: error.message};

    return {
      ok: true,
      requested: results,
      inserted: upserted?.length ?? 0,
      skipped: results - (upserted?.length ?? 0),
      maxSaved,
      newestFetched: rows[0]?.entry_id ?? null,
    };
  } catch (e) {
    return {ok: false, error: e instanceof Error ? e.message : String(e)};
  }
}

/* =========================
 * Acción: backfill hacia atrás (anteriores al más viejo guardado)
 * ========================= */

export async function ingestOlderFeeds(batch = 100): Promise<BackfillResult> {
  try {
    const supabase = await requireUser();
    const {channelId, apiKey, timezone} = getEnv();

    // si no hay datos, no sabemos desde dónde retroceder
    const oldestIso = await getMinTsIso(channelId);
    if (!oldestIso) {
      return {ok: false, error: "No hay datos en BD. Ejecuta primero ingestLatestFeeds para sembrar."};
    }

    // restamos 1s para no incluir el mismo más viejo
    const end = new Date(new Date(oldestIso).getTime() - 1000).toISOString();

    const url = new URL(`https://api.thingspeak.com/channels/${channelId}/feeds.json`);
    url.searchParams.set("api_key", apiKey);
    url.searchParams.set("results", String(batch));
    url.searchParams.set("sort", "desc"); // más nuevo -> más viejo, acotado por 'end'
    url.searchParams.set("end", end);
    url.searchParams.set("timezone", timezone);

    const res = await fetch(url.toString(), {cache: "no-store"});
    if (!res.ok) return {ok: false, error: `ThingSpeak error ${res.status}`};

    const data = (await res.json()) as ThingSpeakResponse;

    const rows = (data.feeds || []).map((f) => ({
      channel_id: data.channel?.id ?? channelId,
      entry_id: f.entry_id,
      ts_iso: new Date(f.created_at).toISOString(),
      field1: toNum(f.field1),
      field2: toNum(f.field2),
      field3: toNum(f.field3),
      field4: toNum(f.field4),
      field5: toNum(f.field5),
      field6: toNum(f.field6),
      field7: toNum(f.field7),
      field8: toNum(f.field8),
      raw: f ? (JSON.parse(JSON.stringify(f)) as object) : null,
    }));

    if (rows.length === 0) {
      return {ok: true, inserted: 0, fetched: 0, reachedEnd: true, newOldest: null};
    }

    const {data: upserted, error} = await supabase
      .from("thingspeak_feed")
      .upsert(rows, {ignoreDuplicates: true, onConflict: "channel_id,entry_id"})
      .select();
    if (error) return {ok: false, error: error.message};

    // el último del array, por venir en desc, suele ser el más viejo del batch
    const newOldest = rows[rows.length - 1]?.ts_iso ?? null;

    return {ok: true, inserted: upserted?.length ?? 0, fetched: rows.length, newOldest};
  } catch (e) {
    return {ok: false, error: e instanceof Error ? e.message : String(e)};
  }
}

/* =========================
 * Acción: loop de backfill (varias tandas)
 * ========================= */

export async function ingestBackfillLoop({
                                           batch = 200,
                                           iterations = 10,
                                         }: {
  batch?: number;
  iterations?: number;
}): Promise<LoopBackfillResult> {
  try {
    await requireUser();

    let total = 0;
    let lastOldest: string | null = null;

    for (let i = 0; i < iterations; i++) {
      const r = await ingestOlderFeeds(batch);
      if (!r.ok) {
        return {ok: false, error: r.error};
      }
      total += r.inserted;
      lastOldest = r.newOldest ?? lastOldest;

      if (r.reachedEnd || r.fetched === 0 || r.inserted === 0) {
        return {
          ok: true,
          iterations: i + 1,
          totalInserted: total,
          lastNewOldest: lastOldest,
          stoppedReason: "empty",
        };
      }
    }

    return {
      ok: true,
      iterations,
      totalInserted: total,
      lastNewOldest: lastOldest,
      stoppedReason: "limit",
    };
  } catch (e) {
    return {ok: false, error: e instanceof Error ? e.message : String(e)};
  }
}
