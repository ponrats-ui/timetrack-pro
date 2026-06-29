import 'package:test/test.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/application/calendar_service.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  const service = CalendarService();
  const settings = WorkSettings.defaults();

  test('groups work records by calendar date with marker flags', () {
    final data = service.groupMonth(
      month: DateTime(2026, 6),
      records: [
        _record(
          id: 'normal',
          date: DateTime(2026, 6, 10),
          checkIn: 8 * 60,
          checkOut: 19 * 60,
          expense: 120,
        ),
        _record(
          id: 'holiday',
          date: DateTime(2026, 6, 10),
          checkIn: 8 * 60,
          checkOut: 10 * 60,
          dayType: DayType.holiday,
        ),
        _record(
          id: 'other-month',
          date: DateTime(2026, 7, 1),
          checkIn: 8 * 60,
          checkOut: 17 * 60,
        ),
      ],
      settings: settings,
    );

    final summary = data.summaryFor(DateTime(2026, 6, 10));

    expect(data.days.length, 1);
    expect(summary, isNotNull);
    expect(summary!.records, hasLength(2));
    expect(summary.hasNormal, isTrue);
    expect(summary.hasHoliday, isTrue);
    expect(summary.hasOt, isTrue);
    expect(summary.hasExpense, isTrue);
    expect(summary.totalExpense, 120);
  });

  test(
    'calendar summary preserves short shift durations without auto break',
    () {
      final data = service.groupMonth(
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
            date: DateTime(2026, 6, 12),
            checkIn: (16 * 60) + 30,
            checkOut: (19 * 60) + 30,
          ),
        ],
        settings: settings,
      );

      final summary = data.summaryFor(DateTime(2026, 6, 12));

      expect(summary, isNotNull);
      expect(summary!.totalWorkHours, 4);
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
