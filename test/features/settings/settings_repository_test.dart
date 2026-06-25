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
      otRate1: 1,
      otRate15: 1.5,
      otRate2: 2,
      otRate3: 3,
      travelAllowanceDefault: 80,
      socialSecurityDeduction: 750,
      taxDeduction: 250,
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
    expect(actual.travelAllowanceDefault, expected.travelAllowanceDefault);
    expect(actual.socialSecurityDeduction, expected.socialSecurityDeduction);
    expect(actual.taxDeduction, expected.taxDeduction);
    expect(actual.companyName, expected.companyName);
    expect(actual.employeeName, expected.employeeName);
    expect(actual.employeeId, expected.employeeId);
  });
}
