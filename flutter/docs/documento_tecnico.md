# Sistema de Monitoreo Autónomo del Control para Procesos de Digestión Anaerobia con Transmisión de Datos en Tiempo Real

## Implementación de la Aplicación Móvil Multiplataforma con Flutter

---

**Autor:** [Nombre del Autor]

**Trabajo de Grado, Ingeniería Electrónica, 2025.**

**Universidad de Ibagué**

---

## Resumen

El presente documento describe el diseño, desarrollo e implementación de la aplicación móvil multiplataforma "Biodigester Mobile", desarrollada en el framework Flutter. Esta aplicación forma parte de un sistema de monitoreo autónomo para procesos de digestión anaerobia, permitiendo la visualización en tiempo real de variables críticas como la concentración de metano (CH₄) y el nivel de pH. La aplicación se comunica con la plataforma ThingSpeak para la adquisición de datos provenientes de sensores IoT y utiliza Supabase como backend para la autenticación de usuarios y el almacenamiento persistente de los registros. El desarrollo se realizó utilizando arquitectura feature-based con gestión de estado mediante Riverpod, garantizando escalabilidad, mantenibilidad y un rendimiento óptimo en múltiples plataformas (Android, iOS, Web).

---

## 3. Diseño e Implementación de la Aplicación Móvil

### 3.1 Sistema de Monitoreo

El sistema de monitoreo está compuesto por una red de sensores IoT que capturan variables críticas del proceso de digestión anaerobia. Estos sensores transmiten los datos de manera inalámbrica a la plataforma ThingSpeak, que actúa como intermediario entre los dispositivos físicos y la aplicación móvil.

Las variables monitoreadas son:

- **Metano (CH₄):** Concentración en partes por millón (ppm), indicadora de la eficiencia del proceso de biodigestión.
- **pH:** Nivel de acidez o alcalinidad del biodigestor, parámetro fundamental para el mantenimiento de las condiciones óptimas de las bacterias metanogénicas.

Los datos son capturados por los sensores y transmitidos al canal de ThingSpeak con ID `2621081`, el cual almacena los registros en campos individuales (field1 para metano, field2 para pH) con marcas de tiempo en formato ISO 8601.

> **[Referencia: FLUJO-DATOS]** — Diagrama de secuencia que ilustra el flujo completo de datos desde los sensores hasta la visualización en la interfaz de usuario.

---

### 3.2 Diseño de la Aplicación Multiplataforma con Flutter

A continuación, se presenta el diseño y desarrollo de la aplicación móvil multiplataforma teniendo en cuenta el objetivo del proyecto, alcance, escalabilidad, rendimiento y optimización de la aplicación.

#### 3.2.1 Objetivo del Aplicativo Móvil

El desarrollo de la aplicación tiene como objetivo obtener los datos en tiempo real de las variables enviadas por el sistema de monitoreo al servidor web, lo que agiliza el análisis de datos, previene errores en el sistema de control de digestión anaerobia, facilita la comunicación entre los investigadores y permite un acceso rápido e inmediato a la información. Para diseñar la aplicación se plantearon historias de usuario que facilitan las tareas de desarrollo.

A continuación, se presentan las historias de usuario:

**Splash (Inicio de la aplicación):**

- El usuario visualiza por 2 segundos el logo de la aplicación (Logo de la Universidad de Ibagué).

**Login:**

- El usuario puede ingresar con el correo electrónico y contraseña a la aplicación.
- La autenticación se realiza de forma segura a través de Supabase Auth.
- El sistema permite el modo de desarrollo con autenticación omitida (BYPASS_AUTH).

**Registro:**

- El usuario puede registrarse a la aplicación por medio de un formulario donde se requerirá el correo electrónico y una contraseña.
- Tras el registro exitoso, se muestra un mensaje de confirmación y se redirige al usuario a la pantalla de login.

**Funciones de la aplicación:**

