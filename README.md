# Business OS

Business OS is not an ERP.

Business OS is a platform of business assistants for Thai SMEs.

Each assistant solves one real business problem. Each assistant is designed for
people who are busy running businesses, not learning software.

## Mission

Business OS exists to help small business owners spend less time managing
software and more time growing their business.

We do not build software.

We build confidence.

We reduce stress.

We save time.

## Vision 2030

Every small business deserves enterprise-quality software that feels simple.

Business OS will become the easiest business platform for Thai SMEs.

## Who We Serve

Business OS is built for everyday Thai businesses:

- Restaurants
- Cafes
- Street food sellers
- Small factories
- Transport companies
- Shops
- Repair stores
- Family businesses
- Small offices

These customers do not need more complexity. They need tools that respect their
time, explain what is happening, and work with the systems they already use.

## Founder Philosophy

Technology exists to reduce stress, not create it.

Business OS starts from real customer problems. We do not build features
because competitors have them. We build workflows that help customers finish
real work with more confidence.

If Excel helps customers, Excel stays.

If PDF helps customers communicate, PDF stays.

If accounting software or government systems are already part of the workflow,
Business OS should cooperate with them.

## Business OS

Business OS is a platform of focused assistants:

- Employee Assistant
- Inventory Assistant
- POS Assistant
- Tax Assistant
- Finance Assistant
- CRM Assistant
- AI Business Assistant
- Founder Dashboard

Each assistant solves one problem first. Customers should be able to start with
one assistant, get value quickly, and expand only when the business is ready.

## TimeTrack Pro

TimeTrack Pro is the Employee Assistant inside Business OS.

It is the first assistant.

It is not an ERP.

It helps employees, owners, and HR teams manage:

- Clock in / clock out
- Manual work records
- Payroll-ready summaries
- OT visibility
- HR-ready PDF and Excel reports
- Structured JSON export for HR import workflows

TimeTrack Pro came first because employee time and payroll-ready records are a
daily pain point for many Thai SMEs.

## Open Platform

Business OS does not replace existing tools.

Business OS works with them.

Supported and partner formats include:

- Excel (`.xlsx`)
- CSV
- PDF
- JSON
- Email
- Accounting software
- Government systems
- Bank exports
- APIs

Excel will always remain supported.

Business OS should cooperate, not compete, with the tools customers already
trust.

Future package standards:

- TimeTrack Package (`.ttp`)
- Business OS Package (`.bos`)

These are future standards only. They are not implemented yet.

## Future HR Workflow

```text
Employee
  ↓
Export
  ↓
HR Import
  ↓
Payroll
  ↓
Accounting
  ↓
Owner Dashboard
```

Excel, CSV, PDF, and JSON remain part of the workflow. Structured packages may
make exchange easier later, but familiar formats stay.

## Company Values

- Customer First
- Simple Wins
- Trust Through Transparency
- Respect Before Replace
- Open by Default
- Small Business First
- Build for Everyday Use

See [Values](VALUES.md) for details.

## Architecture Direction

Business OS should grow through a shared platform, not duplicated logic.

Future shared platform capabilities:

- Authentication
- Database
- Reporting
- Import
- Export
- Notifications
- AI
- Payroll Engine

This is architecture direction only. Implementation follows customer evidence.

## Documentation

Company and philosophy:

- [Mission](MISSION.md)
- [Vision](VISION.md)
- [Vision 2030](docs/VISION_2030.md)
- [Values](VALUES.md)
- [Founder](FOUNDER.md)
- [Founder Principles](docs/FOUNDER_PRINCIPLES.md)
- [Company Culture](docs/COMPANY_CULTURE.md)
- [Decision Log](docs/DECISION_LOG.md)
- [Business OS Manifesto](docs/BUSINESS_OS_MANIFESTO.md)
- [Why Business OS](docs/WHY_BUSINESS_OS.md)

Product and platform:

- [Product Strategy](docs/PRODUCT_STRATEGY.md)
- [Product Principles](docs/PRODUCT_PRINCIPLES.md)
- [Open Platform](docs/OPEN_PLATFORM.md)
- [Ecosystem](docs/ECOSYSTEM.md)
- [Long-Term Roadmap](docs/LONG_TERM_ROADMAP.md)
- [File Standards](docs/FILE_STANDARDS.md)
- [HR Workflow](docs/HR_WORKFLOW.md)
- [Architecture](docs/ARCHITECTURE.md)
- [AI Strategy](docs/AI_STRATEGY.md)
- [Technology Strategy](docs/TECHNOLOGY_STRATEGY.md)

Product documentation:

- [Founder Feedback Workflow](docs/FOUNDER_FEEDBACK_WORKFLOW.md)
- [Payroll Engine](docs/PAYROLL_ENGINE.md)
- [Demo Mode](docs/DEMO_MODE.md)
- [FAQ](docs/FAQ.md)
- [Release Notes](RELEASE_NOTES.md)
- [Changelog](CHANGELOG.md)

Governance:

- [Project Constitution](.github/PROJECT_CONSTITUTION.md)
- [Founder Letter](.github/FOUNDER_LETTER.md)
- [Customer Promise](.github/CUSTOMER_PROMISE.md)
- [AI Rules](.github/AI_RULES.md)
- [North Star](.github/NORTH_STAR.md)
- [Engineering Principles](.github/ENGINEERING_PRINCIPLES.md)
- [Product Philosophy](.github/PRODUCT_PHILOSOPHY.md)
- [Decision Framework](.github/DECISION_FRAMEWORK.md)
- [Quality Standard](.github/QUALITY_STANDARD.md)
- [Architecture Principles](.github/ARCHITECTURE_PRINCIPLES.md)

## Repository Structure

- `.github/` - governance, AI rules, architecture principles, and quality
  standards.
- `docs/` - company, investor, product, and technical strategy documents.
- `lib/` - Flutter application source.
- `test/` - automated tests.
- `android/`, `ios/`, `web/`, `windows/` - platform targets.
- `assets/` - application assets.

## Documentation-Only Sprint Rule

Constitution sprints must not change runtime behavior.

No Flutter, Dart, payroll, database, API, test, or business logic files should
change during documentation-only company updates.
