import 'package:test/test.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/application/statistics_service.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  const service = StatisticsService();
  final settings = const WorkSettings.defaults().copyWith(
    socialSecurityDeduction: 0,
    taxDeduction: 0,
  );

  test('builds weekly summary for Monday to Sunday range', () {
    final summary = service.buildSummary(
      period: StatisticsPeriod.week,
      anchorDate: DateTime(2026, 6, 25),
      records: [
        _record(id: 'monday', date: DateTime(2026, 6, 22)),
        _record(id: 'sunday', date: DateTime(2026, 6, 28), checkOut: 19 * 60),
        _record(id: 'outside', date: DateTime(2026, 6, 29)),
      ],
      settings: settings,
    );

    expect(summary.startDate, DateTime(2026, 6, 22));
    expect(summary.endDate, DateTime(2026, 6, 28));
    expect(summary.workingDays, 2);
    expect(summary.totalOtHours, 2);
  });

  test('builds monthly and yearly summaries', () {
    final records = [
      _record(id: 'june', date: DateTime(2026, 6, 1)),
      _record(id: 'july', date: DateTime(2026, 7, 1), expense: 50),
      _record(id: 'other-year', date: DateTime(2027, 6, 1)),
    ];

    final monthly = service.buildSummary(
      period: StatisticsPeriod.month,
      anchorDate: DateTime(2026, 6, 25),
      records: records,
      settings: settings,
    );
    final yearly = service.buildSummary(
      period: StatisticsPeriod.year,
      anchorDate: DateTime(2026, 6, 25),
      records: records,
      settings: settings,
    );

    expect(monthly.workingDays, 1);
    expect(monthly.grossIncome, 500);
    expect(yearly.workingDays, 2);
    expect(yearly.totalExpenses, 50);
  });
}

WorkRecordEntity _record({
  required String id,
  required DateTime date,
  int checkOut = 17 * 60,
  double expense = 0,
}) {
  final now = DateTime(2026, 6, 25, 8);
  return WorkRecordEntity(
    id: id,
    workDate: DateTime(date.year, date.month, date.day),
    checkInMinutes: 8 * 60,
    checkOutMinutes: checkOut,
    breakMinutes: 60,
    dayType: DayType.normal,
    extraOtHours: 0,
    travelAllowance: 0,
    specialAllowance: 0,
    expense: expense,
    note: '',
    createdAt: now,
    updatedAt: now,
  );
}
