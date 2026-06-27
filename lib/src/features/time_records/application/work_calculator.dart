import '../../settings/domain/work_settings.dart';
import '../domain/work_record.dart';

class DailyCalculation {
  const DailyCalculation({
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

class MonthlyCalculation {
  const MonthlyCalculation({
    required this.workingDays,
    required this.totalWorkHours,
    required this.normalHours,
    required this.otHours,
    required this.grossIncome,
    required this.expenseTotal,
    required this.socialSecurityDeduction,
    required this.taxDeduction,
    required this.totalDeductions,
    required this.netIncome,
  });

  final int workingDays;
  final double totalWorkHours;
  final double normalHours;
  final double otHours;
  final double grossIncome;
  final double expenseTotal;
  final double socialSecurityDeduction;
  final double taxDeduction;
  final double totalDeductions;
  final double netIncome;
}

class WorkCalculator {
  const WorkCalculator();

  DailyCalculation calculateDaily(
    WorkRecordEntity record,
    WorkSettings settings,
  ) {
    final rules = settings.payrollRules;
    final totalWorkHours = _shiftHours(
      record.checkInMinutes,
      record.checkOutMinutes,
      record.breakMinutes,
    );
    final normalHours = record.dayType == DayType.normal
        ? totalWorkHours.clamp(0, rules.normalWorkHours).toDouble()
        : 0.0;
    final otFromShift = record.dayType == DayType.normal
        ? (totalWorkHours - rules.normalWorkHours).clamp(0, double.infinity)
        : totalWorkHours;
    final otHours = otFromShift + record.extraOtHours;
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
            _dayMultiplier(record.dayType, rules)) +
        (nightBaseHours * rules.hourlyWage * rules.nightOtMultiplier);
    final otIncome =
        (dayOtHours * rules.hourlyWage * _otMultiplier(record.dayType, rules)) +
        (nightOtHours * rules.hourlyWage * rules.nightOtMultiplier);
    final allowanceIncome = record.travelAllowance + record.specialAllowance;
    final configuredAllowanceIncome =
        rules.mealAllowanceDefault +
        rules.travelAllowanceDefault +
        rules.otherAllowanceDefault;
    final totalAllowanceIncome = allowanceIncome + configuredAllowanceIncome;
    final dailyIncome = baseIncome + otIncome + totalAllowanceIncome;

    return DailyCalculation(
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

  MonthlyCalculation calculateMonthly(
    Iterable<WorkRecordEntity> records,
    WorkSettings settings,
  ) {
    var workingDays = 0;
    var totalWorkHours = 0.0;
    var normalHours = 0.0;
    var otHours = 0.0;
    var grossIncome = 0.0;
    var expenseTotal = 0.0;

    for (final record in records) {
      final daily = calculateDaily(record, settings);
      workingDays += 1;
      totalWorkHours += daily.totalWorkHours;
      normalHours += daily.normalHours;
      otHours += daily.otHours;
      grossIncome += daily.dailyIncome;
      expenseTotal += record.expense;
    }

    final rules = settings.payrollRules;
    final socialSecurityDeduction = grossIncome > 0
        ? rules.socialSecurityDeduction
        : 0.0;
    final taxDeduction = grossIncome > 0 ? rules.taxDeduction : 0.0;
    final totalDeductions = socialSecurityDeduction + taxDeduction;

    return MonthlyCalculation(
      workingDays: workingDays,
      totalWorkHours: totalWorkHours,
      normalHours: normalHours,
      otHours: otHours,
      grossIncome: grossIncome,
      expenseTotal: expenseTotal,
      socialSecurityDeduction: socialSecurityDeduction,
      taxDeduction: taxDeduction,
      totalDeductions: totalDeductions,
      netIncome: grossIncome - expenseTotal - totalDeductions,
    );
  }

  double _shiftHours(
    int checkInMinutes,
    int checkOutMinutes,
    int breakMinutes,
  ) {
    var workedMinutes = checkOutMinutes - checkInMinutes;
    if (workedMinutes < 0) {
      workedMinutes += _minutesPerDay;
    }

    final netMinutes = workedMinutes - breakMinutes;
    if (netMinutes <= 0) {
      return 0;
    }

    return netMinutes / 60;
  }

  double _dayMultiplier(DayType dayType, PayrollRules rules) {
    return switch (dayType) {
      DayType.normal => rules.normalDayMultiplier,
      DayType.weekend => rules.weekendDayMultiplier,
      DayType.holiday => rules.holidayDayMultiplier,
    };
  }

  double _otMultiplier(DayType dayType, PayrollRules rules) {
    return switch (dayType) {
      DayType.normal => rules.normalOtMultiplier,
      DayType.weekend => rules.weekendOtMultiplier,
      DayType.holiday => rules.holidayOtMultiplier,
    };
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
