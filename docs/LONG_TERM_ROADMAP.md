# Long-Term Roadmap

This roadmap describes the intended direction of Business OS. It may change as
customer feedback reveals better sequencing.

Business OS is not an ERP.

Business OS is a platform of business assistants for Thai SMEs.

Each assistant solves one real business problem.

## Today

Employee Assistant: TimeTrack Pro

Focus: employee time, work records, payroll-ready summaries, HR exports, HR
import foundation, open data handoff, and production quality.

TimeTrack Pro is the first assistant inside Business OS.

It is not an ERP.

## Future Assistants

Employee Assistant

Solves employee time, work records, payroll-ready reports, HR import/export,
and employee visibility.

Inventory Assistant

Solves stock visibility, receiving, usage, reorder awareness, and inventory
handoff.

POS Assistant

Solves sales capture, receipts, shift summaries, and connection to finance and
inventory workflows.

Tax Assistant

Solves tax preparation, reminders, summaries, and clearer conversations with
accountants.

Finance Assistant

Solves cash visibility, expenses, income summaries, and owner-ready financial
views.

CRM Assistant

Solves customer follow-up, customer history, and simple relationship tracking.

AI Business Assistant

Solves explanation, summarization, warnings, recommendations, and workflow
guidance across assistants.

Founder Dashboard

Solves owner visibility across the whole business without forcing owners to
open every assistant.

## HR Workflow Direction

Future employee and HR workflow:

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

This workflow must remain open.

Excel, CSV, and PDF remain supported forever. JSON and future package formats
support structured import/export.

## File Standards

Future standards:

- TimeTrack Package (`.ttp`) for TimeTrack Pro employee data exchange.
- Business OS Package (`.bos`) for cross-assistant business data exchange.

These are documentation-only future concepts. They are not implemented yet.

## Roadmap Principle

Business OS should grow from real operational pain. Each assistant must solve
one clear customer problem and remain independently valuable.

Related documents:

- [Product Strategy](PRODUCT_STRATEGY.md)
- [Open Platform](OPEN_PLATFORM.md)
- [Ecosystem](ECOSYSTEM.md)
- [File Standards](FILE_STANDARDS.md)
- [HR Workflow](HR_WORKFLOW.md)
- [Vision 2030](VISION_2030.md)
- [Technology Strategy](TECHNOLOGY_STRATEGY.md)
- [Monetization](MONETIZATION.md)
