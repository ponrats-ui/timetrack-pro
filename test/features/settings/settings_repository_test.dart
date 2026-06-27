import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:timetrack_pro/src/core/database/app_database.dart';
import 'package:timetrack_pro/src/features/settings/data/settings_repository.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';

void main() {
  test('persists and loads all settings fields', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = SettingsRepository(database);

    final expected = const WorkSettings.defaults().copyWith(
      monthlySalary: 22000,
      dailyWage: 700,
      normalWorkHours: 8.5,
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
    );

    await repository.saveSettings(expected);
    final actual = await repository.watchSettings().first;

    expect(actual.monthlySalary, expected.monthlySalary);
    expect(actual.dailyWage, expected.dailyWage);
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
  });
}
