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

## Current Features

- Thai work record form with live income and OT calculation.
- Offline Drift storage for work records and payroll settings.
- Thai settings screen for salary, wage, OT rates, deductions, company, and
  employee details.
- Configurable payroll rule engine for normal days, weekends, public holidays,
  night shifts, OT multipliers, allowances, tax, and social security.
- First-run Thai welcome screen with real-use and demo-data paths.
- Demo mode with 30 days of sample work records for exploring dashboard,
  calendar, reports, PDF, and Excel before entering real data.
- Safe demo reset that deletes only sample records.
- Monthly summary screen with HR identity fields, gross income, expenses,
  deductions, and final net income.
- Professional HR PDF export with Thai font support, daily table, summaries,
  deductions, and signature section.
- Excel export with Summary, Daily Records, and Settings sheets.
- Share flow for generated PDF and Excel files.
- Export history persisted in Drift with format, export date, and file name.
- Thai monthly calendar with day markers for work type, OT, and expenses.
- Monthly dashboard cards and charts for income, net income, OT, working days,
  expenses, and income versus expense trends.
- Search records by note, exact date, or month.
- Filter records by OT, holiday, weekend, and expenses.
- Sort records by newest, oldest, highest income, or highest OT.
- Weekly, monthly, and yearly statistics for beta release review.
- Responsive list and monthly layouts for mobile and tablet widths.

## Web Drift Assets

Drift on web requires `sqlite3.wasm` and `drift_worker.dart.js` in the `web/`
folder before runtime database access is enabled in a browser.

Follow the Drift web prerequisites before shipping web builds:

```powershell
dart run drift_dev schema dump lib/src/core/database/app_database.dart drift_schemas
```

Then add the required WASM and worker assets according to the current Drift
documentation.

## Payroll Rule Engine

Payroll calculations use one shared engine in
`lib/src/features/time_records/application/work_calculator.dart`. The engine
reads only the configurable `PayrollRules` derived from saved settings, so
dashboard cards, calendar summaries, monthly reports, PDF export, and Excel
export stay consistent.

See `docs/PAYROLL_ENGINE.md` for the current rule model and migration notes.

## Demo Mode

New users can choose `ทดลองด้วยข้อมูลตัวอย่าง` from the welcome screen or empty
record list. Demo records are marked internally and can be removed from
Settings without deleting real records.

See `docs/DEMO_MODE.md` for details.

## Development

```powershell
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test
flutter build web
flutter run -d chrome
```

## Subscription Status

Subscriptions are intentionally not implemented yet. The project is structured
so trial/subscription services can be added later without changing feature UI
or persistence boundaries.
