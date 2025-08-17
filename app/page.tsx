import {ingestBackfillLoop, ingestLatestFeeds} from "./actions/thingspeak";
import {BackfillLoopCard, IngestLatestCard} from "@/components/thingspeak-cards";

export default function Home() {
  // Server action wrapper para usar con useActionState (recibe FormData)
  async function latestAction(_prevState: unknown, formData: FormData) {
    "use server";
    const n = Number(formData.get("results") ?? 20);
    return await ingestLatestFeeds(Number.isFinite(n) && n > 0 ? n : 20);
  }

  async function backfillLoopAction(_prevState: unknown, formData: FormData) {
    "use server";
    const batch = Number(formData.get("batch") ?? 200);
    const iterations = Number(formData.get("iterations") ?? 10);
    return await ingestBackfillLoop({
      batch: Number.isFinite(batch) && batch > 0 ? batch : 200,
      iterations: Number.isFinite(iterations) && iterations > 0 ? iterations : 10,
    });
  }

  return (
    <main className="p-6 flex flex-col gap-6 items-start">
      <IngestLatestCard action={latestAction} defaultBatch={20}/>
      <BackfillLoopCard action={backfillLoopAction} defaultBatch={200} defaultIterations={10}/>
    </main>
  );
}
