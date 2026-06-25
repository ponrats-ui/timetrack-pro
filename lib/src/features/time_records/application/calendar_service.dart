import '../../settings/domain/work_settings.dart';
import '../domain/work_record.dart';
import 'work_calculator.dart';

class CalendarDaySummary {
  const CalendarDaySummary({
    required this.date,
    required this.records,
    required this.totalWorkHours,
    required this.totalOtHours,
    required this.totalIncome,
    required this.totalExpense,
  });

  final DateTime date;
  final List<WorkRecordEntity> records;
  final double totalWorkHours;
  final double totalOtHours;
  final double totalIncome;
  final double totalExpense;

  bool get hasRecords => records.isNotEmpty;

  bool get hasNormal =>
      records.any((record) => record.dayType == DayType.normal);

  bool get hasWeekend =>
      records.any((record) => record.dayType == DayType.weekend);

  bool get hasHoliday =>
      records.any((record) => record.dayType == DayType.holiday);

  bool get hasOt => totalOtHours > 0;

  bool get hasExpense => totalExpense > 0;
}

class CalendarMonthData {
  const CalendarMonthData({required this.month, required this.days});

  final DateTime month;
  final Map<DateTime, CalendarDaySummary> days;

  CalendarDaySummary? summaryFor(DateTime date) {
    return days[DateTime(date.year, date.month, date.day)];
  }
}

class CalendarService {
  const CalendarService({this.calculator = const WorkCalculator()});

  final WorkCalculator calculator;

  CalendarMonthData groupMonth({
    required DateTime month,
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
  }) {
    final normalizedMonth = DateTime(month.year, month.month);
    final grouped = <DateTime, List<WorkRecordEntity>>{};

    for (final record in records) {
      if (record.workDate.year != normalizedMonth.year ||
          record.workDate.month != normalizedMonth.month) {
        continue;
      }

      final key = DateTime(
        record.workDate.year,
        record.workDate.month,
        record.workDate.day,
      );
      grouped.putIfAbsent(key, () => <WorkRecordEntity>[]).add(record);
    }

    final summaries = <DateTime, CalendarDaySummary>{};
    for (final entry in grouped.entries) {
      var totalWorkHours = 0.0;
      var totalOtHours = 0.0;
      var totalIncome = 0.0;
      var totalExpense = 0.0;

      for (final record in entry.value) {
        final daily = calculator.calculateDaily(record, settings);
        totalWorkHours += daily.totalWorkHours;
        totalOtHours += daily.otHours;
        totalIncome += daily.dailyIncome;
        totalExpense += record.expense;
      }

      summaries[entry.key] = CalendarDaySummary(
        date: entry.key,
        records: List.unmodifiable(entry.value),
        totalWorkHours: totalWorkHours,
        totalOtHours: totalOtHours,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      );
    }

    return CalendarMonthData(
      month: normalizedMonth,
      days: Map.unmodifiable(summaries),
    );
  }
}
