import '../../settings/domain/work_settings.dart';
import '../domain/work_record.dart';

class DailyCalculation {
  const DailyCalculation({
    required this.totalWorkHours,
    required this.normalHours,
    required this.otHours,
    required this.baseIncome,
    required this.otIncome,
    required this.allowanceIncome,
    required this.dailyIncome,
    required this.netIncome,
  });

  final double totalWorkHours;
  final double normalHours;
  final double otHours;
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
    final totalWorkHours = _shiftHours(
      record.checkInMinutes,
      record.checkOutMinutes,
      record.breakMinutes,
    );
    final normalHours = record.dayType == DayType.normal
        ? totalWorkHours.clamp(0, settings.normalWorkHours).toDouble()
        : 0.0;
    final otFromShift = record.dayType == DayType.normal
        ? (totalWorkHours - settings.normalWorkHours).clamp(0, double.infinity)
        : totalWorkHours;
    final otHours = otFromShift + record.extraOtHours;
    final baseIncome = normalHours * settings.hourlyWage;
    final otIncome =
        otHours * settings.hourlyWage * _otMultiplier(record, settings);
    final allowanceIncome = record.travelAllowance + record.specialAllowance;
    final dailyIncome = baseIncome + otIncome + allowanceIncome;

    return DailyCalculation(
      totalWorkHours: totalWorkHours,
      normalHours: normalHours,
      otHours: otHours,
      baseIncome: baseIncome,
      otIncome: otIncome,
      allowanceIncome: allowanceIncome,
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

    final socialSecurityDeduction = grossIncome > 0
        ? settings.socialSecurityDeduction
        : 0.0;
    final taxDeduction = grossIncome > 0 ? settings.taxDeduction : 0.0;
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
      workedMinutes += 24 * 60;
    }

    final netMinutes = workedMinutes - breakMinutes;
    if (netMinutes <= 0) {
      return 0;
    }

    return netMinutes / 60;
  }

  double _otMultiplier(WorkRecordEntity record, WorkSettings settings) {
    return switch (record.dayType) {
      DayType.normal => settings.otRate15,
      DayType.weekend => settings.otRate2,
      DayType.holiday => settings.otRate3,
    };
  }
}
