import 'package:test/test.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/application/work_calculator.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  const calculator = WorkCalculator();
  const settings = WorkSettings.defaults();

  test('normal 8-hour day', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60, breakMinutes: 60),
      settings,
    );

    expect(result.totalWorkHours, 8);
    expect(result.normalHours, 8);
    expect(result.otHours, 0);
    expect(result.dailyIncome, 500);
  });

  test('10-hour day with 2 OT hours', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 19 * 60, breakMinutes: 60),
      settings,
    );

    expect(result.totalWorkHours, 10);
    expect(result.normalHours, 8);
    expect(result.otHours, 2);
    expect(result.dailyIncome, 687.5);
  });

  test('overnight shift', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 22 * 60, checkOut: 6 * 60, breakMinutes: 0),
      settings,
    );

    expect(result.totalWorkHours, 8);
    expect(result.normalHours, 8);
    expect(result.otHours, 0);
  });

  test('weekend and holiday days are calculated as OT days', () {
    final weekend = calculator.calculateDaily(
      _record(
        checkIn: 8 * 60,
        checkOut: 16 * 60,
        breakMinutes: 0,
        dayType: DayType.weekend,
      ),
      settings,
    );
    final holiday = calculator.calculateDaily(
      _record(
        checkIn: 8 * 60,
        checkOut: 16 * 60,
        breakMinutes: 0,
        dayType: DayType.holiday,
      ),
      settings,
    );

    expect(weekend.normalHours, 0);
    expect(weekend.otHours, 8);
    expect(weekend.dailyIncome, 1000);
    expect(holiday.normalHours, 0);
    expect(holiday.otHours, 8);
    expect(holiday.dailyIncome, 1500);
  });

  test('break minutes deduction', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60, breakMinutes: 90),
      settings,
    );

    expect(result.totalWorkHours, 7.5);
    expect(result.normalHours, 7.5);
    expect(result.dailyIncome, 468.75);
  });
}

WorkRecordEntity _record({
  required int checkIn,
  required int checkOut,
  required int breakMinutes,
  DayType dayType = DayType.normal,
  double extraOtHours = 0,
}) {
  final now = DateTime(2026, 6, 25, 8);
  return WorkRecordEntity(
    id: 'test-record',
    workDate: DateTime(2026, 6, 25),
    checkInMinutes: checkIn,
    checkOutMinutes: checkOut,
    breakMinutes: breakMinutes,
    dayType: dayType,
    extraOtHours: extraOtHours,
    travelAllowance: 0,
    specialAllowance: 0,
    expense: 0,
    note: '',
    createdAt: now,
    updatedAt: now,
  );
}
