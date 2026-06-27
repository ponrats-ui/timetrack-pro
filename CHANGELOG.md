# Changelog

All notable changes to TimeTrack Pro will be documented in this file.

## Unreleased

### Added

- Added configurable payroll rules for normal days, weekends, public holidays,
  night shifts, OT, meal allowance, travel allowance, other allowance, tax, and
  social security.
- Added grouped Payroll Settings sections for salary, overtime, allowances,
  deductions, and company information.
- Added Drift migration for the expanded payroll settings without removing
  existing user data.
- Added payroll engine documentation in `docs/PAYROLL_ENGINE.md`.
- Added unit coverage for normal days, weekends, holidays, night shifts,
  configurable OT multipliers, allowances, tax, and social security.

### Changed

- Updated calculator, dashboard, calendar, HR reports, PDF export, and Excel
  export to share the same payroll calculation engine.
- Preserved legacy OT setting columns for migration compatibility while the
  app reads the new named payroll rules.

### Not Added

- Subscription, Firebase, and AI features remain out of scope.

## 0.6.0 - 2026-06-25

### Added

- Added record search by note, date text, exact date, and month.
- Added filters for OT-only, holiday, weekend, and records with expenses.
- Added sorting by newest, oldest, highest income, and highest OT.
- Added weekly, monthly, and yearly statistics summaries.
- Added tests for record query behavior and period statistics.

### Changed

- Improved list empty states, no-result states, delete confirmation, snackbar
  feedback, spacing, and tablet-width layout.
- Improved monthly dashboard responsiveness and export button layout.

### Not Added

- Subscription or billing flows remain out of scope.

## 0.5.0 - 2026-06-25

### Added

- Added Thai monthly calendar view with markers for normal work days,
  weekends, public holidays, OT, and expenses.
- Added selected-date summary with check-in/check-out details, work hours, OT,
  income, expense, note, and shortcuts to add or edit records.
- Added monthly dashboard cards for gross income, net income, OT hours, working
  days, and expenses.
- Added dashboard charts for income by day, OT by day, expenses by day, and
  income versus expense summary.
- Added tests for calendar date grouping, monthly dashboard aggregation, and
  chart data generation.

### Not Added

- Subscription or billing flows remain out of scope.

## 0.4.0 - 2026-06-25

### Added

- Added professional HR PDF export with Thai font support, monthly summary,
  daily work table, income summary, deduction summary, and signature section.
- Added Excel export with Summary, Daily Records, and Settings sheets.
- Added export history persistence in Drift with format, export date, and file
  name.
- Added PDF and Excel share flow from the monthly report screen.
- Added tests for PDF generation, Excel generation, and export history.

### Not Added

- PDF/Excel visual template customization remains planned for a future sprint.
- Subscription or billing flows remain out of scope.

## 0.3.0 - 2026-06-25

### Added

- Added Thai settings screen for salary, wage, break, OT rates, allowances,
  deductions, company name, employee name, and employee ID.
- Persisted expanded payroll settings in Drift with a safe schema migration.
- Added HR monthly report domain models and report service foundation.
- Updated monthly report to show company/employee identity and deduction
  breakdown.
- Added tests for report summaries, deductions, and settings persistence.

### Not Added

- PDF and Excel generation remain planned for a future sprint.
- Subscription or billing flows remain out of scope.

## 0.1.0 - 2026-06-25

### Added

- Initialized standalone Flutter project in `C:\timetrack-pro`.
- Added Android, iOS, Windows, and Web platform targets.
- Added Riverpod app root and feature-first source structure.
- Added Drift database foundation with a `work_entries` table.
- Added repository/provider boundaries for time record persistence.
- Added Thai mobile-first placeholder shell with four primary tabs.
- Added README and roadmap documentation.

### Not Added

- Subscription or billing flows are intentionally out of scope for this phase.
