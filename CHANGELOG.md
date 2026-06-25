# Changelog

All notable changes to TimeTrack Pro will be documented in this file.

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
