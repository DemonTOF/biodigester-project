# Biodigester Mobile

App Flutter de monitoreo de un biodigestor que descarga lecturas de un canal de ThingSpeak y las muestra en gráficos. Es offline-first: los datos vivien en una base de datos local y se sincronizan bajo demanda desde ThingSpeak.

## Language

**Feed**:
Una lectura individual del canal de ThingSpeak en un momento dado, identificada de forma única por su `entry_id`.
_Avoid_: registro, muestra, lectura suelta

**Entry ID**:
Identificador entero monotónico que ThingSpeak asigna a cada feed de un canal. Es la clave primaria y la marca de agua alta para la sincronización incremental.
_Avoid_: id, row id

**Channel**:
El canal de ThingSpeak configurado (id + api key) del que se descargan los feeds. Hoy es uno solo, definido en `.env`.
_Avoid_: canal, source

**Field**:
Una de las hasta 8 métricas (`field1`..`field8`) de un feed. En monitoreo se usan `field1` (metano) y `field2` (pH).
_Avoid_: columna, métrica

**ts_iso**:
Marca de tiempo del feed en horario local America/Asuncion, tal como la devuelve ThingSpeak (sin ajuste manual de huso).
_Avoid_: timestamp, fecha

**Sync (Sincronización)**:
Descarga incremental de todos los feeds con `entry_id` mayor al `lastEntryId` local, en lotes de 8000, y actualiza la marca de agua alta.
_Avoid_: ingest, pull

**Force Sync**:
Borra toda la base local y descarga la ventana completa que expone ThingSpeak (los últimos 8000 feeds, ya que el canal ignora `start_id`/`end_id` y solo sirve una ventana rodante).
_Avoid_: reset sync, full reload

**lastEntryId**:
Marca de agua alta (high-water mark) persistida en `syncMeta`: el mayor `entry_id` ya almacenado localmente. Define desde dónde continúa el próximo Sync.
_Avoid_: last id, offset

**lastSyncAt**:
Marca de tiempo de la última sincronización exitosa, persistida en `syncMeta`. Es el "último update" mostrado en la UI.
_Avoid_: last update, sync time

**Startup Sync**:
Sync automático que corre en segundo plano cuando arranca la app.
_Avoid_: auto sync

## Relationships

- Un **Channel** produce muchos **Feeds** (uno por `entry_id`).
- Un **Feed** tiene exactamente un **ts_iso** y hasta ocho **Fields**.
- Un **Sync** lee `lastEntryId` y escribe los nuevos **Feeds** + actualiza `lastEntryId` y `lastSyncAt` en `syncMeta`.
- Un **Force Sync** vacía los **Feeds** y reinicia `lastEntryId` a 0 antes de descargar.

## Example dialogue

> **Dev:** "¿El botón de Sync trae lo mismo que Force Sync?"
> **Domain expert:** "No. **Sync** solo trae lo nuevo desde el `lastEntryId`; **Force Sync** borra todo y baja el historial completo desde el principio."

> **Dev:** "¿Y el timestamp viene en UTC?"
> **Domain expert:** "No, lo pedimos en America/Asuncion, así que `ts_iso` ya viene en horario local y no hay que restar 3 horas."

## Flagged ambiguities

- "last update" se resolvió como `lastSyncAt` (cuándo se sincronizó) y NO como `lastEntryId` (hasta dónde). Ambos existen en `syncMeta` pero significan cosas distintas.
- Se eliminó auth: ya no hay usuario ni sesión; la app entra directo a las pestañas.
