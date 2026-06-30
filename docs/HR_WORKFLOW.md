# HR Workflow Direction

Business OS should support simple employee-to-HR data handoff without forcing
customers into a closed system.

## Future Workflow

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

## Open Format Principle

Open formats remain part of the workflow:

- Excel remains supported forever.
- CSV remains supported forever for lightweight exchange.
- PDF remains supported forever for human-readable reports.
- JSON supports structured import/export.
- Future TimeTrack Package (`.ttp`) and Business OS Package (`.bos`) may add
  richer structured handoff later.

## Product Rule

HR workflows should reduce manual work and mistakes without forcing companies
to replace their existing payroll, accounting, or spreadsheet process.
