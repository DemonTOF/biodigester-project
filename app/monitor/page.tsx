import {getLatestN} from "@/utils/thingspeak/queries";
import MonitorForm from "./monitor-form";

export default async function MonitorPage() {

  const rows = await getLatestN(5000);

  return (
    <main className="p-6 space-y-6">
      <MonitorForm
        initialData={rows}
      />
    </main>
  );
}
