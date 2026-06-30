# Business OS

Business OS is a Small Business First platform of trusted Business Assistants.

Business OS exists to help small business owners spend less time managing
software and more time growing their business.

It is not a standalone ERP. It is not a system that forces customers to abandon
their existing workflow. Business OS works with the tools small businesses
already use and adds focused Assistants where the work is painful.

## Vision

Every small business deserves enterprise-quality software that feels simple.

## Mission

Help Thai employees and small business owners manage work, people, and business
with confidence.

We are not building software.

We are building trust.

## Why Business OS Exists

Small business owners manage people, sales, inventory, payroll, tax, finance,
customers, documents, and decisions with limited time.

Many businesses already use Excel, PDF, email, accounting software, government
systems, chat messages, and manual workflows. Those workflows are not failures.
They are how the business survives.

Business OS should respect those workflows, reduce stress, and make daily work
easier.

## Why TimeTrack Pro Came First

TimeTrack Pro is the Employee Assistant inside Business OS.

Employee time is a daily operational problem. Workers need clear records.
Owners need trustworthy summaries. HR needs exportable data. Accounting needs
clean handoff.

TimeTrack Pro helps with:

- Clock in / clock out
- Manual work records
- Payroll-ready summaries
- OT visibility
- HR-ready PDF and Excel reports
- Structured JSON export for HR import workflows

TimeTrack Pro is not a standalone ERP.

It solves one job: employee time and payroll-ready work records.

## Open Platform Philosophy

Business OS does not replace existing tools.

Business OS works with existing tools:

- Excel
- CSV
- PDF
- Email
- Accounting software
- Government systems
- APIs

These are partners, not competitors.

Supported exchange formats:

- Excel (`.xlsx`)
- CSV
- PDF
- JSON

Future exchange format:

- Business OS Package (`.bos`)

Customers should never be forced to abandon the workflow that already helps
them run their business.

## Company Values

Business OS is built around these values:

- Customer First
- Simple Wins
- Trust Through Transparency
- Open by Default
- Respect Before Replace
- Small Business First
- Build for Everyday Use

See [Values](VALUES.md) for details.

## Future Roadmap

Business OS will grow through focused Assistants.

Each Assistant solves one job:

- Employee Assistant
- Inventory Assistant
- POS Assistant
- Tax Assistant
- Finance Assistant
- CRM Assistant
- AI Business Assistant
- Founder Dashboard

Customers should start with the Assistant they need and expand only when the
business is ready.

## Future HR Workflow

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

Excel remains supported forever. PDF remains supported for human-readable
reports. JSON and future package formats support structured workflows.

## Architecture Direction

Business OS is modular and shared-core oriented.

Future shared capabilities include:

- Shared Core
- Shared Authentication
- Shared Notifications
- Shared Reporting
- Shared Payroll Engine
- Shared Import/Export
- Future AI Layer

This repository currently contains TimeTrack Pro, the Employee Assistant.

## Founder

Founder: Ponrat Saripan.

The founder owns product vision, architecture direction, customer philosophy,
AI governance, and long-term strategy.

## Documentation

Company documents:

- [Mission](MISSION.md)
- [Values](VALUES.md)
- [Founder](FOUNDER.md)
- [Vision](VISION.md)
- [Vision 2030](docs/VISION_2030.md)
- [Founder Principles](docs/FOUNDER_PRINCIPLES.md)
- [Principles](PRINCIPLES.md)
- [Long-Term Roadmap](docs/LONG_TERM_ROADMAP.md)
- [Open Platform](docs/OPEN_PLATFORM.md)
- [File Standards](docs/FILE_STANDARDS.md)
- [HR Workflow](docs/HR_WORKFLOW.md)
- [Business Model](BUSINESS_MODEL.md)
- [Authors](AUTHORS)
- [License](LICENSE)

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
- [Security](SECURITY.md)
- [Change Policy](CHANGE_POLICY.md)
- [Contributing](CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

Investor and strategy documents:

- [Day One](docs/DAY_ONE.md)
- [Business OS Manifesto](docs/BUSINESS_OS_MANIFESTO.md)
- [Investor Overview](docs/INVESTOR_OVERVIEW.md)
- [Why Business OS](docs/WHY_BUSINESS_OS.md)
- [Founder Story](docs/FOUNDER_STORY.md)
- [Product Strategy](docs/PRODUCT_STRATEGY.md)
- [Market Opportunity](docs/MARKET_OPPORTUNITY.md)
- [Competitive Philosophy](docs/COMPETITIVE_PHILOSOPHY.md)
- [Technology Strategy](docs/TECHNOLOGY_STRATEGY.md)
- [AI Strategy](docs/AI_STRATEGY.md)
- [Customer Journey](docs/CUSTOMER_JOURNEY.md)
- [Product Principles](docs/PRODUCT_PRINCIPLES.md)
- [Architecture](docs/ARCHITECTURE.md)
- [FAQ](docs/FAQ.md)

Product documentation:

- [Founder Feedback Workflow](docs/FOUNDER_FEEDBACK_WORKFLOW.md)
- [Payroll Engine](docs/PAYROLL_ENGINE.md)
- [Demo Mode](docs/DEMO_MODE.md)
- [Release Notes](RELEASE_NOTES.md)
- [Changelog](CHANGELOG.md)

## Repository Structure

- `.github/` - governance, AI rules, architecture principles, and quality
  standards.
- `docs/` - company, investor, product, and technical strategy documents.
- `lib/` - Flutter application source.
- `test/` - automated tests.
- `android/`, `ios/`, `web/`, `windows/` - platform targets.
- `assets/` - application assets.

## Development Standards

This repository is documentation-first and production-quality oriented.

No runtime behavior should change during documentation-only sprints.

Founder Feedback Sprints use the documented feedback workflow: reproduce user
issues, classify the root cause, propose the smallest useful solution, and only
implement product changes after confirmation.

Before product releases, run the requested verification. Typical checks:

```powershell
dart format lib test
flutter analyze
flutter test
flutter build web
```

## Technology

TimeTrack Pro uses Flutter, Riverpod, and Drift.

The current application supports Android, iOS, Windows, and Web targets.

Offline persistence uses Drift with SQLite-compatible storage. Web support uses
Drift web runtime assets.

## Subscription Status

Subscriptions are intentionally not implemented yet. Business OS is designed as
modular SaaS, but monetization should follow validated customer value.
