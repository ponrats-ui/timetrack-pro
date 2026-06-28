# Business OS Architecture

Business OS is a modular platform of Business Assistants.

The architecture should support long-term scalability without creating an
ERP-style monolith.

## Shared Core

Shared Core is the platform foundation. It should provide reusable capabilities
that Assistants can adopt without duplicating business logic.

Shared capabilities include:

- Authentication
- Authorization
- Reporting
- Database
- Notifications
- Configuration
- AI
- Analytics
- Localization
- Theme
- Audit
- Security

## Assistant Boundaries

Every Assistant should own a clear business problem.

TimeTrack Pro owns the Employee Assistant boundary:

- Attendance
- Payroll-ready calculations
- Work records
- Reports
- Calendar
- Analytics
- Exports

## Engineering Direction

- Everything configurable.
- Everything modular.
- Everything reusable.
- Everything documented.
- Everything tested.
- Everything versioned.
- Everything production-ready.
- No duplicated business logic.
- No company-specific hardcoded rules.

Related documents:

- [Technology Strategy](TECHNOLOGY_STRATEGY.md)
- [AI Strategy](AI_STRATEGY.md)
- [Product Strategy](PRODUCT_STRATEGY.md)
- [Architecture Principles](../.github/ARCHITECTURE_PRINCIPLES.md)
