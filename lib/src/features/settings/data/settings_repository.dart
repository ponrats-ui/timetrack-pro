import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../domain/work_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
});

final workSettingsProvider = StreamProvider<WorkSettings>((ref) {
  return ref.watch(settingsRepositoryProvider).watchSettings();
});

class SettingsRepository {
  const SettingsRepository(this._database);

  final AppDatabase _database;

  Stream<WorkSettings> watchSettings() {
    return _database.select(_database.appSettings).watchSingleOrNull().asyncMap(
      (row) async {
        if (row != null) {
          return _fromRow(row);
        }

        final defaults = const WorkSettings.defaults();
        await saveSettings(defaults);
        return defaults;
      },
    );
  }

  Future<void> saveSettings(WorkSettings settings) {
    return _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            id: const Value('default'),
            monthlySalary: Value(settings.monthlySalary),
            dailyWage: Value(settings.derivedDailyWage),
            workSchedule: Value(settings.workSchedule.value),
            normalWorkSchedule: Value(settings.normalWorkSchedule.value),
            customScheduleStartMinutes: Value(
              settings.customScheduleStartMinutes,
            ),
            customScheduleEndMinutes: Value(settings.customScheduleEndMinutes),
            payrollPolicyType: Value(settings.payrollPolicyType.value),
            normalWorkHours: Value(settings.normalWorkHours),
            otRate1: Value((settings.otStartMinutes ?? -1).toDouble()),
            otRate15: Value(settings.minimumOtMinutes.toDouble()),
            otRate2: Value(settings.otRoundingPolicy.storageCode.toDouble()),
            otRate3: const Value(_payrollPolicyStorageVersion),
            normalDayMultiplier: Value(settings.normalDayMultiplier),
            weekendDayMultiplier: Value(settings.weekendDayMultiplier),
            holidayDayMultiplier: Value(settings.holidayDayMultiplier),
            normalOtMultiplier: Value(settings.normalOtMultiplier),
            weekendOtMultiplier: Value(settings.weekendOtMultiplier),
            holidayOtMultiplier: Value(settings.holidayOtMultiplier),
            nightOtMultiplier: Value(settings.nightOtMultiplier),
            mealAllowanceDefault: Value(settings.mealAllowanceDefault),
            travelAllowanceDefault: Value(settings.travelAllowanceDefault),
            otherAllowanceDefault: Value(settings.otherAllowanceDefault),
            socialSecurityDeduction: Value(settings.socialSecurityDeduction),
            taxDeduction: Value(settings.taxDeduction),
            nightShiftStartMinutes: Value(settings.nightShiftStartMinutes),
            nightShiftEndMinutes: Value(settings.nightShiftEndMinutes),
            defaultBreakMinutes: Value(settings.defaultBreakMinutes),
            companyName: Value(settings.companyName),
            employeeName: Value(settings.employeeName),
            employeeId: Value(settings.employeeId),
            themeMode: Value(settings.themePreference.value),
            onboardingCompleted: Value(settings.onboardingCompleted),
            updatedAt: DateTime.now(),
          ),
        );
  }

  WorkSettings _fromRow(AppSetting row) {
    final hasPolicySettings = row.otRate3 == _payrollPolicyStorageVersion;
    return WorkSettings(
      monthlySalary: row.monthlySalary,
      dailyWage: row.dailyWage,
      workSchedule: WorkSchedule.fromValue(row.workSchedule),
      normalWorkSchedule: NormalWorkSchedule.fromValue(row.normalWorkSchedule),
      customScheduleStartMinutes: row.customScheduleStartMinutes,
      customScheduleEndMinutes: row.customScheduleEndMinutes,
      payrollPolicyType: PayrollPolicyType.fromValue(row.payrollPolicyType),
      normalWorkHours: row.normalWorkHours,
      normalDayMultiplier: row.normalDayMultiplier,
      weekendDayMultiplier: row.weekendDayMultiplier,
      holidayDayMultiplier: row.holidayDayMultiplier,
      normalOtMultiplier: row.normalOtMultiplier,
      weekendOtMultiplier: row.weekendOtMultiplier,
      holidayOtMultiplier: row.holidayOtMultiplier,
      nightOtMultiplier: row.nightOtMultiplier,
      mealAllowanceDefault: row.mealAllowanceDefault,
      travelAllowanceDefault: row.travelAllowanceDefault,
      otherAllowanceDefault: row.otherAllowanceDefault,
      socialSecurityDeduction: row.socialSecurityDeduction,
      taxDeduction: row.taxDeduction,
      nightShiftStartMinutes: row.nightShiftStartMinutes,
      nightShiftEndMinutes: row.nightShiftEndMinutes,
      otStartMinutes: hasPolicySettings && row.otRate1 >= 0
          ? row.otRate1.round()
          : null,
      minimumOtMinutes: hasPolicySettings ? row.otRate15.round() : 0,
      otRoundingPolicy: hasPolicySettings
          ? OtRoundingPolicy.fromStorageCode(row.otRate2.round())
          : OtRoundingPolicy.companyHalfHour,
      defaultBreakMinutes: row.defaultBreakMinutes,
      companyName: row.companyName,
      employeeName: row.employeeName,
      employeeId: row.employeeId,
      themePreference: AppThemePreference.fromValue(row.themeMode),
      onboardingCompleted: row.onboardingCompleted,
    );
  }
}

const _payrollPolicyStorageVersion = 4004.0;
