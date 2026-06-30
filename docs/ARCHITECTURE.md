# Business OS Architecture

Business OS is a modular platform of business assistants.

The architecture should support Thai SMEs without turning into an ERP-style
monolith.

This document is direction only. It does not define implementation work for
this sprint.

## Assistant Architecture

Each assistant solves one real business problem.

Each assistant should be useful alone and able to connect to the broader
Business OS platform when needed.

## Future Shared Platform

Future shared capabilities:

- Authentication
- Database
- Reporting
- Import
- Export
- Notifications
- AI
- Payroll Engine

## Authentication

Authentication should eventually support identity, permissions, company access,
and cross-assistant use.

It should not be added before customer needs require it.

## Database

Database architecture should protect data integrity, auditability, migration
safety, and assistant boundaries.

## Reporting

Reporting should be shared where possible so PDF, Excel, CSV, JSON, and future
packages stay consistent across assistants.

## Import and Export

Import and export should be Open by Default.

Business OS should cooperate with Excel, CSV, PDF, JSON, email, accounting
software, government systems, bank exports, and APIs.

## Notifications

Notifications should reduce stress. They should help with reminders, workflow
status, approvals, and owner visibility without creating noise.

## AI

AI should explain, summarize, warn, recommend, and guide.

AI should not hide uncertainty or replace human responsibility.

## Payroll Engine

Payroll-related logic should remain consistent and reusable across Employee
Assistant workflows.

Future assistants may consume payroll summaries, but they should not duplicate
payroll rules.

## TimeTrack Pro Boundary

TimeTrack Pro is the Employee Assistant inside Business OS.

It owns employee time, work records, payroll-ready summaries, HR reports,
employee data export, and HR import foundation.

TimeTrack Pro is not an ERP.

## File Standards

Future package standards:

- TimeTrack Package (`.ttp`)
- Business OS Package (`.bos`)

These are future documentation concepts only. They are not implemented yet.

Related documents:

- [Product Strategy](PRODUCT_STRATEGY.md)
- [Open Platform](OPEN_PLATFORM.md)
- [File Standards](FILE_STANDARDS.md)
- [HR Workflow](HR_WORKFLOW.md)
- [Technology Strategy](TECHNOLOGY_STRATEGY.md)
- [AI Strategy](AI_STRATEGY.md)
