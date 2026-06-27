# Roadmap

## v0.1.0 - Architecture Foundation

- Flutter standalone project.
- Platform targets: Android, iOS, Windows, Web.
- Riverpod state management.
- Drift offline database foundation.
- Feature-first folder structure.
- Basic Thai shell with record, list, daily, and monthly tabs.

## v0.2.0 - Core Time Tracking MVP

- Record form for work date, check-in, check-out, OT, allowance, expense, note,
  and day type.
- CRUD for work entries.
- Daily calculation engine.
- Monthly calculation engine.
- Validation and empty/error states.

## v0.3.0 - HR Reports

- Monthly report screen.
- Income summary.
- OT breakdown.
- Expense summary.
- Net balance.
- Export-ready report model.
- Thai settings screen for payroll and employee metadata.
- HR report service foundation for future PDF/Excel exporters.

## v0.4.0 - Export and Backup

- PDF export.
- Excel export.
- Export history.
- Print/share workflow for generated HR reports.

## v0.5.0 - Calendar and Analytics

- Thai monthly calendar.
- Work record markers by day type, OT, and expenses.
- Selected-day daily summary.
- Add/edit shortcuts from the calendar.
- Monthly dashboard cards.
- Income, OT, expense, and income-versus-expense charts.

## v0.6.0 - Beta Polish

- Record search by date, month, and note.
- Filters for OT, holiday, weekend, and expenses.
- Sorting by date, income, and OT.
- Weekly, monthly, and yearly statistics.
- Improved loading, empty, confirmation, snackbar, spacing, and responsive
  states.

## v0.7.0 - Production Hardening

- CSV export.
- Local backup and restore.
- Import validation.
- Migration tests.
- Golden tests for key reports.
- Error logging boundary.
- Accessibility pass.
- Web Drift asset setup.

## v0.8.0 - Payroll Rule Engine

- Configurable payroll rules for normal work days, weekends, public holidays,
  night shifts, overtime, allowances, tax, and social security.
- Payroll Settings grouped for non-technical users.
- Single calculation engine shared by dashboard, calendar, reports, PDF, and
  Excel.
- Safe Drift migration for existing users.
- Payroll rule documentation and regression tests.

## Future - Trial and Subscription

- Trial period service.
- Subscription entitlement model.
- Platform billing adapters.
- Feature gates for premium exports or automation.

Subscriptions are not implemented in the current phase.
