"use client";

import {useActionState} from "react";

import {Card} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Alert} from "@/components/ui/alert";
import {Button} from "@/components/ui/button";

type LatestAction = (
  prevState: any,
  formData: FormData
) => Promise<
  | {
  ok: true;
  requested: number;
  inserted: number;
  skipped: number;
  maxSaved: number;
  newestFetched: number | null;
}
  | { ok: false; error: string }
>;

type BackfillLoopAction = (
  prevState: any,
  formData: FormData
) => Promise<
  | {
  ok: true;
  iterations: number;
  totalInserted: number;
  lastNewOldest: string | null;
  stoppedReason: "empty" | "limit" | "error";
}
  | { ok: false; error: string }
>;

export function IngestLatestCard({
                                   action,
                                   defaultBatch = 20,
                                 }: {
  action: LatestAction;
  defaultBatch?: number;
}) {
  const [state, formAction, pending] = useActionState(action, null);

  return (
    <Card className="p-6 max-w-xl w-full">
      <div className="space-y-4">
        <h2 className="text-xl font-semibold">Ingerir últimos registros</h2>
        <p className="text-sm text-muted-foreground">
          Descarga los últimos N registros desde ThingSpeak (orden descendente) y guarda solo los que no existan aún.
        </p>

        <form action={formAction} className="space-y-4">
          <div className="grid grid-cols-2 items-center gap-3">
            <Label htmlFor="results">Tamaño del batch</Label>
            <Input
              id="results"
              name="results"
              type="number"
              min={1}
              defaultValue={defaultBatch}
              required
            />
          </div>

          <Button type="submit" disabled={pending}>
            {pending ? "Procesando..." : "Ingerir últimos (ThingSpeak → Supabase)"}
          </Button>
        </form>

        {state && "ok" in state && state.ok && (
          <Alert className="mt-2">
            <div className="font-medium">Operación exitosa</div>
            <div className="text-sm">
              Solicitados: {state.requested} • Insertados: {state.inserted} • Omitidos: {state.skipped} •
              Max entry_id en BD: {state.maxSaved} • Más nuevo del batch:{" "}
              {state.newestFetched ?? "—"}
            </div>
          </Alert>
        )}

        {state && "ok" in state && !state.ok && (
          <Alert className="mt-2">
            <div className="font-medium">Error</div>
            <div className="text-sm">{state.error}</div>
          </Alert>
        )}
      </div>
    </Card>
  );
}

export function BackfillLoopCard({
                                   action,
                                   defaultBatch = 200,
                                   defaultIterations = 10,
                                 }: {
  action: BackfillLoopAction;
  defaultBatch?: number;
  defaultIterations?: number;
}) {
  const [state, formAction, pending] = useActionState(action, null);

  return (
    <Card className="p-6 max-w-xl w-full">
      <div className="space-y-4">
        <h2 className="text-xl font-semibold">Backfill hacia atrás</h2>
        <p className="text-sm text-muted-foreground">
          Carga históricos en tandas, pidiendo registros anteriores al más viejo guardado.
        </p>

        <form action={formAction} className="space-y-4">
          <div className="grid grid-cols-2 items-center gap-3">
            <Label htmlFor="batch">Batch por iteración</Label>
            <Input
              id="batch"
              name="batch"
              type="number"
              min={1}
              defaultValue={defaultBatch}
              required
            />
          </div>

          <div className="grid grid-cols-2 items-center gap-3">
            <Label htmlFor="iterations">Iteraciones</Label>
            <Input
              id="iterations"
              name="iterations"
              type="number"
              min={1}
              defaultValue={defaultIterations}
              required
            />
          </div>

          <Button type="submit" disabled={pending}>
            {pending ? "Procesando..." : "Ejecutar backfill"}
          </Button>
        </form>

        {state && "ok" in state && state.ok && (
          <Alert className="mt-2">
            <div className="font-medium">Backfill completado</div>
            <div className="text-sm">
              Iteraciones: {state.iterations} • Total insertado: {state.totalInserted} •
              Último más antiguo: {state.lastNewOldest ?? "—"} • Motivo de parada: {state.stoppedReason}
            </div>
          </Alert>
        )}

        {state && "ok" in state && !state.ok && (
          <Alert className="mt-2">
            <div className="font-medium">Error</div>
            <div className="text-sm">{state.error}</div>
          </Alert>
        )}
      </div>
    </Card>
  );
}
