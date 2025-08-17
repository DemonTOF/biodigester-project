"use client";

import * as React from "react";
import {Area, AreaChart, CartesianGrid, ResponsiveContainer, XAxis, YAxis,} from "recharts";

import {Card, CardContent, CardHeader, CardTitle,} from "@/components/ui/card";
import {Button} from "@/components/ui/button";
import {Switch} from "@/components/ui/switch";
import {Label} from "@/components/ui/label";
import {Input} from "@/components/ui/input";

import {
  type ChartConfig,
  ChartContainer,
  ChartLegend,
  ChartTooltip,
  ChartTooltipContent,
  seriesColor,
} from "@/components/ui/chart";

export type FeedRow = {
  ts_iso: string;
  field1: number | null;
  field2: number | null;
  field3: number | null;
  field4?: number | null;
  field5?: number | null;
  field6?: number | null;
  field7?: number | null;
  field8?: number | null;
};

type PresetRange = "24h" | "7d" | "30d" | "all";
type Mode = "preset" | "custom";

type MonitorFormProps = {
  initialData: FeedRow[];
  refreshAction?: (formData: FormData) => Promise<void> | void;
  loadOlderAction?: (formData: FormData) => Promise<void> | void;
};

const channelLabels = {
  field1: "Concentacion Metano (ppm)",
  field2: "Concetración Metano (ppm)",
  field3: "pH",
  field8: "Alertas",
} as const;

const chartConfig: ChartConfig = {
  field1: {label: channelLabels.field1, color: "hsl(var(--chart-1))"},
  field2: {label: channelLabels.field2, color: "hsl(var(--chart-2))"},
  field3: {label: channelLabels.field3, color: "hsl(var(--chart-3))"},
};

