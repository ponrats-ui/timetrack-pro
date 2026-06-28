# Architecture Principles

Business OS is a modular platform of Business Assistants.

It must not become a monolith.

## Platform Principles

- Every Assistant must be independently valuable.
- Every Assistant must be installable independently.
- Every Assistant must be removable independently.
- Shared Core should reduce duplication without forcing unnecessary coupling.
- Business rules must be configurable.
- Company-specific rules must not be hardcoded.
- Shared services should be reusable across Assistants.

## Shared Capabilities

Business OS should share:

- Core
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

## Current Product Boundary

TimeTrack Pro is the Employee Assistant. Its responsibility is attendance,
payroll-ready calculations, reports, calendar visibility, analytics, and
exports.

Related documents:

- [Architecture](ARCHITECTURE.md)
- [Engineering Principles](ENGINEERING_PRINCIPLES.md)
- [Product Philosophy](PRODUCT_PHILOSOPHY.md)
- [Technology Strategy](../docs/TECHNOLOGY_STRATEGY.md)
