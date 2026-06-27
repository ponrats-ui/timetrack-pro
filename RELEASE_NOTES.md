# TimeTrack Pro Public Beta Candidate

## Tagline

บันทึกเวลา คำนวณ OT สรุปรายได้ ส่งรายงาน HR

## Beta Focus

- Offline-first work-time recording.
- Configurable payroll rule engine.
- Monthly dashboard, calendar, and HR-ready reports.
- PDF and Excel export.
- Demo mode for first-time exploration.

## Release Quality Pass

- Standardized Material 3 theme, card radius, button sizing, snackbars,
  dialogs, navigation, and progress indicators.
- Added subtle page and theme transitions.
- Improved tap targets and desktop-width form readability.
- Refreshed TimeTrack Pro web, Android, and iOS app icons.
- Updated PWA manifest, theme color, app description, and web bootstrap.
- Updated Android, iOS, and Windows display names.

## Verification

Run before publishing:

```powershell
dart format lib test
flutter analyze
flutter test
flutter build web
```

## Not Included

- Subscription.
- Firebase.
- Cloud sync.
- AI features.
