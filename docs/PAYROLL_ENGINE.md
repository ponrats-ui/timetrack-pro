# Payroll Engine

TimeTrack Pro uses one payroll calculation engine for records, calendar,
dashboard, HR reports, PDF export, and Excel export.

## Source of Truth

- Settings are persisted in Drift `app_settings`.
- `WorkSettings.payrollRules` builds the immutable `PayrollRules` object.
- `WorkCalculator` reads only `PayrollRules` for payroll values.
- UI, reports, and exports consume `WorkCalculator` results instead of
  recalculating income independently.

## Configurable Rules

The Payroll Settings screen stores these values:

- Salary: monthly salary, daily wage, normal working hours, default break.
- Day multipliers: normal working day, weekend, public holiday.
- Overtime multipliers: normal OT, weekend OT, holiday OT.
- Night shift: night multiplier, night start time, night end time.
- Allowances: meal allowance, travel allowance, other allowance.
- Deductions: social security, tax.
- Company: company name, employee name, employee ID.

Defaults are starter values only. Users can change them at any time.

## Daily Calculation

For each work record:

- Total work hours handle overnight shifts and subtract break minutes.
- Normal work days cap normal hours by the configured normal working hours.
- Weekend and public-holiday work is classified as OT hours.
- Extra hours become OT hours.
- Normal-day base income uses the configured normal-day multiplier.
- OT income uses the configured OT multiplier for the record day type.
- Night shift hours use the configured night multiplier.
- Meal, travel, and other allowance defaults are added to record allowances.
- Daily net income subtracts the record expense.

## Monthly Calculation

Monthly summaries aggregate daily calculations from the same engine:

- Working days.
- Total work hours.
- Normal hours.
- OT hours.
- Gross income.
- Expense total.
- Social security deduction.
- Tax deduction.
- Final net income.

## Migration

Schema version 6 adds named payroll rule columns without removing legacy OT
columns. Existing values are copied into the new rule columns where possible:

- `ot_rate1` -> `normal_day_multiplier`
- `ot_rate15` -> `normal_ot_multiplier`
- `ot_rate2` -> `weekend_ot_multiplier`
- `ot_rate3` -> `holiday_ot_multiplier`

No work records or export history rows are deleted.

## Subscription Boundary

Subscriptions are not implemented. Future entitlement checks should wrap access
to premium workflows, not the payroll calculation engine itself.
