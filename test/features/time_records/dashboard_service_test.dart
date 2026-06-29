import 'package:test/test.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/application/dashboard_service.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  const service = DashboardService();
  final settings = const WorkSettings.defaults().copyWith(
    socialSecurityDeduction: 0,
    taxDeduction: 0,
  );

  test('aggregates monthly dashboard metrics', () {
    final dashboard = service.buildMonthlyDashboard(
      month: DateTime(2026, 6),
      records: [
        _record(
          id: 'normal',
          date: DateTime(2026, 6, 10),
          checkIn: 8 * 60,
          checkOut: 17 * 60,
          breakMinutes: 60,
          expense: 50,
        ),
        _record(
          id: 'ot',
          date: DateTime(2026, 6, 11),
          checkIn: 8 * 60,
          checkOut: 19 * 60,
          breakMinutes: 60,
        ),
        _record(
          id: 'ignored',
          date: DateTime(2026, 7, 1),
          checkIn: 8 * 60,
          checkOut: 17 * 60,
          breakMinutes: 60,
        ),
      ],
      settings: settings,
    );

    expect(dashboard.workingDays, 2);
    expect(dashboard.grossIncome, 2062.5);
    expect(dashboard.totalOtHours, 4);
    expect(dashboard.totalExpenses, 50);
    expect(dashboard.netIncome, 2012.5);
  });

  test('generates sorted chart points by day', () {
    final dashboard = service.buildMonthlyDashboard(
      month: DateTime(2026, 6),
      records: [
        _record(
          id: 'late',
          date: DateTime(2026, 6, 20),
          checkIn: 8 * 60,
          checkOut: 19 * 60,
          breakMinutes: 60,
          expense: 25,
        ),
        _record(
          id: 'early',
          date: DateTime(2026, 6, 3),
          checkIn: 8 * 60,
          checkOut: 17 * 60,
          breakMinutes: 60,
          expense: 10,
        ),
      ],
      settings: settings,
    );

    expect(dashboard.chartPoints.map((point) => point.day), [3, 20]);
    expect(dashboard.chartPoints.first.income, 890.625);
    expect(dashboard.chartPoints.first.expense, 10);
    expect(dashboard.chartPoints.last.otHours, 3);
  });

  test(
    'monthly dashboard preserves short shift durations without auto break',
    () {
      final dashboard = service.buildMonthlyDashboard(
        month: DateTime(2026, 6),
        records: [
          _record(
            id: 'one-hour',
            date: DateTime(2026, 6, 12),
            checkIn: 19 * 60,
            checkOut: 20 * 60,
          ),
          _record(
            id: 'three-hours',
            date: DateTime(2026, 6, 13),
            checkIn: (16 * 60) + 30,
            checkOut: (19 * 60) + 30,
          ),
        ],
        settings: settings,
      );

      expect(dashboard.workingDays, 2);
      expect(dashboard.grossIncome, 375);
      expect(dashboard.totalOtHours, 0);
      expect(dashboard.chartPoints, hasLength(2));
    },
  );
}

WorkRecordEntity _record({
  required String id,
  required DateTime date,
  required int checkIn,
  required int checkOut,
  int breakMinutes = 0,
  DayType dayType = DayType.normal,
  double expense = 0,
}) {
  final now = DateTime(2026, 6, 25, 8);
  return WorkRecordEntity(
    id: id,
    workDate: DateTime(date.year, date.month, date.day),
    checkInMinutes: checkIn,
    checkOutMinutes: checkOut,
    breakMinutes: breakMinutes,
    dayType: dayType,
    extraOtHours: 0,
    travelAllowance: 0,
    specialAllowance: 0,
    expense: expense,
    note: '',
    createdAt: now,
    updatedAt: now,
  );
}
