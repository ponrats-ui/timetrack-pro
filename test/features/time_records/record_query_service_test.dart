import 'package:test/test.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/application/record_query_service.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  const service = RecordQueryService();
  final settings = const WorkSettings.defaults().copyWith(
    socialSecurityDeduction: 0,
    taxDeduction: 0,
  );

  test('searches records by note, date, and month text', () {
    final records = [
      _record(id: 'a', date: DateTime(2026, 6, 10), note: 'route bangna'),
      _record(id: 'b', date: DateTime(2026, 7, 12), note: 'warehouse'),
    ];

    expect(
      service
          .apply(
            records: records,
            settings: settings,
            criteria: const RecordSearchCriteria(query: 'bangna'),
          )
          .map((item) => item.record.id),
      ['a'],
    );
    expect(
      service
          .apply(
            records: records,
            settings: settings,
            criteria: const RecordSearchCriteria(query: '10/06/2569'),
          )
          .map((item) => item.record.id),
      ['a'],
    );
    expect(
      service
          .apply(
            records: records,
            settings: settings,
            criteria: const RecordSearchCriteria(query: '2026-07'),
          )
          .map((item) => item.record.id),
      ['b'],
    );
  });

  test('filters and sorts by OT and income', () {
    final records = [
      _record(id: 'normal', date: DateTime(2026, 6, 10), checkOut: 17 * 60),
      _record(id: 'ot', date: DateTime(2026, 6, 11), checkOut: 20 * 60),
      _record(
        id: 'holiday',
        date: DateTime(2026, 6, 12),
        checkOut: 16 * 60,
        dayType: DayType.holiday,
      ),
    ];

    final result = service.apply(
      records: records,
      settings: settings,
      criteria: const RecordSearchCriteria(
        filters: {RecordFilter.otOnly},
        sortOption: RecordSortOption.highestIncome,
      ),
    );

    expect(result.map((item) => item.record.id), ['ot']);
  });

  test('filters by exact month and expense', () {
    final records = [
      _record(id: 'expense', date: DateTime(2026, 6, 10), expense: 100),
      _record(id: 'no-expense', date: DateTime(2026, 6, 11)),
      _record(id: 'other-month', date: DateTime(2026, 7, 1), expense: 100),
    ];

    final result = service.apply(
      records: records,
      settings: settings,
      criteria: RecordSearchCriteria(
        month: DateTime(2026, 6),
        filters: const {RecordFilter.expense},
      ),
    );

    expect(result.map((item) => item.record.id), ['expense']);
  });

  test('history list items preserve short shift duration with zero break', () {
    final result = service.apply(
      records: [
        _record(
          id: 'one-hour',
          date: DateTime(2026, 6, 12),
          checkIn: 19 * 60,
          checkOut: 20 * 60,
          breakMinutes: 0,
        ),
        _record(
          id: 'three-hours',
          date: DateTime(2026, 6, 13),
          checkIn: (16 * 60) + 30,
          checkOut: (19 * 60) + 30,
          breakMinutes: 0,
        ),
      ],
      settings: settings,
      criteria: const RecordSearchCriteria(sortOption: RecordSortOption.oldest),
    );

    expect(result.map((item) => item.calculation.totalWorkHours), [1, 3]);
  });
}

WorkRecordEntity _record({
  required String id,
  required DateTime date,
  int checkIn = 8 * 60,
  int checkOut = 17 * 60,
  int? breakMinutes,
  DayType dayType = DayType.normal,
  double expense = 0,
  String note = '',
}) {
  final now = DateTime(2026, 6, 25, 8);
  return WorkRecordEntity(
    id: id,
    workDate: DateTime(date.year, date.month, date.day),
    checkInMinutes: checkIn,
    checkOutMinutes: checkOut,
    breakMinutes: breakMinutes ?? (dayType == DayType.normal ? 60 : 0),
    dayType: dayType,
    extraOtHours: 0,
    travelAllowance: 0,
    specialAllowance: 0,
    expense: expense,
    note: note,
    createdAt: now,
    updatedAt: now,
  );
}