- Al ingresar a la aplicación, el usuario puede realizar la ingestión de los últimos registros obtenidos del sistema de monitoreo desde ThingSpeak.
- El usuario puede visualizar los datos obtenidos a través de gráficas interactivas de diagramas de área (AreaSeries) para las variables de metano y pH.
- El usuario puede filtrar los datos obtenidos seleccionando un rango de fechas personalizado (desde/hasta) con un selector de fecha y hora con pestañas.
- El usuario puede exportar los datos filtrados en un archivo de formato CSV y compartirlo a través de las aplicaciones instaladas en el dispositivo.
- El usuario puede visualizar información contextual sobre el sistema de monitoreo dentro de la aplicación.
- El usuario puede diferenciar registros que no cumplan con el funcionamiento normal del sistema de control de manera visual a través de las gráficas.

**Funciones del usuario dentro de la aplicación:**

- El usuario puede iniciar y cerrar sesión con diferentes cuentas previamente registradas.
- El usuario puede compartir archivos CSV exportados por aplicaciones que seleccione (Correo electrónico, WhatsApp, etc.).
- El usuario puede hacer zoom y desplazarse interactivamente en las gráficas para analizar períodos específicos.

#### 3.2.2 Flujo de Navegación de la Aplicación

A partir de las historias de usuario se diseñó el flujo de navegación de la aplicación. El flujo tiene como base una experiencia sencilla e intuitiva para usuarios que tengan conocimiento de uso de aplicaciones móviles.

> **[Referencia: FLUJO-NAVEGACION]** — Diagrama de flujo que muestra la navegación entre las pantallas de Login y Registro.

El flujo de navegación inicial está compuesto por dos pantallas de navegación:

- **Pantalla de Login:** Corresponde al ingreso con el correo electrónico y la contraseña del usuario previamente registrado. Al ingresar con las credenciales, el usuario es dirigido a la pantalla principal de la aplicación. Si no posee una cuenta, puede acceder al formulario de registro.

- **Pantalla de Registro:** Corresponde al formulario para poder ingresar a la aplicación, donde se piden datos básicos al usuario (correo electrónico y contraseña) para poder usar la aplicación y tener el registro de los usuarios que la usan.

> **[Referencia: FLUJO-PRINCIPAL]** — Diagrama de componentes que muestra la navegación principal de la aplicación con sus dos pestañas.

El flujo de navegación principal está compuesto por un **BottomNavigationBar** con dos pestañas, las cuales cumplen las siguientes funciones:

- **Pantalla 1 (Ingestion - HomePage):** Muestra dos secciones principales: "Ingerir últimos registros" y "Backfill hacia atrás". La primera permite descargar los últimos 20 registros desde ThingSpeak y guardarlos en Supabase, mostrando un indicador de resultado (éxito con conteo de insertados/omitidos, o error). La segunda sección está preparada para cargas históricas en tandas.

- **Pantalla 2 (Monitoreo - MonitorPage):** Contiene un selector de rango de fechas (Desde/Hasta) con un diálogo personalizado de selección de fecha y hora con pestañas. Muestra dos gráficas interactivas: una para la variable de Metano (ppm) en color rojo y otra para pH en color azul. Incluye botones para restablecer filtros, refrescar datos y exportar a CSV.

#### 3.2.3 Almacenamiento de Datos

Los datos recolectados por el sistema de monitoreo se almacenan en dos plataformas complementarias:

**ThingSpeak (Almacenamiento IoT):**

Los datos provenientes de los sensores se almacenan en el canal "Monitoring system" de la plataforma ThingSpeak, un canal con acceso privado (requiere llave de API) que cuenta con campos de datos para las variables del sistema de monitoreo. La plataforma ofrece servicios REST para leer, escribir, eliminar y actualizar los datos del canal.

**Supabase (Almacenamiento de Aplicación):**

Para el almacenamiento de datos de la aplicación, se utiliza Supabase, que proporciona:

- **Autenticación de usuarios:** Servicio de autenticación con email y contraseña, integrado directamente con la aplicación Flutter.
- **Base de datos PostgreSQL:** Almacenamiento persistente de los datos ingeridos desde ThingSpeak en la tabla `thingspeak_feed`, que contiene los campos: `channel_id`, `entry_id`, `ts_iso` (marca de tiempo ISO 8601), `field1` a `field8` (datos de sensores), y `raw` (JSON con los datos originales).

