# Biodigester Mobile - Flutter

This is the Flutter port of the Biodigester project.

## Requisitos Previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
- Android Emulator o dispositivo físico conectado.

## Configuración

1. **Instalar dependencias**:
   ```bash
   cd flutter
   flutter pub get
   ```

2. **Variables de Entorno**:
   El proyecto espera un archivo `.env` en la raíz de la carpeta `flutter`. He copiado tu `.env.local` y lo he configurado. Asegúrate de que las variables tengan estos nombres:
   ```env
   EXPO_PUBLIC_SUPABASE_URL=...
   EXPO_PUBLIC_SUPABASE_ANON_KEY=...
   EXPO_PUBLIC_THINGSPEAK_CHANNEL_ID=...
   EXPO_PUBLIC_THINGSPEAK_API_KEY=...
   EXPO_PUBLIC_THINGSPEAK_TIMEZONE=...
   ```

## Ejecución

Para iniciar la aplicación:

```bash
flutter run
```

## Características

- **Autenticación**: Login y Registro con Supabase.
- **Ingestion**: Panel para cargar datos desde ThingSpeak.
- **Monitoreo**: Gráficos de líneas interactivos usando `fl_chart`.
