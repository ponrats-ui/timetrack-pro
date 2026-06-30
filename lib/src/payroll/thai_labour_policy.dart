import '../features/settings/domain/work_settings.dart';
import '../features/time_records/domain/work_record.dart';
import 'payroll_policy.dart';

class ThaiLabourPolicy extends PayrollPolicy {
  const ThaiLabourPolicy();

  @override
  double normalMultiplier(PayrollRules rules, DayType dayType) {
    return switch (dayType) {
      DayType.normal => rules.normalDayMultiplier,
      DayType.weekend => rules.weekendDayMultiplier,
      DayType.holiday => rules.holidayDayMultiplier,
    };
  }

  @override
  double overtimeMultiplier(PayrollRules rules, DayType dayType) {
    return switch (dayType) {
      DayType.normal => rules.normalOtMultiplier,
      DayType.weekend => rules.weekendOtMultiplier,
      DayType.holiday => rules.holidayOtMultiplier,
    };
  }
}
