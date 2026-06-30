import '../features/settings/domain/work_settings.dart';
import '../features/time_records/domain/work_record.dart';
import 'holiday_calculator.dart';
import 'overtime_calculator.dart';
import 'payroll_policy.dart';

class PayrollEngineResult {
  const PayrollEngineResult({
    required this.totalWorkHours,
    required this.normalHours,
    required this.otHours,
    required this.nightShiftHours,
    required this.baseIncome,
    required this.otIncome,
    required this.allowanceIncome,
    required this.dailyIncome,
    required this.netIncome,
  });

  final double totalWorkHours;
  final double normalHours;
  final double otHours;
  final double nightShiftHours;
  final double baseIncome;
  final double otIncome;
  final double allowanceIncome;
  final double dailyIncome;
  final double netIncome;
}

class PayrollEngine {
  const PayrollEngine({
    this.policyFactory = const PayrollPolicyFactory(),
    this.overtimeCalculator = const OvertimeCalculator(),
    this.holidayCalculator = const HolidayCalculator(),
  });

  final PayrollPolicyFactory policyFactory;
  final OvertimeCalculator overtimeCalculator;
  final HolidayCalculator holidayCalculator;

  PayrollEngineResult calculateDaily(
    WorkRecordEntity record,
    WorkSettings settings,
  ) {
    final rules = settings.payrollRules;
    final policy = policyFactory.create(rules.payrollPolicyType);
    final totalWorkHours = _shiftHours(
      record.checkInMinutes,
      record.checkOutMinutes,
    );
    final normalHours = _scheduledNormalHours(record, rules, totalWorkHours);
    final otHours = overtimeCalculator.overtimeHours(
      totalWorkHours: totalWorkHours,
      normalHours: normalHours,
      extraOtHours: record.extraOtHours,
    );
    final nightShiftHours = _nightShiftHours(record, rules, totalWorkHours);
    final nightBaseHours = normalHours.clamp(0, nightShiftHours).toDouble();
    final dayBaseHours = normalHours - nightBaseHours;
    final nightOtHours = (nightShiftHours - nightBaseHours)
        .clamp(0, otHours)
        .toDouble();
    final dayOtHours = otHours - nightOtHours;
    final baseIncome =
        (dayBaseHours *
            rules.hourlyWage *
            policy.normalMultiplier(rules, record.dayType)) +
        (nightBaseHours * rules.hourlyWage * rules.nightOtMultiplier);
    final otIncome =
        (dayOtHours *
            rules.hourlyWage *
            policy.overtimeMultiplier(rules, record.dayType)) +
        (nightOtHours * rules.hourlyWage * rules.nightOtMultiplier);
    final allowanceIncome = record.travelAllowance + record.specialAllowance;
    final configuredAllowanceIncome =
        rules.mealAllowanceDefault +
        rules.travelAllowanceDefault +
        rules.otherAllowanceDefault;
    final totalAllowanceIncome = allowanceIncome + configuredAllowanceIncome;
    final dailyIncome = baseIncome + otIncome + totalAllowanceIncome;

    return PayrollEngineResult(
      totalWorkHours: totalWorkHours,
      normalHours: normalHours,
      otHours: otHours,
      nightShiftHours: nightShiftHours,
      baseIncome: baseIncome,
      otIncome: otIncome,
      allowanceIncome: totalAllowanceIncome,
      dailyIncome: dailyIncome,
      netIncome: dailyIncome - record.expense,
    );
  }

  double _shiftHours(int checkInMinutes, int checkOutMinutes) {
    var workedMinutes = checkOutMinutes - checkInMinutes;
    if (workedMinutes < 0) {
      workedMinutes += _minutesPerDay;
    }

    if (workedMinutes <= 0) {
      return 0;
    }

    return workedMinutes / 60;
  }

  double _scheduledNormalHours(
    WorkRecordEntity record,
    PayrollRules rules,
    double totalWorkHours,
  ) {
    if (totalWorkHours <= 0) {
      return 0;
    }

    final shiftStart = record.checkInMinutes;
    final shiftEnd = _normalizeEnd(shiftStart, record.checkOutMinutes);
    final scheduleStart = _scheduleStartNearShift(
      shiftStart,
      rules.normalScheduleStartMinutes,
    );
    final scheduleEnd =
        scheduleStart +
        _scheduleDurationMinutes(
          rules.normalScheduleStartMinutes,
          rules.normalScheduleEndMinutes,
        );
    final previousOverlap = _overlapMinutes(
      shiftStart,
      shiftEnd,
      scheduleStart - _minutesPerDay,
      scheduleEnd - _minutesPerDay,
    );
    final currentOverlap = _overlapMinutes(
      shiftStart,
      shiftEnd,
      scheduleStart,
      scheduleEnd,
    );
    final nextOverlap = _overlapMinutes(
      shiftStart,
      shiftEnd,
      scheduleStart + _minutesPerDay,
      scheduleEnd + _minutesPerDay,
    );

    return ((previousOverlap + currentOverlap + nextOverlap) / 60)
        .clamp(0, totalWorkHours)
        .toDouble();
  }

  int _scheduleStartNearShift(int shiftStart, int scheduleStartMinutes) {
    var start = scheduleStartMinutes;
    while (start - shiftStart > 12 * 60) {
      start -= _minutesPerDay;
    }
    while (shiftStart - start > 12 * 60) {
      start += _minutesPerDay;
    }
    return start;
  }

  int _scheduleDurationMinutes(int startMinutes, int endMinutes) {
    var duration = endMinutes - startMinutes;
    if (duration < 0) {
      duration += _minutesPerDay;
    }
    return duration;
  }

  double _nightShiftHours(
    WorkRecordEntity record,
    PayrollRules rules,
    double totalWorkHours,
  ) {
    if (totalWorkHours <= 0) {
      return 0;
    }

    final shiftEnd = _normalizeEnd(
      record.checkInMinutes,
      record.checkOutMinutes,
    );
    final nightStart = rules.nightShiftStartMinutes;
    final nightEnd = _normalizeEnd(
      rules.nightShiftStartMinutes,
      rules.nightShiftEndMinutes,
    );
    final previousNightOverlap = _overlapMinutes(
      record.checkInMinutes,
      shiftEnd,
      nightStart - _minutesPerDay,
      nightEnd - _minutesPerDay,
    );
    final firstNightOverlap = _overlapMinutes(
      record.checkInMinutes,
      shiftEnd,
      nightStart,
      nightEnd,
    );
    final secondNightOverlap = _overlapMinutes(
      record.checkInMinutes,
      shiftEnd,
      nightStart + _minutesPerDay,
      nightEnd + _minutesPerDay,
    );
    final grossNightHours =
        (previousNightOverlap + firstNightOverlap + secondNightOverlap) / 60;

    return grossNightHours.clamp(0, totalWorkHours).toDouble();
  }

  int _normalizeEnd(int startMinutes, int endMinutes) {
    if (endMinutes < startMinutes) {
      return endMinutes + _minutesPerDay;
    }

    return endMinutes;
  }

  int _overlapMinutes(int start, int end, int rangeStart, int rangeEnd) {
    final overlapStart = start > rangeStart ? start : rangeStart;
    final overlapEnd = end < rangeEnd ? end : rangeEnd;
    final overlap = overlapEnd - overlapStart;
    return overlap > 0 ? overlap : 0;
  }
}

const _minutesPerDay = 24 * 60;
