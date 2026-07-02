import '../../../payroll/payroll_engine.dart';
import '../../settings/domain/work_settings.dart';
import '../domain/work_record.dart';

class DailyCalculation {
  const DailyCalculation({
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
  const WorkCalculator({this.engine = const PayrollEngine()});

  final PayrollEngine engine;

  DailyCalculation calculateDaily(
    WorkRecordEntity record,
    WorkSettings settings,
  ) {
    final result = engine.calculateDaily(record, settings);

    return DailyCalculation(
      totalWorkHours: result.totalWorkHours,
      normalHours: result.normalHours,
      rawOtHours: result.rawOtHours,
      adjustedOtHours: result.adjustedOtHours,
      roundedOtHours: result.roundedOtHours,
      otHours: result.otHours,
      nightShiftHours: result.nightShiftHours,
      baseIncome: result.baseIncome,
      otIncome: result.otIncome,
      allowanceIncome: result.allowanceIncome,
      dailyIncome: result.dailyIncome,
      netIncome: result.netIncome,
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
}
