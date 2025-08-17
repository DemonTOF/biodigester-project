// app/monitor/page.tsx
import {revalidatePath} from "next/cache";
import {getLatestN} from "@/utils/thingspeak/queries";
import MonitorForm from "./monitor-form";
import {ingestBackfillLoop, ingestLatestFeeds} from "@/app/actions/thingspeak";

export default async function MonitorPage() {
  async function refreshAction(formData: FormData) {
    "use server";
    await ingestLatestFeeds(200);
    revalidatePath("/monitor");
  }

  async function loadOlderAction(formData: FormData) {
    "use server";
    await ingestBackfillLoop({batch: 500, iterations: 5});
    revalidatePath("/monitor");
  }

  const rows = await getLatestN(5000);

  return (
    <main className="p-6 space-y-6">
      <MonitorForm
        initialData={rows}
        refreshAction={refreshAction}
        loadOlderAction={loadOlderAction}
      />
    </main>
  );
}
