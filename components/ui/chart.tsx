"use client";

import type {ReactNode} from "react";
import * as React from "react";
import {cn} from "@/lib/utils";
import {Legend as RechartsLegend, Tooltip as RechartsTooltip,} from "recharts";

export type ChartConfig = {
  [k: string]: { label?: string; color?: string } | undefined;
};

type ChartContainerProps = React.HTMLAttributes<HTMLDivElement> & {
  config?: ChartConfig;
};

export function ChartContainer({config, className, children, ...props}: ChartContainerProps) {
  const style: React.CSSProperties = {};
  if (config) {
    for (const [key, value] of Object.entries(config)) {
      if (value?.color) (style as any)[`--color-${key}`] = value.color;
    }
  }
  return (
    <div className={cn("flex w-full flex-col gap-2", className)} style={style} {...props}>
      {children}
    </div>
  );
}

export function ChartTooltip(props: React.ComponentProps<typeof RechartsTooltip>) {
  return <RechartsTooltip cursor={{strokeDasharray: "3 3"}} wrapperClassName="!outline-none" {...props} />;
}

/* =========================
 * Tooltip content (tipado propio)
 * ========================= */

type TooltipPayloadItem = {
  color?: string;
  name?: string;
  value?: number | string | null | undefined;
};

type ChartTooltipContentProps = {
  // Props reales que inyecta Recharts
  active?: boolean;
  label?: any;
  payload?: TooltipPayloadItem[];

  // Formatters (Next 15: deben acabar en "Action")
  labelFormatterAction?: (label: any) => ReactNode;
  valueFormatterAction?: (value: any, name: string) => ReactNode;
};

/**
 * Componente compatible con Recharts:
 * Recharts le inyecta (active, label, payload, ...).
 * Evita problemas de tipos con TooltipProps y Next 15.
 */
export function ChartTooltipContent({
                                      active,
                                      label,
                                      payload,
                                      labelFormatterAction,
                                      valueFormatterAction,
                                    }: ChartTooltipContentProps) {
  if (!active || !payload?.length) return null;

  return (
    <div className="rounded-lg border bg-background/95 p-2 text-sm shadow-md">
      <div className="mb-1 font-medium">
        {labelFormatterAction ? labelFormatterAction(label) : String(label)}
      </div>
      <div className="space-y-1">
        {payload.map((item: TooltipPayloadItem, idx: number) => {
          const display =
            valueFormatterAction
              ? valueFormatterAction(item.value, String(item.name ?? ""))
              : item.value;

          return (
            <div key={idx} className="flex items-center gap-2">
              <span className="h-2 w-2 rounded-full" style={{background: item.color ?? "currentColor"}}/>
              <span className="text-muted-foreground">{item.name}:</span>
              <span className="font-medium">{display ?? "—"}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

export function ChartLegend(props: React.ComponentProps<typeof RechartsLegend>) {
  return <RechartsLegend wrapperStyle={{paddingTop: 8}} {...props} />;
}

export function seriesColor(name: string) {
  return `var(--color-${name}, currentColor)`;
}
