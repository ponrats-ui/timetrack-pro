# Business OS Architecture

Business OS is a modular platform of focused Business Assistants.

The architecture should support long-term scalability without creating an
ERP-style monolith.

This document describes direction only. It does not define implementation work
for the current sprint.

## Shared Core

Shared Core is the platform foundation. It should provide reusable
capabilities that Assistants can adopt without duplicating business logic.

Shared Core should eventually include:

- Identity and workspace concepts.
- Shared configuration patterns.
- Shared localization and Thai-first language standards.
- Shared design patterns.
- Shared audit and ownership metadata.
- Shared package and import/export conventions.

## Shared Authentication

Authentication should be reusable across Assistants when Business OS becomes a
multi-product platform.

The current product should not add unnecessary authentication complexity before
customer needs require it.

## Shared Notifications

Notifications should eventually support reminders, approvals, export status,
workflow alerts, and owner summaries.

Notifications must reduce stress, not create noise.

## Shared Reporting

Reports should follow common standards across Assistants:

- Human-readable PDF.
- Spreadsheet-friendly Excel.
- Lightweight CSV where useful.
- Structured JSON for system exchange.
- Future package formats for multi-Assistant workflows.

Reports should be understandable without technical explanation.

## Shared Payroll Engine

Payroll-related calculation logic should remain consistent and reusable across
Employee Assistant workflows.

Future Assistants may consume payroll summaries, but they should not duplicate
payroll rules.

## Shared Import/Export

Import/export should be open by default.

Business OS should support familiar exchange formats and partner systems:

- Excel
- CSV
- PDF
- JSON
- Email
- Accounting software
- Government systems
- APIs

Future package standards:

- TimeTrack Package (`.ttp`) for TimeTrack Pro employee data exchange.
- Business OS Package (`.bos`) for cross-Assistant data exchange.

These package formats are future standards only. They are not implemented yet.

## Future AI Layer

The AI layer should help explain, summarize, warn, recommend, and guide.

AI should not hide uncertainty or replace human responsibility.

AI should operate across Assistants only when data boundaries, permissions, and
customer trust are clear.

## Assistant Boundaries

Every Assistant should own one clear business problem.

TimeTrack Pro owns the Employee Assistant boundary:

- Work records
- Clock in / clock out
- Payroll-ready summaries
- HR reports
- Employee data export
- HR import foundation

TimeTrack Pro is not a standalone ERP.

## Architecture Rule

Build workflows, not feature lists.

Build shared capabilities only when they reduce duplication, reduce mistakes,
or make a customer workflow easier.

Related documents:

- [Technology Strategy](TECHNOLOGY_STRATEGY.md)
- [AI Strategy](AI_STRATEGY.md)
- [Product Strategy](PRODUCT_STRATEGY.md)
- [Open Platform](OPEN_PLATFORM.md)
- [File Standards](FILE_STANDARDS.md)
- [HR Workflow](HR_WORKFLOW.md)
- [Architecture Principles](../.github/ARCHITECTURE_PRINCIPLES.md)
