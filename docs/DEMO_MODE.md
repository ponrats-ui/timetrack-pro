# Demo Mode

Demo mode helps first-time users understand TimeTrack Pro within a few minutes
without entering real work records.

## Entry Points

- First-run welcome screen: `ทดลองด้วยข้อมูลตัวอย่าง`.
- Empty record list: `ทดลองด้วยข้อมูลตัวอย่าง`.

Users can also choose `เริ่มใช้งานจริง` and enter their own records.

## Sample Data

The app generates 30 work records marked with `isDemo = true`.

The sample set includes:

- Normal work days.
- Weekends.
- Public holidays.
- Overtime.
- Night shifts.
- Travel and special allowances.
- Expenses.

The demo data does not store final income values. Dashboard, calendar, reports,
PDF, and Excel all calculate totals through the payroll rule engine.

## Reset Safety

Settings includes `ลบข้อมูลตัวอย่าง`.

The reset action deletes only records marked as demo data. Real user records are
not deleted.

## Migration

Schema version 7 adds:

- `work_records.is_demo`
- `app_settings.onboarding_completed`

Existing users are marked as onboarded during migration so they are not forced
through the first-run welcome screen after updating.
