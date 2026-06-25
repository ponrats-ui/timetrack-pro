# Changelog

All notable changes to TimeTrack Pro will be documented in this file.

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