export default function MonitorForm({
                                      initialData,
                                      refreshAction,
                                      loadOlderAction,
                                    }: MonitorFormProps) {
  // Modo y rangos
  const [mode, setMode] = React.useState<Mode>("preset");
  const [preset, setPreset] = React.useState<PresetRange>("all");

  // Rango custom (valores de <input type="datetime-local">)
  const [fromLocal, setFromLocal] = React.useState<string>("");
  const [toLocal, setToLocal] = React.useState<string>("");

  // Visibilidad de series
  const [showF1, setShowF1] = React.useState(true);
  const [showF2, setShowF2] = React.useState(true);
  const [showF3, setShowF3] = React.useState(true);

  // Datos filtrados según modo
  const filtered = React.useMemo(() => {
    if (mode === "preset") {
      return filterByPreset(initialData, preset);
    } else {
      // custom
      const fromIso = fromLocal ? new Date(fromLocal).toISOString() : undefined;
      const toIso = toLocal ? new Date(toLocal).toISOString() : undefined;
      return filterByCustom(initialData, fromIso, toIso);
    }
  }, [initialData, mode, preset, fromLocal, toLocal]);

  // Downsample + mapeo a la forma que espera Recharts
  const data = React.useMemo(() => {
    const reduced = downsample(filtered, 6000);
    return reduced.map((r) => ({
      time: r.ts_iso,
      field1: r.field1 ?? undefined,
      field2: r.field2 ?? undefined,
      field3: r.field3 ?? undefined,
    }));
  }, [filtered]);

  // Helpers UI
  const applyPreset = (p: PresetRange) => {
    setMode("preset");
    setPreset(p);
  };

  const applyCustom = () => {
    setMode("custom");
  };

  const resetCustom = () => {
    setFromLocal("");
    setToLocal("");
    setMode("preset");
    setPreset("all");
  };

  return (
    <div className="grid gap-6">
      {/* Controles */}
      <Card className="p-4">
        <div className="flex flex-col gap-4">
          {/* Fila 1: presets + toggles + acciones */}
          <div className="flex flex-wrap items-center gap-3">
            <div className="flex items-center gap-2">
              <span className="text-sm font-medium">Rango:</span>
              <div className="flex gap-2">
                <Button
                  size="sm"
                  variant={mode === "preset" && preset === "24h" ? "default" : "outline"}
                  onClick={() => applyPreset("24h")}
                >
                  24h
                </Button>
                <Button
                  size="sm"
                  variant={mode === "preset" && preset === "7d" ? "default" : "outline"}
                  onClick={() => applyPreset("7d")}
                >
                  7 días
                </Button>
                <Button
                  size="sm"
                  variant={mode === "preset" && preset === "30d" ? "default" : "outline"}
                  onClick={() => applyPreset("30d")}
                >
                  30 días
                </Button>
                <Button
                  size="sm"
                  variant={mode === "preset" && preset === "all" ? "default" : "outline"}
                  onClick={() => applyPreset("all")}
                >
                  Todo
                </Button>
              </div>
            </div>

            <div className="h-6 w-px bg-muted mx-2"/>

            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2">
                <Switch id="f1" checked={showF1} onCheckedChange={setShowF1}/>
                <Label htmlFor="f1" className="cursor-pointer text-sm">
                  {chartConfig.field1?.label ?? "field1"}
                </Label>
              </div>
              <div className="flex items-center gap-2">
                <Switch id="f2" checked={showF2} onCheckedChange={setShowF2}/>
                <Label htmlFor="f2" className="cursor-pointer text-sm">
                  {chartConfig.field2?.label ?? "field2"}
                </Label>
              </div>
              <div className="flex items-center gap-2">
                <Switch id="f3" checked={showF3} onCheckedChange={setShowF3}/>
                <Label htmlFor="f3" className="cursor-pointer text-sm">
                  {chartConfig.field3?.label ?? "field3"}
                </Label>
              </div>
            </div>

            <div className="h-6 w-px bg-muted mx-2"/>
          </div>

          {/* Fila 2: rango custom */}
          <div className="flex flex-wrap items-end gap-3">
            <div className="flex flex-col gap-1">
              <Label htmlFor="from">Desde</Label>
              <Input
                id="from"
                type="datetime-local"
                value={fromLocal}
                onChange={(e) => setFromLocal(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1">
              <Label htmlFor="to">Hasta</Label>
              <Input
                id="to"
                type="datetime-local"
                value={toLocal}
                onChange={(e) => setToLocal(e.target.value)}
              />
            </div>
            <div className="flex gap-2">
              <Button size="sm" onClick={applyCustom} variant={mode === "custom" ? "default" : "outline"}>
                Aplicar
              </Button>
              <Button size="sm" variant="ghost" onClick={resetCustom}>
                Reset
              </Button>
            </div>
          </div>
        </div>
      </Card>

      {/* Gráfico */}
      <Card>
        <CardHeader>
          <CardTitle>Monitoreo de sensores</CardTitle>
        </CardHeader>
        <CardContent>
          {data.length === 0 ? (
            <div className="text-sm text-muted-foreground p-6">
              No hay datos para el rango seleccionado. Probá con “Todo”, ajustá el rango custom,
              o presioná “Cargar históricos”.
            </div>
          ) : (
            <ChartContainer config={chartConfig} className="w-full">
              <div className="h-[420px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={data} margin={{top: 8, right: 16, bottom: 8, left: 0}}>
                    <defs>
                      {["field1", "field2", "field3"].map((k) => (
                        <linearGradient id={`fill-${k}`} x1="0" y1="0" x2="0" y2="1" key={k}>
                          <stop offset="5%" stopColor={cssVar(seriesColor(k))} stopOpacity={0.4}/>
                          <stop offset="95%" stopColor={cssVar(seriesColor(k))} stopOpacity={0.05}/>
                        </linearGradient>
                      ))}
                    </defs>

                    <CartesianGrid strokeDasharray="3 3"/>
                    <XAxis
                      dataKey="time"
                      minTickGap={32}
                      tickFormatter={(v) => formatTimeTick(v)}
                    />
                    <YAxis/>
                    <ChartTooltip
                      content={
                        <ChartTooltipContent
                          labelFormatterAction={(l) =>
                            new Date(l as string).toLocaleString("es-PY", {timeZone: "America/Asuncion"})
                          }
                          valueFormatterAction={(v) => (v == null ? "—" : v)}
                        />
                      }
                    />
                    <ChartLegend/>

                    {showF1 && (
                      <Area
                        type="monotone"
                        dataKey="field1"
                        name={chartConfig.field1?.label}
                        stroke={cssVar(seriesColor("field1"))}
                        fill={`url(#fill-field1)`}
                        strokeWidth={2}
                        dot={false}
                        isAnimationActive={false}
                      />
                    )}
                    {showF2 && (
                      <Area
                        type="monotone"
                        dataKey="field2"
                        name={chartConfig.field2?.label}
                        stroke={cssVar(seriesColor("field2"))}
                        fill={`url(#fill-field2)`}
                        strokeWidth={2}
                        dot={false}
                        isAnimationActive={false}
                      />
                    )}
                    {showF3 && (
                      <Area
                        type="monotone"
                        dataKey="field3"
                        name={chartConfig.field3?.label}
                        stroke={cssVar(seriesColor("field3"))}
                        fill={`url(#fill-field3)`}
                        strokeWidth={2}
                        dot={false}
                        isAnimationActive={false}
                      />
                    )}
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            </ChartContainer>
          )}
        </CardContent>
      </Card>
    </div>
  );
}

/* =========================
 * Helpers
 * ========================= */

function filterByPreset(rows: FeedRow[], range: PresetRange) {
  if (range === "all") return rows;
  const now = Date.now();
  const ms =
    range === "24h" ? 86400000 :
      range === "7d" ? 604800000 :
        2592000000;
  const cutoff = now - ms;
  return rows.filter((r) => new Date(r.ts_iso).getTime() >= cutoff);
}

function filterByCustom(rows: FeedRow[], fromIso?: string, toIso?: string) {
  let out = rows;
  if (fromIso) {
    const fromMs = new Date(fromIso).getTime();
    out = out.filter((r) => new Date(r.ts_iso).getTime() >= fromMs);
  }
  if (toIso) {
    const toMs = new Date(toIso).getTime();
    out = out.filter((r) => new Date(r.ts_iso).getTime() <= toMs);
  }
  return out;
}

// Downsampling simple para performance
function downsample<T>(arr: T[], maxPoints: number): T[] {
  if (arr.length <= maxPoints) return arr;
  const step = Math.ceil(arr.length / maxPoints);
  const out: T[] = [];
  for (let i = 0; i < arr.length; i += step) out.push(arr[i]);
  return out;
}

function formatTimeTick(iso: string) {
  const d = new Date(iso);
  return `${pad(d.getUTCMonth() + 1)}/${pad(d.getUTCDate())} ${pad(d.getUTCHours())}:${pad(d.getUTCMinutes())}`;
}

function pad(n: number) {
  return n < 10 ? `0${n}` : String(n);
}

function cssVar(s: string) {
  return s;
}
