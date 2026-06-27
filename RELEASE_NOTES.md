# TimeTrack Pro v0.9.0 Beta Candidate

## Tagline

บันทึกเวลา คำนวณ OT สรุปรายได้ ส่งรายงาน HR

## Beta Focus

- Offline-first work-time recording.
- Configurable payroll rule engine.
- Monthly dashboard, calendar, and HR-ready reports.
- PDF and Excel export.
- Demo mode for first-time exploration.
- Quick Record check-in/check-out for today's work.

## Release Quality Pass

- Standardized Material 3 theme, card radius, button sizing, snackbars,
  dialogs, navigation, and progress indicators.
- Added subtle page and theme transitions.
- Improved tap targets and desktop-width form readability.
- Refreshed TimeTrack Pro web, Android, and iOS app icons.
- Updated PWA manifest, theme color, app description, and web bootstrap.
- Updated Android, iOS, and Windows display names.
- Improved PDF/Excel sharing metadata for supported platforms.
- Reviewed backup/restore UX; no new backup workflow is included in this beta.

## Verification

Run before publishing:

```powershell
dart format lib test
flutter analyze
flutter test
flutter build web
flutter build apk
```

## Not Included

- Subscription.
- Firebase.
- Cloud sync.
- AI features.
