import '../features/settings/domain/work_settings.dart';
import '../features/time_records/domain/work_record.dart';
import 'holiday_calculator.dart';
import 'overtime_calculator.dart';
import 'payroll_policy.dart';

class PayrollEngineResult {
  const PayrollEngineResult({
    required this.totalWorkHours,
    required this.earlyWorkHours,
    required this.normalHours,
    required this.graceHours,
    required this.nonOtHours,
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
  final double earlyWorkHours;
  final double normalHours;
  final double graceHours;
  final double nonOtHours;
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
    final segments = _workSegments(record, rules, totalWorkHours);
    final normalHours = segments.normalWorkHours;
    final rawOtHours =
        segments.rawOtHours +
        record.extraOtHours.clamp(0, double.infinity).toDouble();
    final adjustedOtHours = _minimumEligibleHours(rawOtHours, rules);
    final roundedOtHours = _roundedOtHours(adjustedOtHours, rules);
    final otHours = roundedOtHours;
    final nonOtHours =
        (segments.earlyWorkHours +
                segments.normalWorkHours +
                segments.graceHours)
            .clamp(0, totalWorkHours)
            .toDouble();
    final nightShiftHours = _nightShiftHours(record, rules, totalWorkHours);
    final nightBaseHours = _nightNonOtHours(
      record,
      rules,
      segments,
    ).clamp(0, nonOtHours).toDouble();
    final dayBaseHours = nonOtHours - nightBaseHours;
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
      earlyWorkHours: segments.earlyWorkHours,
      normalHours: normalHours,
      graceHours: segments.graceHours,
      nonOtHours: nonOtHours,
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

  _WorkSegments _workSegments(
    WorkRecordEntity record,
    PayrollRules rules,
    double totalWorkHours,
  ) {
    if (totalWorkHours <= 0) {
      return const _WorkSegments(
        earlyWorkHours: 0,
        normalWorkHours: 0,
        graceHours: 0,
        rawOtHours: 0,
        scheduleStart: 0,
        scheduleEnd: 0,
        otStart: 0,
      );
    }

    final shiftStart = record.checkInMinutes;
    final shiftEnd = _normalizeEnd(shiftStart, record.checkOutMinutes);
    final scheduleStart = _scheduleStartForShift(
      shiftStart,
      rules.normalScheduleStartMinutes,
      rules.normalScheduleEndMinutes,
    );
    final scheduleEnd =
        scheduleStart +
        _scheduleDurationMinutes(
          rules.normalScheduleStartMinutes,
          rules.normalScheduleEndMinutes,
        );
    final otStart = _effectiveOtStart(scheduleStart, scheduleEnd, rules);
    final earlyMinutes = _overlapMinutes(
      shiftStart,
      shiftEnd,
      shiftStart,
      scheduleStart,
    );
    final normalMinutes = _overlapMinutes(
      shiftStart,
      shiftEnd,
      scheduleStart,
      scheduleEnd,
    );
    final graceMinutes = _overlapMinutes(
      shiftStart,
      shiftEnd,
      scheduleEnd,
      otStart,
    );
    final rawOtMinutes = _overlapMinutes(
      shiftStart,
      shiftEnd,
      otStart,
      shiftEnd,
    );

    return _WorkSegments(
      earlyWorkHours: earlyMinutes / 60,
      normalWorkHours: normalMinutes / 60,
      graceHours: graceMinutes / 60,
      rawOtHours: rawOtMinutes / 60,
      scheduleStart: scheduleStart,
      scheduleEnd: scheduleEnd,
      otStart: otStart,
    );
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

  int _scheduleStartForShift(
    int shiftStart,
    int scheduleStartMinutes,
    int scheduleEndMinutes,
  ) {
    if (scheduleEndMinutes >= scheduleStartMinutes) {
      return scheduleStartMinutes;
    }

    return _scheduleStartNearShift(shiftStart, scheduleStartMinutes);
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

  double _nightNonOtHours(
    WorkRecordEntity record,
    PayrollRules rules,
    _WorkSegments segments,
  ) {
    if (segments.earlyWorkHours +
            segments.normalWorkHours +
            segments.graceHours <=
        0) {
      return 0;
    }

    final shiftStart = record.checkInMinutes;
    final shiftEnd = _normalizeEnd(shiftStart, record.checkOutMinutes);
    final nightStart = rules.nightShiftStartMinutes;
    final nightEnd = _normalizeEnd(
      rules.nightShiftStartMinutes,
      rules.nightShiftEndMinutes,
    );
    var overlap = 0;

    final nonOtRanges = [
      (shiftStart, segments.scheduleStart),
      (segments.scheduleStart, segments.scheduleEnd),
      (segments.scheduleEnd, segments.otStart),
    ];
    for (final range in nonOtRanges) {
      for (final nightOffset in const [-_minutesPerDay, 0, _minutesPerDay]) {
        overlap += _threeWayOverlapMinutes(
          shiftStart,
          shiftEnd,
          range.$1,
          range.$2,
          nightStart + nightOffset,
          nightEnd + nightOffset,
        );
      }
    }

    return overlap / 60;
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

class _WorkSegments {
  const _WorkSegments({
    required this.earlyWorkHours,
    required this.normalWorkHours,
    required this.graceHours,
    required this.rawOtHours,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.otStart,
  });

  final double earlyWorkHours;
  final double normalWorkHours;
  final double graceHours;
  final double rawOtHours;
  final int scheduleStart;
  final int scheduleEnd;
  final int otStart;
}
