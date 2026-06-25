import '../../settings/domain/work_settings.dart';
import '../domain/work_record.dart';
import 'work_calculator.dart';

enum StatisticsPeriod { week, month, year }

extension StatisticsPeriodLabel on StatisticsPeriod {
  String get label {
    return switch (this) {
      StatisticsPeriod.week => 'สัปดาห์นี้',
      StatisticsPeriod.month => 'เดือนนี้',
      StatisticsPeriod.year => 'ปีนี้',
    };
  }
}

class StatisticsSummary {
  const StatisticsSummary({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.workingDays,
    required this.grossIncome,
    required this.netIncome,
    required this.totalOtHours,
    required this.totalExpenses,
  });

  final StatisticsPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final int workingDays;
  final double grossIncome;
  final double netIncome;
  final double totalOtHours;
  final double totalExpenses;
}

class StatisticsService {
  const StatisticsService({this.calculator = const WorkCalculator()});

  final WorkCalculator calculator;

  StatisticsSummary buildSummary({
    required StatisticsPeriod period,
    required DateTime anchorDate,
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
  }) {
    final range = _rangeFor(period, anchorDate);
    final scopedRecords = records.where((record) {
      final date = DateTime(
        record.workDate.year,
        record.workDate.month,
        record.workDate.day,
      );
      return !date.isBefore(range.start) && !date.isAfter(range.end);
    }).toList();
    final monthly = calculator.calculateMonthly(scopedRecords, settings);

    return StatisticsSummary(
      period: period,
      startDate: range.start,
      endDate: range.end,
      workingDays: monthly.workingDays,
      grossIncome: monthly.grossIncome,
      netIncome: monthly.netIncome,
      totalOtHours: monthly.otHours,
      totalExpenses: monthly.expenseTotal,
    );
  }

  ({DateTime start, DateTime end}) _rangeFor(
    StatisticsPeriod period,
    DateTime anchorDate,
  ) {
    final date = DateTime(anchorDate.year, anchorDate.month, anchorDate.day);
    return switch (period) {
      StatisticsPeriod.week => (
        start: date.subtract(Duration(days: date.weekday - 1)),
        end: date.add(Duration(days: DateTime.daysPerWeek - date.weekday)),
      ),
      StatisticsPeriod.month => (
        start: DateTime(date.year, date.month),
        end: DateTime(date.year, date.month + 1, 0),
      ),
      StatisticsPeriod.year => (
        start: DateTime(date.year),
        end: DateTime(date.year, 12, 31),
      ),
    };
  }
}
