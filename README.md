# Business OS

Business OS is a platform of trusted Business Assistants for small businesses.

It is not ERP. It is not accounting software. It is not payroll software.
Business OS exists to reduce operational stress, increase confidence, and make
business management easier to understand.

Current product: TimeTrack Pro, the Employee Assistant.

## Vision

Every small business deserves a great assistant.

## Mission

Build trusted Business Assistants that help small businesses operate with
confidence.

Business OS helps owners:

- Save time.
- Improve accuracy.
- Increase confidence.
- Improve business visibility.
- Reduce stress.

## Current Product

TimeTrack Pro is the Employee Assistant inside Business OS.

It focuses on:

- Attendance
- Payroll-ready calculations
- Reports
- Calendar
- Analytics
- Exports

TimeTrack Pro is an offline-first Flutter app for drivers, workers, and small
businesses that need clear work records and HR-ready monthly reports.

## Future Platform

Business OS is intended to become a modular platform of Assistants:

- Employee Assistant
- Payroll Assistant
- POS Assistant
- Inventory Assistant
- Finance Assistant
- Tax Assistant
- CRM Assistant
- Business Assistant
- Analytics Assistant
- Document Assistant
- AI Assistant
- Automation Assistant
- Partner Assistant

Customers should subscribe only to the Assistants they need.

## Founder

Founder: Ponrat Saripan.

The founder is the Repository Owner, Vision Owner, Business Architect, Product
Architect, and owner of long-term strategy. The founder defines product vision,
architecture direction, customer philosophy, AI governance, and roadmap
direction.

## Product Philosophy

- Business OS is not ERP.
- Software should explain.
- Software should reduce stress.
- Software should save time.
- Software should increase confidence.
- Business rules should be configurable.
- Trust is more important than feature count.

## Customer Promise

Every release must improve at least one of:

- Time
- Accuracy
- Confidence
- Visibility
- Stress reduction

Otherwise, it should not ship.

## Architecture

Business OS is modular and shared-core oriented.

Shared platform capabilities include:

- Shared Core
- Shared Authentication
- Shared Reporting
- Shared Database
- Shared Notifications
- Shared Configuration
- Shared AI
- Shared Analytics

Engineering standards:

- Everything configurable.
- Everything modular.
- Everything reusable.
- Everything documented.
- Everything tested.
- Everything versioned.
- Everything production-ready.
- No duplicated business logic.
- No company-specific hardcoded rules.

## Roadmap

The intended roadmap is:

1. Employee Assistant
2. POS Assistant
3. Inventory Assistant
4. Finance Assistant
5. Tax Assistant
6. CRM Assistant
7. AI and Business Intelligence
8. Platform APIs
9. Marketplace and partner ecosystem

The roadmap may change as customer feedback reveals better sequencing.

## Documentation

Company documents:

- [Mission](MISSION.md)
- [Values](VALUES.md)
- [Founder](FOUNDER.md)
- [Vision](VISION.md)
- [Principles](PRINCIPLES.md)
- [Long-Term Roadmap](ROADMAP_LONG_TERM.md)
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
- [Long-Term Roadmap](docs/LONG_TERM_ROADMAP.md)
- [Monetization](docs/MONETIZATION.md)
- [Technology Strategy](docs/TECHNOLOGY_STRATEGY.md)
- [AI Strategy](docs/AI_STRATEGY.md)
- [Customer Journey](docs/CUSTOMER_JOURNEY.md)
- [Product Principles](docs/PRODUCT_PRINCIPLES.md)
- [Architecture](docs/ARCHITECTURE.md)
- [FAQ](docs/FAQ.md)

Product documentation:

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