La estructura de la tabla `thingspeak_feed` en Supabase:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `channel_id` | integer | ID del canal de ThingSpeak |
| `entry_id` | integer | ID del registro en ThingSpeak |
| `ts_iso` | timestamp | Marca de tiempo en formato ISO 8601 |
| `field1` | double | Valor de Metano (ppm) |
| `field2` | double | Valor de pH |
| `field3` - `field8` | double | Campos adicionales reservados |
| `raw` | jsonb | Datos originales JSON de ThingSpeak |

#### 3.2.4 Creación de Servicios REST

##### API's de ThingSpeak

La plataforma de almacenamiento ThingSpeak ofrece los servicios necesarios para poder leer, escribir, eliminar y actualizar los datos del canal emitidos por el sistema de monitoreo. La aplicación descarga los datos en formato JSON y los almacena en Supabase para su posterior visualización.

Los servicios utilizados son:

**Obtener los últimos registros del canal:**

Utiliza la petición HTTP GET a través de la siguiente URL:

```
https://api.thingspeak.com/channels/<channel_Id>/feeds.json
  ?api_key=<api_key>
  &results=<numberOfResults>
  &sort=desc
  &timezone=<continent/city>
```

La URL está compuesta por los siguientes parámetros:

- **channel_Id:** Número de identificación del canal que almacena los datos del sistema de monitoreo. El ID de este proyecto es `2621081`.
- **api_key:** Llave de identificación para permitir leer y escribir datos en el canal. Siempre se debe incluir en cualquier petición que se realice al canal.
- **results:** Número de registros a obtener (máximo 8000). En este proyecto se utilizan los últimos 20 registros por defecto.
- **sort:** Orden de los resultados (`desc` para descendente, `asc` para ascendente).
- **continent/city:** Configura la hora de registro del dato al continente y ciudad seleccionados. En este proyecto se usa `America/Asuncion`.

**Obtener el último entry_id almacenado:**

Antes de insertar nuevos registros, la aplicación consulta el `entry_id` máximo existente en Supabase para evitar duplicados:

```sql
SELECT entry_id
FROM thingspeak_feed
WHERE channel_id = <channel_id>
ORDER BY entry_id DESC
LIMIT 1;
```

> **[Referencia: FLUJO-DATOS]** — Diagrama de secuencia que muestra el proceso completo de ingestión de datos.

##### API's de Supabase

La aplicación utiliza las siguientes operaciones a través del cliente Supabase:

- **Autenticación:** `signInWithPassword(email, password)` y `signUp(email, password)` para gestión de sesiones de usuario.
- **Consulta de datos:** `select('ts_iso, field1, field2').gte('ts_iso', start).lte('ts_iso', end).order('ts_iso')` para obtener registros filtrados por rango de fechas.
- **Inserción de datos:** `upsert(rows)` para insertar o actualizar registros en la tabla `thingspeak_feed`.
- **Consulta de máximo entry_id:** `select('entry_id').order('entry_id', ascending: false).limit(1)` para determinar el último registro almacenado.

#### 3.2.5 Dependencias y Librerías Utilizadas

La comunidad de desarrolladores de Flutter ha creado paquetes y SDK's que facilitan la implementación de funciones y agilizan el desarrollo de aplicaciones móviles multiplataforma. Dentro de este proyecto se usaron los siguientes paquetes y SDK's con sus respectivas funciones:

| Paquete | Versión | Función |
|---------|---------|---------|
| **supabase_flutter** | ^2.8.1 | SDK oficial de Supabase para Flutter. Proporciona autenticación de usuarios y almacenamiento en base de datos PostgreSQL en tiempo real. |
| **flutter_riverpod** | ^3.1.0 | Framework de gestión de estado basado en Provider, pero con mejoras significativas en tipado, testing y escalabilidad. |
| **riverpod_annotation** | ^4.0.0 | Anotaciones para Riverpod que permiten la generación automática de código con `build_runner`. |
| **syncfusion_flutter_charts** | ^32.2.7 | Librería de gráficos interactivos de alto rendimiento. Permite implementar gráficas de área, líneas, barras y diagramas estadísticos con soporte para zoom, paneo y tooltips. |
| **csv** | ^6.0.0 | Paquete para la conversión de datos tabulares a formato CSV (Comma-Separated Values). |
| **path_provider** | ^2.1.3 | Proporciona acceso a directorios del sistema operativo (temporales, documentos, descargas). |
| **share_plus** | ^10.1.4 | Permite compartir archivos y contenido a través de las aplicaciones instaladas en el dispositivo. |
| **http** | ^1.2.2 | Cliente HTTP para realizar peticiones a servicios web REST. |
| **intl** | ^0.19.0 | Formateo de fechas y números according a la localización del usuario. |
| **flutter_dotenv** | ^5.1.0 | Carga variables de entorno desde archivos `.env` para configuración sensible. |
| **cupertino_icons** | ^1.0.8 | Iconos estilo iOS para la interfaz de usuario. |

