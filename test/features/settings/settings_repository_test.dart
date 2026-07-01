import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:timetrack_pro/src/core/database/app_database.dart';
import 'package:timetrack_pro/src/features/settings/data/settings_repository.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';

void main() {
  test('settings value equality treats saved break values as stable', () {
    final first = const WorkSettings.defaults().copyWith(
      defaultBreakMinutes: 0,
    );
    final second = const WorkSettings.defaults().copyWith(
      defaultBreakMinutes: 0,
    );
    final different = const WorkSettings.defaults().copyWith(
      defaultBreakMinutes: 60,
    );

    expect(first, second);
    expect(first, isNot(different));
  });

  test('default settings do not auto deduct break time', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);

    final actual = await repository.watchSettings().first;

    expect(actual.defaultBreakMinutes, 0);
    expect(actual.normalWorkHours, 0);
    expect(actual.nightOtMultiplier, 0);
  });

  test('persists break minutes when saved as zero', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);

    await repository.saveSettings(
      const WorkSettings.defaults().copyWith(defaultBreakMinutes: 0),
    );
    final actual = await repository.watchSettings().first;

    expect(actual.defaultBreakMinutes, 0);
  });

  test('persists break minutes when saved as thirty', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);

    await repository.saveSettings(
      const WorkSettings.defaults().copyWith(defaultBreakMinutes: 30),
    );
    final actual = await repository.watchSettings().first;

    expect(actual.defaultBreakMinutes, 30);
  });

  test('persists break minutes when saved as sixty', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);

    await repository.saveSettings(
      const WorkSettings.defaults().copyWith(defaultBreakMinutes: 60),
    );
    final actual = await repository.watchSettings().first;

    expect(actual.defaultBreakMinutes, 60);
  });

  test('persists and loads all settings fields', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);

    final expected = const WorkSettings.defaults().copyWith(
      monthlySalary: 22000,
      dailyWage: 700,
      workSchedule: WorkSchedule.mondaySaturday,
      normalWorkSchedule: NormalWorkSchedule.eightThirtyToFiveThirty,
      defaultBreakMinutes: 45,
      normalDayMultiplier: 1.1,
      weekendDayMultiplier: 2.5,
      holidayDayMultiplier: 3.2,
      normalOtMultiplier: 1.75,
      weekendOtMultiplier: 2.75,
      holidayOtMultiplier: 3.5,
      nightOtMultiplier: 2.25,
      mealAllowanceDefault: 60,
      travelAllowanceDefault: 80,
      otherAllowanceDefault: 40,
      socialSecurityDeduction: 750,
      taxDeduction: 250,
      nightShiftStartMinutes: 21 * 60,
      nightShiftEndMinutes: 6 * 60,
      companyName: 'ACME Logistics',
      employeeName: 'Somchai Driver',
      employeeId: 'EMP-007',
      onboardingCompleted: true,
    );

    await repository.saveSettings(expected);
    final actual = await repository.watchSettings().first;

    expect(actual.monthlySalary, expected.monthlySalary);
    expect(actual.workSchedule, WorkSchedule.mondaySaturday);
    expect(
      actual.normalWorkSchedule,
      NormalWorkSchedule.eightThirtyToFiveThirty,
    );
    expect(actual.dailyWage, expected.derivedDailyWage);
    expect(actual.derivedDailyWage, expected.derivedDailyWage);
    expect(actual.normalWorkHours, expected.normalWorkHours);
    expect(actual.defaultBreakMinutes, expected.defaultBreakMinutes);
    expect(actual.normalDayMultiplier, expected.normalDayMultiplier);
    expect(actual.weekendDayMultiplier, expected.weekendDayMultiplier);
    expect(actual.holidayDayMultiplier, expected.holidayDayMultiplier);
    expect(actual.normalOtMultiplier, expected.normalOtMultiplier);
    expect(actual.weekendOtMultiplier, expected.weekendOtMultiplier);
    expect(actual.holidayOtMultiplier, expected.holidayOtMultiplier);
    expect(actual.nightOtMultiplier, expected.nightOtMultiplier);
    expect(actual.mealAllowanceDefault, expected.mealAllowanceDefault);
    expect(actual.travelAllowanceDefault, expected.travelAllowanceDefault);
    expect(actual.otherAllowanceDefault, expected.otherAllowanceDefault);
    expect(actual.socialSecurityDeduction, expected.socialSecurityDeduction);
    expect(actual.taxDeduction, expected.taxDeduction);
    expect(actual.nightShiftStartMinutes, expected.nightShiftStartMinutes);
    expect(actual.nightShiftEndMinutes, expected.nightShiftEndMinutes);
    expect(actual.companyName, expected.companyName);
    expect(actual.employeeName, expected.employeeName);
    expect(actual.employeeId, expected.employeeId);
    expect(actual.onboardingCompleted, isTrue);
  });

  test('persists schedule and reloads derived daily wage', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);

    await repository.saveSettings(
      const WorkSettings.defaults().copyWith(
        monthlySalary: 21000,
        workSchedule: WorkSchedule.mondayFriday,
      ),
    );
    final monFri = await repository.watchSettings().first;

    await repository.saveSettings(
      monFri.copyWith(workSchedule: WorkSchedule.mondaySaturday),
    );
    final monSat = await repository.watchSettings().first;

    expect(monFri.dailyWage, 1050);
    expect(monFri.hourlyWage, closeTo(116.667, 0.001));
    expect(monSat.dailyWage, 875);
    expect(monSat.workSchedule, WorkSchedule.mondaySaturday);
  });

  test('persists selectable working days and custom work schedule', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);

    await repository.saveSettings(
      const WorkSettings.defaults().copyWith(
        monthlySalary: 30000,
        workSchedule: WorkSchedule.days30,
        normalWorkSchedule: NormalWorkSchedule.custom,
        customScheduleStartMinutes: 22 * 60,
        customScheduleEndMinutes: 6 * 60,
        payrollPolicyType: PayrollPolicyType.custom,
      ),
    );
    final actual = await repository.watchSettings().first;

    expect(actual.workSchedule, WorkSchedule.days30);
    expect(actual.derivedDailyWage, 1000);
    expect(actual.normalWorkSchedule, NormalWorkSchedule.custom);
    expect(actual.customScheduleStartMinutes, 22 * 60);
    expect(actual.customScheduleEndMinutes, 6 * 60);
    expect(actual.effectiveNormalWorkHours, 8);
    expect(actual.payrollPolicyType, PayrollPolicyType.custom);
  });
}
