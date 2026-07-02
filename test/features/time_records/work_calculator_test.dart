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
      settings.copyWith(nightOtMultiplier: 2),
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

  test('OT start policy can delay paid OT after scheduled end', () {
    final policySettings = settings.copyWith(
      normalWorkSchedule: NormalWorkSchedule.eightToFive,
      otStartMinutes: 18 * 60,
      otRoundingPolicy: OtRoundingPolicy.none,
    );
    final result = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 20 * 60),
      policySettings,
    );
    final gapOnly = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: 18 * 60),
      policySettings,
    );

    expect(result.totalWorkHours, 12);
    expect(result.normalHours, 9);
    expect(result.graceHours, 1);
    expect(result.rawOtHours, 2);
    expect(result.adjustedOtHours, 2);
    expect(result.roundedOtHours, 2);
    expect(result.otHours, 2);
    expect(gapOnly.graceHours, 1);
    expect(gapOnly.rawOtHours, 0);
    expect(gapOnly.adjustedOtHours, 0);
    expect(gapOnly.otHours, 0);
  });

  test('early work and grace time do not become paid OT', () {
    final policySettings = settings.copyWith(
      normalWorkSchedule: NormalWorkSchedule.nineToSix,
      otStartMinutes: 19 * 60,
      otRoundingPolicy: OtRoundingPolicy.none,
      mealAllowanceDefault: 0,
      travelAllowanceDefault: 0,
      otherAllowanceDefault: 0,
      socialSecurityDeduction: 0,
      taxDeduction: 0,
    );
    final earlyShift = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60),
      policySettings,
    );
    final normalShift = calculator.calculateDaily(
      _record(checkIn: 9 * 60, checkOut: 18 * 60),
      policySettings,
    );
    final graceOnly = calculator.calculateDaily(
      _record(checkIn: 18 * 60, checkOut: 19 * 60),
      policySettings,
    );
    final normalGraceOt = calculator.calculateDaily(
      _record(checkIn: 9 * 60, checkOut: 20 * 60),
      policySettings,
    );

    expect(earlyShift.totalWorkHours, 9);
    expect(earlyShift.earlyWorkHours, 1);
    expect(earlyShift.normalHours, 8);
    expect(earlyShift.graceHours, 0);
    expect(earlyShift.rawOtHours, 0);
    expect(earlyShift.otHours, 0);
    expect(earlyShift.otIncome, 0);

    expect(normalShift.earlyWorkHours, 0);
    expect(normalShift.normalHours, 9);
    expect(normalShift.graceHours, 0);
    expect(normalShift.otHours, 0);

    expect(graceOnly.earlyWorkHours, 0);
    expect(graceOnly.normalHours, 0);
    expect(graceOnly.graceHours, 1);
    expect(graceOnly.rawOtHours, 0);
    expect(graceOnly.otHours, 0);

    expect(normalGraceOt.normalHours, 9);
    expect(normalGraceOt.graceHours, 1);
    expect(normalGraceOt.rawOtHours, 1);
    expect(normalGraceOt.otHours, 1);
  });

  test('OT start policy handles early work with later paid OT', () {
    final policySettings = settings.copyWith(
      normalWorkSchedule: NormalWorkSchedule.eightToFive,
      otStartMinutes: 18 * 60,
      otRoundingPolicy: OtRoundingPolicy.none,
    );
    final normalWithGraceAndOt = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 20 * 60),
      policySettings,
    );
    final earlyNormalGraceOt = calculator.calculateDaily(
      _record(checkIn: 7 * 60, checkOut: 20 * 60),
      policySettings,
    );

    expect(normalWithGraceAndOt.earlyWorkHours, 0);
    expect(normalWithGraceAndOt.normalHours, 9);
    expect(normalWithGraceAndOt.graceHours, 1);
    expect(normalWithGraceAndOt.rawOtHours, 2);
    expect(normalWithGraceAndOt.otHours, 2);

    expect(earlyNormalGraceOt.totalWorkHours, 13);
    expect(earlyNormalGraceOt.earlyWorkHours, 1);
    expect(earlyNormalGraceOt.normalHours, 9);
    expect(earlyNormalGraceOt.graceHours, 1);
    expect(earlyNormalGraceOt.rawOtHours, 2);
    expect(earlyNormalGraceOt.otHours, 2);
  });

  test('overnight OT respects configured OT start after schedule', () {
    final policySettings = settings.copyWith(
      normalWorkSchedule: NormalWorkSchedule.nineToSix,
      otStartMinutes: 19 * 60,
      otRoundingPolicy: OtRoundingPolicy.none,
    );
    final result = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: 2 * 60),
      policySettings,
    );

    expect(result.totalWorkHours, 9);
    expect(result.earlyWorkHours, 0);
    expect(result.normalHours, 1);
    expect(result.graceHours, 1);
    expect(result.rawOtHours, 7);
    expect(result.otHours, 7);
  });

  test('minimum OT starts payment only after configured threshold', () {
    final policySettings = settings.copyWith(
      minimumOtMinutes: 30,
      otRoundingPolicy: OtRoundingPolicy.companyHalfHour,
    );
    final shortOt = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: (17 * 60) + 20),
      policySettings,
    );
    final payableOt = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: (17 * 60) + 35),
      policySettings,
    );

    expect(shortOt.rawOtHours, closeTo(20 / 60, 0.001));
    expect(shortOt.adjustedOtHours, 0);
    expect(shortOt.otHours, 0);
    expect(payableOt.adjustedOtHours, closeTo(35 / 60, 0.001));
    expect(payableOt.roundedOtHours, 0.5);
    expect(payableOt.otHours, 0.5);
  });

  test('company OT rounding follows 0 30 60 minute bands every hour', () {
    final policySettings = settings.copyWith(
      otRoundingPolicy: OtRoundingPolicy.companyHalfHour,
    );
    final tenMinutes = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: (17 * 60) + 10),
      policySettings,
    );
    final eighteenMinutes = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: (17 * 60) + 18),
      policySettings,
    );
    final fortyFourMinutes = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: (17 * 60) + 44),
      policySettings,
    );
    final fortySixMinutes = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: (17 * 60) + 46),
      policySettings,
    );
    final oneTwentyTwo = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: (18 * 60) + 22),
      policySettings,
    );
    final twoFifty = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: (19 * 60) + 50),
      policySettings,
    );

    expect(tenMinutes.otHours, 0);
    expect(eighteenMinutes.otHours, 0.5);
    expect(fortyFourMinutes.otHours, 0.5);
    expect(fortySixMinutes.otHours, 1);
    expect(oneTwentyTwo.otHours, 1.5);
    expect(twoFifty.otHours, 3);
  });

  test('OT policy supports overnight and cross midnight shifts', () {
    final policySettings = settings.copyWith(
      normalWorkSchedule: NormalWorkSchedule.eightToFive,
      otStartMinutes: 18 * 60,
      minimumOtMinutes: 0,
      otRoundingPolicy: OtRoundingPolicy.none,
    );
    final afterScheduleOvernight = calculator.calculateDaily(
      _record(checkIn: 18 * 60, checkOut: 2 * 60),
      policySettings,
    );
    final overnightNormalSchedule = calculator.calculateDaily(
      _record(checkIn: 22 * 60, checkOut: 8 * 60),
      policySettings.copyWith(
        normalWorkSchedule: NormalWorkSchedule.custom,
        customScheduleStartMinutes: 22 * 60,
        customScheduleEndMinutes: 6 * 60,
        otStartMinutes: 7 * 60,
      ),
    );

    expect(afterScheduleOvernight.rawOtHours, 8);
    expect(afterScheduleOvernight.otHours, 8);
    expect(overnightNormalSchedule.normalHours, 8);
    expect(overnightNormalSchedule.graceHours, 1);
    expect(overnightNormalSchedule.rawOtHours, 1);
    expect(overnightNormalSchedule.adjustedOtHours, 1);
    expect(overnightNormalSchedule.otHours, 1);
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

  test('founder v0.9.5 OT-only shift uses salary-derived hourly wage', () {
    final founderSettings = settings.copyWith(
      monthlySalary: 23000,
      workSchedule: WorkSchedule.mondayFriday,
      normalWorkSchedule: NormalWorkSchedule.eightToFive,
      normalDayMultiplier: 0,
      normalOtMultiplier: 1.5,
      nightOtMultiplier: 0,
      mealAllowanceDefault: 0,
      travelAllowanceDefault: 0,
      otherAllowanceDefault: 0,
      socialSecurityDeduction: 0,
      taxDeduction: 0,
    );
    final result = calculator.calculateDaily(
      _record(checkIn: 19 * 60, checkOut: 20 * 60),
      founderSettings,
    );

    expect(founderSettings.derivedDailyWage, 1150);
    expect(founderSettings.hourlyWage, closeTo(127.778, 0.001));
    expect(result.totalWorkHours, 1);
    expect(result.normalHours, 0);
    expect(result.otHours, 1);
    expect(result.baseIncome, 0);
    expect(result.otIncome, closeTo(191.667, 0.001));
    expect(result.dailyIncome, closeTo(191.667, 0.001));
  });

  test('founder v0.9.5 salary-derived wage covers OT regression cases', () {
    final founderSettings = settings.copyWith(
      monthlySalary: 23000,
      workSchedule: WorkSchedule.mondayFriday,
      normalWorkSchedule: NormalWorkSchedule.eightToFive,
      normalDayMultiplier: 0,
      normalOtMultiplier: 1.5,
      nightOtMultiplier: 0,
      mealAllowanceDefault: 0,
      travelAllowanceDefault: 0,
      otherAllowanceDefault: 0,
      socialSecurityDeduction: 0,
      taxDeduction: 0,
    );
    final overnightAfterSchedule = calculator.calculateDaily(
      _record(checkIn: 17 * 60, checkOut: 2 * 60),
      founderSettings,
    );
    final normalWithOt = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 20 * 60),
      founderSettings,
    );
    final fullNormalDay = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60),
      founderSettings,
    );
    final doubleOtMultiplier = calculator.calculateDaily(
      _record(checkIn: 19 * 60, checkOut: 20 * 60),
      founderSettings.copyWith(normalOtMultiplier: 2),
    );

    expect(overnightAfterSchedule.totalWorkHours, 9);
    expect(overnightAfterSchedule.normalHours, 0);
    expect(overnightAfterSchedule.otHours, 9);
    expect(overnightAfterSchedule.otIncome, closeTo(1725, 0.001));
    expect(overnightAfterSchedule.dailyIncome, closeTo(1725, 0.001));

    expect(normalWithOt.normalHours, 9);
    expect(normalWithOt.otHours, 3);
    expect(normalWithOt.baseIncome, closeTo(1150, 0.001));
    expect(normalWithOt.otIncome, closeTo(575, 0.001));
    expect(normalWithOt.dailyIncome, closeTo(1725, 0.001));

    expect(fullNormalDay.normalHours, 9);
    expect(fullNormalDay.otHours, 0);
    expect(fullNormalDay.baseIncome, closeTo(1150, 0.001));
    expect(fullNormalDay.dailyIncome, closeTo(1150, 0.001));

    expect(doubleOtMultiplier.otHours, 1);
    expect(doubleOtMultiplier.otIncome, closeTo(255.556, 0.001));
  });

  test('founder payroll hotfix matrix verifies exact income values', () {
    final founderSettings = settings.copyWith(
      monthlySalary: 23000,
      workSchedule: WorkSchedule.mondayFriday,
      normalWorkSchedule: NormalWorkSchedule.eightToFive,
      normalDayMultiplier: 0,
      normalOtMultiplier: 1.5,
      holidayDayMultiplier: 2,
      holidayOtMultiplier: 3,
      nightOtMultiplier: 0,
      mealAllowanceDefault: 0,
      travelAllowanceDefault: 0,
      otherAllowanceDefault: 0,
      socialSecurityDeduction: 0,
      taxDeduction: 0,
    );
    final nineToSixNormal = calculator.calculateDaily(
      _record(checkIn: 9 * 60, checkOut: 18 * 60),
      founderSettings.copyWith(
        normalWorkSchedule: NormalWorkSchedule.nineToSix,
      ),
    );
    final holidayFullDay = calculator.calculateDaily(
      _record(checkIn: 8 * 60, checkOut: 17 * 60, dayType: DayType.holiday),
      founderSettings,
    );
    final nightShiftWithoutPremium = calculator.calculateDaily(
      _record(checkIn: 22 * 60, checkOut: 6 * 60),
      founderSettings,
    );

    expect(nineToSixNormal.normalHours, 9);
    expect(nineToSixNormal.otHours, 0);
    expect(nineToSixNormal.dailyIncome, closeTo(1150, 0.001));

    expect(holidayFullDay.normalHours, 9);
    expect(holidayFullDay.otHours, 0);
    expect(holidayFullDay.dailyIncome, closeTo(2300, 0.001));

    expect(nightShiftWithoutPremium.totalWorkHours, 8);
    expect(nightShiftWithoutPremium.normalHours, 0);
    expect(nightShiftWithoutPremium.otHours, 8);
    expect(nightShiftWithoutPremium.nightShiftHours, 7);
    expect(nightShiftWithoutPremium.dailyIncome, closeTo(1533.333, 0.001));
  });

  test('founder payroll verification scenarios use configured rules', () {
    final baseSettings = settings.copyWith(
      monthlySalary: 27000,
      workSchedule: WorkSchedule.mondayFriday,
      normalDayMultiplier: 1,
      normalOtMultiplier: 1.5,
      weekendDayMultiplier: 2,
      weekendOtMultiplier: 2.5,
      holidayDayMultiplier: 2,
      holidayOtMultiplier: 3,
      nightOtMultiplier: 1.5,
      mealAllowanceDefault: 0,
      travelAllowanceDefault: 0,
      otherAllowanceDefault: 0,
      socialSecurityDeduction: 0,
      taxDeduction: 0,
    );
    final scenarios = [
      _PayrollScenario(
        name: '09:00-18:00 normal day',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.nineToSix,
        ),
        checkIn: 9 * 60,
        checkOut: 18 * 60,
        normalHours: 9,
        otHours: 0,
        baseIncome: 1350,
        otIncome: 0,
        total: 1350,
      ),
      _PayrollScenario(
        name: '17:00-02:00 keeps one scheduled normal hour',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.nineToSix,
        ),
        checkIn: 17 * 60,
        checkOut: 2 * 60,
        normalHours: 1,
        otHours: 8,
        baseIncome: 150,
        otIncome: 1800,
        total: 1950,
        nightHours: 4,
      ),
      _PayrollScenario(
        name: '19:00-23:00 is all OT',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.nineToSix,
        ),
        checkIn: 19 * 60,
        checkOut: 23 * 60,
        normalHours: 0,
        otHours: 4,
        baseIncome: 0,
        otIncome: 900,
        total: 900,
        nightHours: 1,
      ),
      _PayrollScenario(
        name: '08:00-20:00 on 08:00-17:00 schedule',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
        ),
        checkIn: 8 * 60,
        checkOut: 20 * 60,
        normalHours: 9,
        otHours: 3,
        baseIncome: 1350,
        otIncome: 675,
        total: 2025,
      ),
      _PayrollScenario(
        name: '08:30-17:30 selected schedule',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightThirtyToFiveThirty,
        ),
        checkIn: (8 * 60) + 30,
        checkOut: (17 * 60) + 30,
        normalHours: 9,
        otHours: 0,
        baseIncome: 1350,
        otIncome: 0,
        total: 1350,
      ),
      _PayrollScenario(
        name: '08:30-20:30 selected schedule',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightThirtyToFiveThirty,
        ),
        checkIn: (8 * 60) + 30,
        checkOut: (20 * 60) + 30,
        normalHours: 9,
        otHours: 3,
        baseIncome: 1350,
        otIncome: 675,
        total: 2025,
      ),
      _PayrollScenario(
        name: 'custom 10:00-19:00 full schedule',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.custom,
          customScheduleStartMinutes: 10 * 60,
          customScheduleEndMinutes: 19 * 60,
        ),
        checkIn: 10 * 60,
        checkOut: 19 * 60,
        normalHours: 9,
        otHours: 0,
        baseIncome: 1350,
        otIncome: 0,
        total: 1350,
      ),
      _PayrollScenario(
        name: 'custom 10:00-22:00 with OT',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.custom,
          customScheduleStartMinutes: 10 * 60,
          customScheduleEndMinutes: 19 * 60,
        ),
        checkIn: 10 * 60,
        checkOut: 22 * 60,
        normalHours: 9,
        otHours: 3,
        baseIncome: 1350,
        otIncome: 675,
        total: 2025,
      ),
      _PayrollScenario(
        name: 'before schedule is early work, not OT',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.nineToSix,
        ),
        checkIn: 7 * 60,
        checkOut: 10 * 60,
        normalHours: 1,
        otHours: 0,
        baseIncome: 450,
        otIncome: 0,
        total: 450,
      ),
      _PayrollScenario(
        name: 'inside schedule partial day',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.nineToSix,
        ),
        checkIn: 13 * 60,
        checkOut: 18 * 60,
        normalHours: 5,
        otHours: 0,
        baseIncome: 750,
        otIncome: 0,
        total: 750,
      ),
      _PayrollScenario(
        name: 'overnight all OT with configured night premium',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.nineToSix,
          nightOtMultiplier: 2,
        ),
        checkIn: 22 * 60,
        checkOut: 6 * 60,
        normalHours: 0,
        otHours: 8,
        baseIncome: 0,
        otIncome: 2325,
        total: 2325,
        nightHours: 7,
      ),
      _PayrollScenario(
        name: 'holiday inside schedule',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
        ),
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        dayType: DayType.holiday,
        normalHours: 9,
        otHours: 0,
        baseIncome: 2700,
        otIncome: 0,
        total: 2700,
      ),
      _PayrollScenario(
        name: 'holiday OT after schedule',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
        ),
        checkIn: 8 * 60,
        checkOut: 20 * 60,
        dayType: DayType.holiday,
        normalHours: 9,
        otHours: 3,
        baseIncome: 2700,
        otIncome: 1350,
        total: 4050,
      ),
      _PayrollScenario(
        name: 'weekend inside schedule',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
        ),
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        dayType: DayType.weekend,
        normalHours: 9,
        otHours: 0,
        baseIncome: 2700,
        otIncome: 0,
        total: 2700,
      ),
      _PayrollScenario(
        name: 'weekend OT after schedule',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
        ),
        checkIn: 8 * 60,
        checkOut: 20 * 60,
        dayType: DayType.weekend,
        normalHours: 9,
        otHours: 3,
        baseIncome: 2700,
        otIncome: 1125,
        total: 3825,
      ),
      _PayrollScenario(
        name: 'company policy uses configured multipliers',
        settings: baseSettings.copyWith(
          payrollPolicyType: PayrollPolicyType.company,
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
          normalOtMultiplier: 2,
        ),
        checkIn: 8 * 60,
        checkOut: 19 * 60,
        normalHours: 9,
        otHours: 2,
        baseIncome: 1350,
        otIncome: 600,
        total: 1950,
      ),
      _PayrollScenario(
        name: 'custom policy uses configured multipliers',
        settings: baseSettings.copyWith(
          payrollPolicyType: PayrollPolicyType.custom,
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
          normalDayMultiplier: 1.2,
          normalOtMultiplier: 1.8,
        ),
        checkIn: 8 * 60,
        checkOut: 19 * 60,
        normalHours: 9,
        otHours: 2,
        baseIncome: 1620,
        otIncome: 540,
        total: 2160,
      ),
      _PayrollScenario(
        name: 'extra OT is added from record setting',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
        ),
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        extraOtHours: 2,
        normalHours: 9,
        otHours: 2,
        baseIncome: 1350,
        otIncome: 450,
        total: 1800,
      ),
      _PayrollScenario(
        name: 'allowances add to total without changing hours',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
          mealAllowanceDefault: 50,
          travelAllowanceDefault: 25,
          otherAllowanceDefault: 25,
        ),
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        travelAllowance: 40,
        specialAllowance: 60,
        normalHours: 9,
        otHours: 0,
        baseIncome: 1350,
        otIncome: 0,
        allowanceIncome: 200,
        total: 1550,
      ),
      _PayrollScenario(
        name: 'monthly salary and working days drive hourly wage',
        settings: baseSettings.copyWith(
          monthlySalary: 24000,
          workSchedule: WorkSchedule.mondaySaturday,
          normalWorkSchedule: NormalWorkSchedule.eightToFive,
        ),
        checkIn: 8 * 60,
        checkOut: 20 * 60,
        normalHours: 9,
        otHours: 3,
        hourlyWage: 111.111111,
        baseIncome: 1000,
        otIncome: 500,
        total: 1500,
      ),
      _PayrollScenario(
        name: 'overnight custom schedule normal and OT split',
        settings: baseSettings.copyWith(
          normalWorkSchedule: NormalWorkSchedule.custom,
          customScheduleStartMinutes: 22 * 60,
          customScheduleEndMinutes: 6 * 60,
          nightOtMultiplier: 2,
        ),
        checkIn: 22 * 60,
        checkOut: 8 * 60,
        normalHours: 8,
        otHours: 2,
        hourlyWage: 168.75,
        baseIncome: 2531.25,
        otIncome: 506.25,
        total: 3037.5,
        nightHours: 7,
      ),
    ];

    for (final scenario in scenarios) {
      final result = calculator.calculateDaily(
        _record(
          checkIn: scenario.checkIn,
          checkOut: scenario.checkOut,
          dayType: scenario.dayType,
          extraOtHours: scenario.extraOtHours,
          travelAllowance: scenario.travelAllowance,
          specialAllowance: scenario.specialAllowance,
        ),
        scenario.settings,
      );

      expect(
        scenario.settings.hourlyWage,
        closeTo(scenario.hourlyWage ?? 150, 0.001),
        reason: '${scenario.name} hourly wage',
      );
      expect(
        result.normalHours,
        closeTo(scenario.normalHours, 0.001),
        reason: '${scenario.name} normal hours',
      );
      expect(
        result.otHours,
        closeTo(scenario.otHours, 0.001),
        reason: '${scenario.name} OT hours',
      );
      expect(
        result.nightShiftHours,
        closeTo(scenario.nightHours, 0.001),
        reason: '${scenario.name} night hours',
      );
      expect(
        result.baseIncome,
        closeTo(scenario.baseIncome, 0.001),
        reason: '${scenario.name} normal income',
      );
      expect(
        result.otIncome,
        closeTo(scenario.otIncome, 0.001),
        reason: '${scenario.name} OT income',
      );
      expect(
        result.allowanceIncome,
        closeTo(scenario.allowanceIncome, 0.001),
        reason: '${scenario.name} allowance income',
      );
      expect(
        result.dailyIncome,
        closeTo(scenario.total, 0.001),
        reason: '${scenario.name} total',
      );
    }
  });
}

class _PayrollScenario {
  const _PayrollScenario({
    required this.name,
    required this.settings,
    required this.checkIn,
    required this.checkOut,
    required this.normalHours,
    required this.otHours,
    required this.baseIncome,
    required this.otIncome,
    required this.total,
    this.dayType = DayType.normal,
    this.extraOtHours = 0,
    this.travelAllowance = 0,
    this.specialAllowance = 0,
    this.nightHours = 0,
    this.allowanceIncome = 0,
    this.hourlyWage,
  });

  final String name;
  final WorkSettings settings;
  final int checkIn;
  final int checkOut;
  final DayType dayType;
  final double extraOtHours;
  final double travelAllowance;
  final double specialAllowance;
  final double normalHours;
  final double otHours;
  final double nightHours;
  final double baseIncome;
  final double otIncome;
  final double allowanceIncome;
  final double total;
  final double? hourlyWage;
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
