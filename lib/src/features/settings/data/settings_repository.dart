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
            dailyWage: Value(settings.dailyWage),
            normalWorkHours: Value(settings.normalWorkHours),
            otRate1: Value(settings.otRate1),
            otRate15: Value(settings.otRate15),
            otRate2: Value(settings.otRate2),
            otRate3: Value(settings.otRate3),
            travelAllowanceDefault: Value(settings.travelAllowanceDefault),
            socialSecurityDeduction: Value(settings.socialSecurityDeduction),
            taxDeduction: Value(settings.taxDeduction),
            defaultBreakMinutes: Value(settings.defaultBreakMinutes),
            companyName: Value(settings.companyName),
            employeeName: Value(settings.employeeName),
            employeeId: Value(settings.employeeId),
            updatedAt: DateTime.now(),
          ),
        );
  }

  WorkSettings _fromRow(AppSetting row) {
    return WorkSettings(
      monthlySalary: row.monthlySalary,
      dailyWage: row.dailyWage,
      normalWorkHours: row.normalWorkHours,
      otRate1: row.otRate1,
      otRate15: row.otRate15,
      otRate2: row.otRate2,
      otRate3: row.otRate3,
      travelAllowanceDefault: row.travelAllowanceDefault,
      socialSecurityDeduction: row.socialSecurityDeduction,
      taxDeduction: row.taxDeduction,
      defaultBreakMinutes: row.defaultBreakMinutes,
      companyName: row.companyName,
      employeeName: row.employeeName,
      employeeId: row.employeeId,
    );
  }
}
