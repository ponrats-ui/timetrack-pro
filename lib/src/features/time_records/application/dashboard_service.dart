import '../../settings/domain/work_settings.dart';
import '../domain/work_record.dart';
import 'work_calculator.dart';

class DailyChartPoint {
  const DailyChartPoint({
    required this.date,
    required this.income,
    required this.otHours,
    required this.expense,
  });

  final DateTime date;
  final double income;
  final double otHours;
  final double expense;

  int get day => date.day;
}

class IncomeExpenseSummary {
  const IncomeExpenseSummary({required this.income, required this.expense});

  final double income;
  final double expense;
}

class MonthlyDashboardData {
  const MonthlyDashboardData({
    required this.workingDays,
    required this.grossIncome,
    required this.netIncome,
    required this.totalOtHours,
    required this.totalExpenses,
    required this.chartPoints,
    required this.incomeExpenseSummary,
  });

  final int workingDays;
  final double grossIncome;
  final double netIncome;
  final double totalOtHours;
  final double totalExpenses;
  final List<DailyChartPoint> chartPoints;
  final IncomeExpenseSummary incomeExpenseSummary;

  bool get hasChartData => chartPoints.isNotEmpty;
}

class DashboardService {
  const DashboardService({this.calculator = const WorkCalculator()});

  final WorkCalculator calculator;

  MonthlyDashboardData buildMonthlyDashboard({
    required DateTime month,
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
  }) {
    final normalizedMonth = DateTime(month.year, month.month);
    final monthlyRecords = records.where((record) {
      return record.workDate.year == normalizedMonth.year &&
          record.workDate.month == normalizedMonth.month;
    }).toList()..sort((a, b) => a.workDate.compareTo(b.workDate));

    return buildDashboard(records: monthlyRecords, settings: settings);
  }

  MonthlyDashboardData buildDashboard({
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
  }) {
    final scopedRecords = records.toList()
      ..sort((a, b) => a.workDate.compareTo(b.workDate));

    final monthly = calculator.calculateMonthly(scopedRecords, settings);
    final grouped = <DateTime, _DailyTotals>{};

    for (final record in scopedRecords) {
      final key = DateTime(
        record.workDate.year,
        record.workDate.month,
        record.workDate.day,
      );
      final calculation = calculator.calculateDaily(record, settings);
      final totals = grouped.putIfAbsent(key, _DailyTotals.new);
      totals.income += calculation.dailyIncome;
      totals.otHours += calculation.otHours;
      totals.expense += record.expense;
    }

    final points = grouped.entries.map((entry) {
      return DailyChartPoint(
        date: entry.key,
        income: entry.value.income,
        otHours: entry.value.otHours,
        expense: entry.value.expense,
      );
    }).toList()..sort((a, b) => a.date.compareTo(b.date));

    return MonthlyDashboardData(
      workingDays: monthly.workingDays,
      grossIncome: monthly.grossIncome,
      netIncome: monthly.netIncome,
      totalOtHours: monthly.otHours,
      totalExpenses: monthly.expenseTotal,
      chartPoints: List.unmodifiable(points),
      incomeExpenseSummary: IncomeExpenseSummary(
        income: monthly.grossIncome,
        expense: monthly.expenseTotal,
      ),
    );
  }
}

class _DailyTotals {
  double income = 0;
  double otHours = 0;
  double expense = 0;
}
