import 'package:test/test.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/application/work_calculator.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  const calculator = WorkCalculator();
  const settings = WorkSettings.defaults();

  test('default settings do not deduct break automatically', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60),
      settings,
    );

    expect(settings.defaultBreakMinutes, 0);
    expect(result.totalWorkHours, 9);
    expect(result.normalHours, 9);
    expect(result.otHours, 0);
  });

  test('duration calculation keeps short and long shifts intact', () {
    final cases = {
      (8 * 60, 17 * 60): 9.0,
      (19 * 60, 20 * 60): 1.0,
      ((16 * 60) + 30, (19 * 60) + 30): 3.0,
      ((8 * 60) + 30, (17 * 60) + 30): 9.0,
      (22 * 60, 6 * 60): 8.0,
      (8 * 60, (12 * 60) + 15): 4.25,
      ((13 * 60) + 10, (17 * 60) + 40): 4.5,
    };

    for (final entry in cases.entries) {
      final result = calculator.calculateDaily(
        _record(checkIn: entry.key.$1, checkOut: entry.key.$2),
        settings,
      );

      expect(
        result.totalWorkHours,
        entry.value,
        reason: '${entry.key.$1} to ${entry.key.$2}',
      );
    }
  });

  test('normal day ignores explicit break for payroll calculation', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60, breakMinutes: 60),
      settings,
    );

    expect(result.totalWorkHours, 9);
    expect(result.normalHours, 9);
    expect(result.otHours, 0);
    expect(result.dailyIncome, 750);
  });

  test('long shift calculates OT without subtracting explicit break', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 19 * 60, breakMinutes: 60),
      settings,
    );

    expect(result.totalWorkHours, 11);
    expect(result.normalHours, 9);
    expect(result.otHours, 2);
    expect(result.dailyIncome, closeTo(1000, 0.001));
  });

  test('overnight shift without break', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 22 * 60, checkOut: 6 * 60),
      settings,
    );

    expect(result.totalWorkHours, 8);
    expect(result.normalHours, 0);
    expect(result.otHours, 8);
    expect(result.nightShiftHours, 7);
    expect(result.dailyIncome, closeTo(1291.667, 0.001));
  });

  test(
    'weekend and holiday days use configured inside-schedule multipliers',
    () {
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

      expect(weekend.normalHours, 8);
      expect(weekend.otHours, 0);
      expect(weekend.dailyIncome, 1000);
      expect(holiday.normalHours, 8);
      expect(holiday.otHours, 0);
      expect(holiday.dailyIncome, 1000);
    },
  );

  test('break minutes are stored but not deducted', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60, breakMinutes: 90),
      settings,
    );

    expect(result.totalWorkHours, 9);
    expect(result.normalHours, 9);
    expect(result.otHours, 0);
    expect(result.dailyIncome, 750);
  });

  test('configured default break does not reduce calculated hours', () {
    final configured = settings.copyWith(defaultBreakMinutes: 45);
    final noBreak = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60),
      configured,
    );
    final configuredBreak = calculator.calculateDaily(
      _record(
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        breakMinutes: configured.defaultBreakMinutes,
      ),
      configured,
    );

    expect(noBreak.totalWorkHours, 9);
    expect(configuredBreak.totalWorkHours, 9);
  });

  test('monthly summary preserves corrected short shift duration', () {
    final result = calculator.calculateMonthly([
      _record(checkIn: 19 * 60, checkOut: 20 * 60),
      _record(checkIn: (16 * 60) + 30, checkOut: (19 * 60) + 30),
    ], settings);

    expect(result.totalWorkHours, 4);
    expect(result.workingDays, 2);
  });

  test('monthly net subtracts social security and tax deductions', () {
    final result = calculator.calculateMonthly([
      _record(checkIn: 8 * 60, checkOut: 17 * 60, breakMinutes: 60),
    ], settings.copyWith(taxDeduction: 100));

    expect(result.grossIncome, 750);
    expect(result.socialSecurityDeduction, 750);
    expect(result.taxDeduction, 100);
    expect(result.totalDeductions, 850);
    expect(result.netIncome, -100);
  });

  test('normal OT multiplier is configurable', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 19 * 60, breakMinutes: 60),
      settings.copyWith(normalOtMultiplier: 2),
    );

    expect(result.otHours, 2);
    expect(result.otIncome, closeTo(333.333, 0.001));
    expect(result.dailyIncome, closeTo(1083.333, 0.001));
  });

  test('holiday OT multiplier is configurable', () {
    final result = calculator.calculateDaily(
      _record(
        checkIn: 8 * 60,
        checkOut: 19 * 60,
        breakMinutes: 60,
        dayType: DayType.holiday,
      ),
      settings.copyWith(holidayOtMultiplier: 4),
    );

    expect(result.normalHours, 9);
    expect(result.otHours, 2);
    expect(result.baseIncome, 1125);
    expect(result.otIncome, closeTo(666.667, 0.001));
    expect(result.dailyIncome, closeTo(1791.667, 0.001));
  });

  test('weekend OT multiplier is configurable', () {
    final result = calculator.calculateDaily(
      _record(
        checkIn: 8 * 60,
        checkOut: 19 * 60,
        breakMinutes: 60,
        dayType: DayType.weekend,
      ),
      settings.copyWith(weekendOtMultiplier: 2.5),
    );

    expect(result.normalHours, 9);
    expect(result.otHours, 2);
    expect(result.baseIncome, 1125);
    expect(result.otIncome, closeTo(416.667, 0.001));
    expect(result.dailyIncome, closeTo(1541.667, 0.001));
  });

  test('night OT multiplier is configurable', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 20 * 60, checkOut: 7 * 60, breakMinutes: 60),
      settings.copyWith(nightOtMultiplier: 2.5),
    );

    expect(result.totalWorkHours, 11);
    expect(result.nightShiftHours, 7);
    expect(result.otHours, 11);
    expect(result.dailyIncome, closeTo(1958.333, 0.001));
  });

  test('allowance rules include meal, travel, and other defaults', () {
    final result = calculator.calculateDaily(
      _record(
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        breakMinutes: 60,
        travelAllowance: 40,
        specialAllowance: 25,
      ),
      settings.copyWith(
        mealAllowanceDefault: 60,
        travelAllowanceDefault: 30,
        otherAllowanceDefault: 20,
      ),
    );

    expect(result.baseIncome, 750);
    expect(result.allowanceIncome, 175);
    expect(result.dailyIncome, 925);
  });

  test('derives daily and hourly wage from salary and work schedule', () {
    final monFri = settings.copyWith(
      monthlySalary: 21000,
      workSchedule: WorkSchedule.mondayFriday,
    );
    final monSat = settings.copyWith(
      monthlySalary: 21000,
      workSchedule: WorkSchedule.mondaySaturday,
    );

    expect(monFri.derivedDailyWage, 1050);
    expect(monSat.derivedDailyWage, 875);
    expect(monFri.hourlyWage, closeTo(116.667, 0.001));
  });

  test('auto OT follows selected normal work schedule', () {
    final earlySchedule = settings.copyWith(
      monthlySalary: 21000,
      workSchedule: WorkSchedule.mondayFriday,
      normalWorkSchedule: NormalWorkSchedule.eightToFive,
    );
    final lateSchedule = earlySchedule.copyWith(
      normalWorkSchedule: NormalWorkSchedule.nineToSix,
    );

    final eightToEight = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 20 * 60),
      earlySchedule,
    );
    final nineToTen = calculator.calculateDaily(
      _record(checkIn: 9 * 60, checkOut: 22 * 60),
      lateSchedule,
    );
    final eveningOnly = calculator.calculateDaily(
      _record(checkIn: 19 * 60, checkOut: 23 * 60),
      earlySchedule,
    );

    expect(eightToEight.normalHours, 9);
    expect(eightToEight.otHours, 3);
    expect(nineToTen.normalHours, 9);
    expect(nineToTen.otHours, 4);
    expect(eveningOnly.normalHours, 0);
    expect(eveningOnly.otHours, 4);
  });

  test('custom overnight schedule supports night shift normal hours', () {
    final customNight = settings.copyWith(
      normalWorkSchedule: NormalWorkSchedule.custom,
      customScheduleStartMinutes: 22 * 60,
      customScheduleEndMinutes: 6 * 60,
    );
    final result = calculator.calculateDaily(
      _record(checkIn: 22 * 60, checkOut: 8 * 60),
      customNight,
    );

    expect(result.totalWorkHours, 10);
    expect(result.normalHours, 8);
    expect(result.otHours, 2);
  });

  test('holiday outside configured schedule is paid as holiday OT', () {
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 20 * 60, dayType: DayType.holiday),
      settings.copyWith(holidayDayMultiplier: 1.5, holidayOtMultiplier: 3),
    );

    expect(result.normalHours, 9);
    expect(result.otHours, 3);
    expect(result.baseIncome, 1125);
    expect(result.otIncome, 750);
    expect(result.dailyIncome, 1875);
  });

  test('founder approved short shift duration uses direct hours', () {
    final result = calculator.calculateDaily(
      _record(checkIn: (16 * 60) + 30, checkOut: (19 * 60) + 30),
      settings.copyWith(
        monthlySalary: 21000,
        workSchedule: WorkSchedule.mondayFriday,
      ),
    );

    expect(result.totalWorkHours, 3);
    expect(result.normalHours, 0.5);
    expect(result.otHours, 2.5);
  });
}

WorkRecordEntity _record({
  required int checkIn,
  required int checkOut,
  int breakMinutes = 0,
  DayType dayType = DayType.normal,
  double extraOtHours = 0,
  double travelAllowance = 0,
  double specialAllowance = 0,
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
    travelAllowance: travelAllowance,
    specialAllowance: specialAllowance,
    expense: 0,
    note: '',
    createdAt: now,
    updatedAt: now,
  );
}
