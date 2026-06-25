# TimeTrack Pro

Offline-first Flutter app for drivers and shift workers to track work time,
overtime, allowances, expenses, and HR-ready monthly reports.

## Platform Targets

- Android
- iOS
- Windows
- Web

## Architecture

The app is initialized with a production-oriented Flutter structure:

- `lib/main.dart` - app entry point and Riverpod root scope.
- `lib/src/app` - app shell, theme, and top-level configuration.
- `lib/src/core` - shared constants, database, and infrastructure providers.
- `lib/src/features` - feature-first modules for domain, data, and UI.

State management uses `flutter_riverpod`.

Offline persistence uses `drift` with `drift_flutter`:

- Native platforms store SQLite data in the app documents directory.
- Database access is configured with isolate sharing for future background work.
- Web support is configured through Drift web options.

## Web Drift Assets

Drift on web requires `sqlite3.wasm` and `drift_worker.js` in the `web/`
folder before runtime database access is enabled in a browser.

Follow the Drift web prerequisites before shipping web builds:

```powershell
dart run drift_dev schema dump lib/src/core/database/app_database.dart drift_schemas
```

Then add the required WASM and worker assets according to the current Drift
documentation.

## Development

```powershell
flutter pub get
dart run build_runner build
flutter analyze
flutter test
flutter run -d chrome
```

## Subscription Status

Subscriptions are intentionally not implemented yet. The project is structured
so trial/subscription services can be added later without changing feature UI
or persistence boundaries.