Los paquetes nombrados anteriormente tienen en común el uso de código abierto (Open source) y están respaldados por una comunidad activa de desarrolladores.

---

### 3.3 Implementación de la Aplicación Móvil

La aplicación móvil del presente proyecto fue desarrollada en el framework **Flutter** utilizando el lenguaje de programación **Dart**. Actualmente la aplicación cuenta con **12 clases** organizadas en una arquitectura feature-based que separa claramente la lógica de negocio de la presentación.

> **[Referencia: ARQUITECTURA-PAQUETES]** — Diagrama de paquetes que muestra la arquitectura completa de la aplicación con sus dependencias.

#### 3.3.1 Arquitectura Feature-Based

La implementación está dividida en dos carpetas principales:

- **core/**: Contiene los servicios compartidos y widgets reutilizables a través de toda la aplicación.
- **features/**: Contiene las funcionalidades organizadas por dominio (auth, home, monitoring), cada una con su estructura interna de presentación y datos.

Ilustración 7: Arquitectura de los paquetes de la aplicación móvil (Fuente: Autores).

> **[Placeholder para imagen: Arquitectura de carpetas de la aplicación Flutter]**

Cada una de las carpetas contiene más paquetes y clases que realizan funciones específicas de la aplicación con la más mínima responsabilidad posible. A continuación, se muestra de manera más detallada la arquitectura de la aplicación:

Ilustración 8: Arquitectura detallada de paquetes de la aplicación móvil (Fuente: Autores).

> **[Placeholder para imagen: Arquitectura detallada de paquetes con clases]**

#### 3.3.2 Detalle de Paquetes

**core/services/:**

- **SupabaseService:** Clase estática que inicializa y gestiona la conexión con Supabase. Proporciona acceso al cliente de Supabase, al usuario actual, a la sesión actual y al modo de desarrollo (BYPASS_AUTH). La inicialización se realiza cargando las variables de entorno desde el archivo `.env` mediante `flutter_dotenv`.

- **ThingSpeakService:** Clase que implementa la lógica de ingestión de datos desde ThingSpeak. Contiene los métodos `getMaxEntryId()` para obtener el último registro almacenado y `ingestLatestFeeds()` para descargar, filtrar e insertar nuevos registros en Supabase. Utiliza las credenciales del archivo `.env` para la conexión al canal de ThingSpeak.

**core/widgets/:**

- **ShadCard:** Widget reutilizable de tarjeta con estilo inspirado en ShadCN. Soporta título, subtítulo y un widget hijo como contenido. Se utiliza consistentemente en todas las pantallas de la aplicación para mantener un diseño uniforme.

**features/auth/presentation/pages/:**

- **LoginPage:** Pantalla de inicio de sesión con campos de email y contraseña. Implementa validación de credenciales a través de Supabase Auth, muestra indicadores de carga y mensajes de error. Incluye un enlace al formulario de registro.

- **SignupPage:** Pantalla de registro con campos de email y contraseña. Implementa el registro de nuevos usuarios a través de Supabase Auth. Muestra un SnackBar de confirmación y redirige al usuario a la pantalla de login tras un registro exitoso.

**features/home/presentation/pages/:**

- **HomePage:** Pantalla principal de la pestaña "Ingestion". Contiene dos secciones: "Ingerir últimos registros" que descarga y almacena los últimos 20 registros desde ThingSpeak, y "Backfill hacia atrás" preparada para cargas históricas. Muestra resultados de la operación con indicadores visuales de éxito o error.

**features/monitoring/:**

- **MonitorRepository:** Clase encargada de la comunicación con Supabase para la consulta de datos. Contiene el método `fetchData(startDate, endDate)` que obtiene los registros de la tabla `thingspeak_feed` filtrados por rango de fechas, ordenados cronológicamente.

- **MonitorController:** Controlador de estado basado en Riverpod (generado con `riverpod_annotation`) que gestiona el ciclo de vida de los datos de monitoreo. Mantiene un estado `MonitorDataState` que contiene el filtro activo (fechas de inicio y fin) y los datos obtenidos. Proporciona métodos para actualizar rangos de fechas, restablecer filtros, refrescar datos y exportar a CSV.

- **MonitorController.g.dart:** Archivo generado automáticamente por `build_runner` que contiene la implementación del código generado para el controlador Riverpod.

- **MonitorPage:** Pantalla principal de la pestaña "Monitoreo". Muestra un selector de rango de fechas con diálogo personalizado (TabbedDateTimePickerDialog), dos gráficas interactivas de tipo AreaSeries para Metano y pH, y botones para restablecer, refrescar y exportar datos.

- **TabbedDateTimePickerDialog:** Diálogo personalizado con dos pestañas (Fecha y Hora) para la selección de fechas. Utiliza `CalendarDatePicker` para la selección de fecha y un selector personalizado de tipo `ListWheelScrollView` para la selección de hora, proporcionando una experiencia táctil premium en dispositivos móviles.

> **[Referencia: CICLO-VIDA-ESTADO]** — Diagrama de estados que muestra el ciclo de vida del MonitorController con sus transiciones.

---

### 3.4 Selección de Flutter como Framework de Desarrollo

La selección del framework de desarrollo fue una decisión técnica fundamental que impacta directamente en la mantenibilidad, escalabilidad y alcance de la aplicación. Tras evaluar múltiples alternativas (Android nativo con Kotlin, React Native, Xamarin y Flutter), se seleccionó **Flutter** por las siguientes razones:

**Multiplataforma Nativo:**

Flutter permite compilar una única base de código para múltiples plataformas (Android, iOS, Web, Windows, macOS y Linux) sin sacrificar el rendimiento. A diferencia de soluciones basadas en puentes (React Native) o compilación cruzada (Xamarin), Flutter renderiza cada pixel de la interfaz directamente mediante su propio motor de renderizado (Skia/Impeller), eliminando la dependencia de componentes nativos del sistema operativo.

**Rendimiento Comparable al Nativo:**

Flutter compila a código ARM nativo mediante Dart AOT (Ahead-of-Time), alcanzando rendimiento comparable al de aplicaciones desarrolladas nativamente en Kotlin o Swift. El framework utiliza un motor de renderizado optimizado que permite alcanzar 60/120 FPS en la mayoría de dispositivos, incluso en animaciones complejas y gráficos interactivos.

**Gestión de Estado Avanzada con Riverpod:**

La adopción de Riverpod como framework de gestión de estado proporciona tipado estático completo, inyección de dependencias automática, caching de datos y testing simplificado. A diferencia del patrón Provider original, Riverpod elimina los problemas de contexto y permite un código más limpio y testable.

**Hot Reload y Productividad:**

La funcionalidad de Hot Reload de Flutter permite la modificación del código en tiempo real sin reiniciar la aplicación, reduciendo significativamente el tiempo de desarrollo y depuración. Esta característica es especialmente valiosa en el contexto de un proyecto de investigación donde los cambios de interfaz son frecuentes.

**Ecosistema de Paquetes:**

Flutter cuenta con un ecosistema de más de 40,000 paquetes en pub.dev, cubriendo desde gráficos interactivos (Syncfusion) hasta integración con servicios en la nube (Supabase). La mayoría de los paquetes son de código abierto y están mantenidos por una comunidad activa de desarrolladores.

**Material Design 3:**

Flutter incluye soporte nativo para Material Design 3, el sistema de diseño de Google, proporcionando componentes de interfaz modernos y consistentes sin la necesidad de librerías externas. La aplicación utiliza el esquema de colores basado en `ColorScheme.fromSeed()` para garantizar coherencia visual.

**Comparativa con Android Nativo (Kotlin):**

| Característica | Flutter | Android Nativo (Kotlin) |
|----------------|---------|------------------------|
| Plataforma | Multiplataforma | Solo Android |
| Lenguaje | Dart | Kotlin |
| Rendimiento | Nativo (AOT) | Nativo |
| Hot Reload | Sí | Limitado (Live Edit) |
| UI Rendering | Propio (Skia/Impeller) | Componentes nativos |
| Gestión de Estado | Riverpod, Bloc, Provider | ViewModel, LiveData |
| Curva de Aprendizaje | Moderada | Alta (para multiplataforma) |
| Testing | Integrado (flutter_test) | JUnit, Espresso |
| Comunidad | Creciente (>40k paquetes) | Establecida |

La decisión de utilizar Flutter sobre Android nativo se justifica por la posibilidad de extender la aplicación a otras plataformas (iOS, Web) en el futuro sin un retrabajo significativo, manteniendo un rendimiento comparable al nativo.

---

### 3.5 Configuración del Entorno

La aplicación utiliza variables de entorno para la configuración sensible, evitando la exposición de credenciales en el código fuente. La configuración se realiza a través del archivo `.env` ubicado en la raíz del proyecto.

**Variables de Entorno:**

| Variable | Descripción | Valor de Ejemplo |
|----------|-------------|------------------|
| `SUPABASE_URL` | URL del proyecto Supabase | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Clave anónima de Supabase | `sb_publishable_xxx` |
| `THINGSPEAK_CHANNEL_ID` | ID del canal de ThingSpeak | `2621081` |
| `THINGSPEAK_API_KEY` | Clave de API de ThingSpeak | `DS0O5JWOPSREYKM7` |
| `THINGSPEAK_TIMEZONE` | Zona horaria para registros | `America/Asuncion` |
| `BYPASS_AUTH` | Omitir autenticación (desarrollo) | `true` / `false` |

**Proceso de Configuración:**

1. Clonar el repositorio del proyecto.
2. Copiar el archivo `.env.template` como `.env`.
3. Completar las variables de entorno con las credenciales correspondientes.
4. Ejecutar `flutter pub get` para instalar dependencias.
5. Ejecutar `flutter run` para iniciar la aplicación.

**Consideraciones de Seguridad:**

- El archivo `.env` está incluido en `.gitignore` para evitar su commit al repositorio.
- Las credenciales de Supabase y ThingSpeak nunca se exponen en el código fuente.
- En producción, se recomienda utilizar variables de entorno del sistema o un gestor de secretos.

---

### 3.6 Pruebas

La aplicación incluye una configuración de testing basada en `flutter_test`, el framework de pruebas integrado en Flutter. La estructura de pruebas se encuentra en el directorio `test/` del proyecto.

**Estrategia de Pruebas:**

- **Pruebas Unitarias:** Verificación de la lógica de negocio en aislamiento, incluyendo servicios de Supabase y ThingSpeak, conversión de datos y generación de CSV.
- **Pruebas de Widget:** Validación de la interfaz de usuario y su comportamiento ante interacciones del usuario.
- **Pruebas de Integración:** Verificación del flujo completo de datos desde la ingestión hasta la visualización.

**Comandos de Prueba:**

```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar pruebas con cobertura de código
flutter test --coverage

# Ejecutar pruebas en modo verbose
flutter test --reporter expanded
```

**Herramientas de Calidad de Código:**

- **analysis_options.yaml:** Configuración del analizador estático de Dart con el conjunto de reglas recomendado (`flutter_lints`).
- **build_runner:** Generación automática de código para Riverpod (`monitor_controller.g.dart`).

```bash
# Ejecutar análisis estático
flutter analyze

# Regenerar código generado
dart run build_runner build --delete-conflicting-outputs
```

---

### 3.7 Despliegue

La aplicación Flutter puede ser desplegada en múltiples plataformas desde una única base de código. A continuación, se describen los procesos de build para las principales plataformas.

**Android (APK):**

```bash
# Build de release APK
flutter build apk --release

# Build de app bundle (para Google Play)
flutter build appbundle --release
```

El APK generado se encuentra en `build/app/outputs/flutter-apk/app-release.apk`. Para distribución directa, se puede instalar el APK en dispositivos Android habilitando la instalación de fuentes desconocidas.

**iOS (IPA):**

```bash
# Build de release iOS
flutter build ios --release

# Generar archivo IPA para distribución
flutter build ipa --release
```

El archivo IPA se genera en `build/ios/ipa/`. Para distribución en dispositivos iOS, se requiere una cuenta de desarrollador Apple y la firma del código.

**Web:**

```bash
# Build de release web
flutter build web --release
```

Los archivos web se generan en `build/web/` y pueden ser desplegados en cualquier servidor estático (Firebase Hosting, Netlify, GitHub Pages).

**Configuración de CI/CD (Opcional):**

Para automatizar el proceso de construcción y despliegue, se puede configurar un pipeline de integración continua que ejecute:

1. Análisis estático (`flutter analyze`).
2. Ejecución de pruebas (`flutter test`).
3. Construcción de la aplicación para las plataformas objetivo.
4. Despliegue automático a tiendas de aplicaciones o servidores.

---

### 3.8 Capturas de Pantalla

> **[Placeholder para imagen: Pantalla de Login con campos de email y contraseña]**

> **[Placeholder para imagen: Pantalla de Registro con formulario de email y contraseña]**

> **[Placeholder para imagen: Pantalla principal (Ingestion) con botón de ingesta y resultado]**

> **[Placeholder para imagen: Pantalla de Monitoreo con gráficas de Metano y pH]**

> **[Placeholder para imagen: Diálogo de selección de fecha y hora con pestañas]**

> **[Placeholder para imagen: Exportación de datos en formato CSV]**

---

### 3.9 Repositorio del Código Fuente

El código del proyecto completo se encuentra en el repositorio de GitHub del proyecto biodigester-project, en la carpeta `flutter/`. La estructura del repositorio permite la colaboración entre múltiples desarrolladores y el versionado controlado de los cambios.

---

## 4. Conclusiones

La aplicación móvil "Biodigester Mobile" fue desarrollada exitosamente utilizando el framework Flutter, demostrando las ventajas del desarrollo multiplataforma para aplicaciones de monitoreo en tiempo real. Las principales conclusiones del proyecto son:

1. **Multiplataforma efectiva:** Flutter permite compilar una única base de código para Android, iOS y Web, reduciendo significativamente el tiempo y costo de desarrollo en comparación con soluciones nativas separadas.

2. **Rendimiento comparable al nativo:** La compilación AOT de Dart y el motor de renderizado Flutter proporcionan un rendimiento de 60/120 FPS, incluso con gráficos interactivos y manejo de datos en tiempo real.

3. **Arquitectura escalable:** La implementación de arquitectura feature-based con Riverpod permite una separación clara de responsabilidades, facilitando el mantenimiento y la adición de nuevas funcionalidades.

4. **Integración IoT efectiva:** La comunicación con ThingSpeak y Supabase permite la ingestión, almacenamiento y visualización de datos de sensores de manera eficiente y confiable.

5. **Experiencia de usuario optimizada:** La implementación de gráficos interactivos con Syncfusion, selección de fechas personalizada y exportación CSV proporciona una experiencia completa para el análisis de datos de monitoreo.

**Trabajo Futuro:**

- Implementar notificaciones push para alertas de valores críticos de pH y metano.
- Agregar soporte para múltiples biodigestores con selección de canal.
- Implementar autenticación biométrica (huella dactilar, reconocimiento facial).
- Desarrollar una versión web completa con dashboard administrativo.
- Integrar machine learning para predicción de tendencias y anomalías.
- Implementar sistema de alertas por correo electrónico y SMS.

---

## Referencias

[1] Flutter Documentation. https://flutter.dev/docs

[2] Supabase Documentation. https://supabase.com/docs

[3] ThingSpeak Documentation. https://www.mathworks.com/help/thingspeak/

[4] Riverpod Documentation. https://riverpod.dev/

[5] Syncfusion Flutter Charts. https://www.syncfusion.com/flutter-widgets/flutter-charts

[6] Dart Programming Language. https://dart.dev/

[7] Material Design 3. https://m3.material.io/

---

**Documento generado como parte del Trabajo de Grado de Ingeniería Electrónica, Universidad de Ibagué, 2025.**
