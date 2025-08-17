import {createClient as createServerClient} from "@/utils/supabase/server";

export async function getMaxEntryId(channelId: number) {
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

export async function getMinTsIso(channelId: number) {
  const supabase = await createServerClient();
  const {data, error} = await supabase
    .from("thingspeak_feed")
    .select("ts_iso")
    .eq("channel_id", channelId)
    .order("ts_iso", {ascending: true})
    .limit(1)
    .maybeSingle();

  if (error) throw error;
  return data?.ts_iso ?? null; // string ISO o null si vacía
}
