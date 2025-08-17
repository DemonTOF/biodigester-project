// utils/thingspeak/queries.ts
import {createClient as createServerClient} from "@/utils/supabase/server";

export type FeedRow = {
  channel_id: number;
  entry_id: number;
  ts_iso: string; // ISO string UTC
  field1: number | null;
  field2: number | null;
  field3: number | null;
  field4: number | null;
  field5: number | null;
  field6: number | null;
  field7: number | null;
  field8: number | null;
};

export async function getFeedsSince(sinceIso?: string, limit = 2000): Promise<FeedRow[]> {
  const supabase = await createServerClient();
  let q = supabase
    .from("thingspeak_feed")
    .select("*")
    .order("ts_iso", {ascending: true})
    .limit(limit);

  if (sinceIso) {
    q = q.gte("ts_iso", sinceIso);
  }

  const {data, error} = await q;
  if (error) throw error;
  return data as FeedRow[];
}

export async function getLatestN(n = 500): Promise<FeedRow[]> {
  const supabase = await createServerClient();
  const {data, error} = await supabase
    .from("thingspeak_feed")
    .select("*")
    .order("ts_iso", {ascending: false})
    .limit(n);
  if (error) throw error;
  // invertimos para graficar ascendente
  return (data as FeedRow[]).reverse();
}
