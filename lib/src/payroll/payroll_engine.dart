import '../features/settings/domain/work_settings.dart';
import '../features/time_records/domain/work_record.dart';
import 'holiday_calculator.dart';
import 'overtime_calculator.dart';
import 'payroll_policy.dart';

class PayrollEngineResult {
  const PayrollEngineResult({
    required this.totalWorkHours,
    required this.normalHours,
    required this.rawOtHours,
    required this.adjustedOtHours,
    required this.roundedOtHours,
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
  final double rawOtHours;
  final double adjustedOtHours;
  final double roundedOtHours;
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
    final rawOtHours = overtimeCalculator.overtimeHours(
      totalWorkHours: totalWorkHours,
      normalHours: normalHours,
      extraOtHours: record.extraOtHours,
    );
    final adjustedOtHours = _policyEligibleOtHours(
      record,
      rules,
      totalWorkHours,
      normalHours,
      rawOtHours,
    );
    final roundedOtHours = _roundedOtHours(adjustedOtHours, rules);
    final otHours = roundedOtHours;
    final nightShiftHours = _nightShiftHours(record, rules, totalWorkHours);
    final nightBaseHours = _scheduledNightNormalHours(
      record,
      rules,
      totalWorkHours,
    ).clamp(0, normalHours).toDouble();
    final dayBaseHours = normalHours - nightBaseHours;
    final nightOtHours = (nightShiftHours - nightBaseHours)
        .clamp(0, otHours)
        .toDouble();
    final dayOtHours = otHours - nightOtHours;
    final normalMultiplier = _payMultiplier(
      policy.normalMultiplier(rules, record.dayType),
    );
    final overtimeMultiplier = _payMultiplier(
      policy.overtimeMultiplier(rules, record.dayType),
    );
    final nightBaseMultiplier = rules.nightOtMultiplier > 0
        ? rules.nightOtMultiplier
        : normalMultiplier;
    final nightOvertimeMultiplier = rules.nightOtMultiplier > 0
        ? rules.nightOtMultiplier
        : overtimeMultiplier;
    final baseIncome =
        (dayBaseHours * rules.hourlyWage * normalMultiplier) +
        (nightBaseHours * rules.hourlyWage * nightBaseMultiplier);
    final otIncome =
        (dayOtHours * rules.hourlyWage * overtimeMultiplier) +
        (nightOtHours * rules.hourlyWage * nightOvertimeMultiplier);
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
      rawOtHours: rawOtHours,
      adjustedOtHours: adjustedOtHours,
      roundedOtHours: roundedOtHours,
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

  double _payMultiplier(double multiplier) {
    if (multiplier > 0) {
      return multiplier;
    }

    return 1;
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

  double _policyEligibleOtHours(
    WorkRecordEntity record,
    PayrollRules rules,
    double totalWorkHours,
    double normalHours,
    double rawOtHours,
  ) {
    if (rawOtHours <= 0 || totalWorkHours <= 0) {
      return 0;
    }

    final extraOtHours = record.extraOtHours
        .clamp(0, double.infinity)
        .toDouble();
    final scheduledOtHours = (rawOtHours - extraOtHours)
        .clamp(0, double.infinity)
        .toDouble();
    if (scheduledOtHours <= 0) {
      return _minimumEligibleHours(extraOtHours, rules);
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
    final otStart = _effectiveOtStart(scheduleStart, scheduleEnd, rules);
    final beforeSchedule = _overlapMinutes(
      shiftStart,
      shiftEnd,
      shiftStart,
      scheduleStart,
    );
    final afterOtStart = _overlapMinutes(
      shiftStart,
      shiftEnd,
      otStart,
      shiftEnd,
    );
    final eligibleScheduledHours = (beforeSchedule + afterOtStart) / 60;
    final cappedScheduledHours = eligibleScheduledHours
        .clamp(0, scheduledOtHours)
        .toDouble();

    return _minimumEligibleHours(cappedScheduledHours + extraOtHours, rules);
  }

  int _effectiveOtStart(
    int scheduleStart,
    int scheduleEnd,
    PayrollRules rules,
  ) {
    final configured = rules.otStartMinutes;
    if (configured == null) {
      return scheduleEnd;
    }

    var otStart = configured;
    while (otStart < scheduleStart) {
      otStart += _minutesPerDay;
    }
    while (otStart - scheduleStart >= _minutesPerDay) {
      otStart -= _minutesPerDay;
    }
    if (otStart < scheduleEnd) {
      return scheduleEnd;
    }
    return otStart;
  }

  double _minimumEligibleHours(double hours, PayrollRules rules) {
    if (hours <= 0) {
      return 0;
    }

    final minimumHours = rules.minimumOtMinutes / 60;
    if (minimumHours > 0 && hours < minimumHours) {
      return 0;
    }
    return hours;
  }

  double _roundedOtHours(double hours, PayrollRules rules) {
    if (hours <= 0 || rules.otRoundingPolicy == OtRoundingPolicy.none) {
      return hours;
    }

    final totalMinutes = (hours * 60).round();
    final fullHours = totalMinutes ~/ 60;
    final remainder = totalMinutes % 60;
    final roundedRemainder = switch (remainder) {
      <= 15 => 0,
      <= 45 => 30,
      _ => 60,
    };
    return ((fullHours * 60) + roundedRemainder) / 60;
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

  double _scheduledNightNormalHours(
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
    final scheduleDuration = _scheduleDurationMinutes(
      rules.normalScheduleStartMinutes,
      rules.normalScheduleEndMinutes,
    );
    final nightStart = rules.nightShiftStartMinutes;
    final nightEnd = _normalizeEnd(
      rules.nightShiftStartMinutes,
      rules.nightShiftEndMinutes,
    );
    var overlap = 0;

    for (final scheduleOffset in const [-_minutesPerDay, 0, _minutesPerDay]) {
      final scheduledStart = scheduleStart + scheduleOffset;
      final scheduledEnd = scheduledStart + scheduleDuration;
      for (final nightOffset in const [-_minutesPerDay, 0, _minutesPerDay]) {
        overlap += _threeWayOverlapMinutes(
          shiftStart,
          shiftEnd,
          scheduledStart,
          scheduledEnd,
          nightStart + nightOffset,
          nightEnd + nightOffset,
        );
      }
    }

    return (overlap / 60).clamp(0, totalWorkHours).toDouble();
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

  int _threeWayOverlapMinutes(
    int firstStart,
    int firstEnd,
    int secondStart,
    int secondEnd,
    int thirdStart,
    int thirdEnd,
  ) {
    var overlapStart = firstStart;
    if (secondStart > overlapStart) {
      overlapStart = secondStart;
    }
    if (thirdStart > overlapStart) {
      overlapStart = thirdStart;
    }

    var overlapEnd = firstEnd;
    if (secondEnd < overlapEnd) {
      overlapEnd = secondEnd;
    }
    if (thirdEnd < overlapEnd) {
      overlapEnd = thirdEnd;
    }

    final overlap = overlapEnd - overlapStart;
    return overlap > 0 ? overlap : 0;
  }
}

const _minutesPerDay = 24 * 60;
