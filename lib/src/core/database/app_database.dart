import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../constants/app_constants.dart';

part 'app_database.g.dart';

class WorkRecords extends Table {
  TextColumn get id => text()();
  DateTimeColumn get workDate => dateTime()();
  IntColumn get checkInMinutes => integer()();
  IntColumn get checkOutMinutes => integer()();
  IntColumn get breakMinutes => integer().withDefault(const Constant(0))();
  TextColumn get dayType => text().withDefault(const Constant('normal'))();
  RealColumn get extraOtHours => real().withDefault(const Constant(0))();
  RealColumn get travelAllowance => real().withDefault(const Constant(0))();
  RealColumn get specialAllowance => real().withDefault(const Constant(0))();
  RealColumn get expense => real().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();
  DateTimeColumn get importedAt => dateTime().nullable()();
  TextColumn get sourceEmployeeName => text().nullable()();
  TextColumn get sourceEmployeeId => text().nullable()();
  TextColumn get sourceFileName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get id => text().withDefault(const Constant('default'))();
  RealColumn get monthlySalary => real().withDefault(const Constant(15000))();
  RealColumn get dailyWage => real().withDefault(const Constant(750))();
  TextColumn get workSchedule =>
      text().withDefault(const Constant('monday_friday'))();
  TextColumn get normalWorkSchedule =>
      text().withDefault(const Constant('08_17'))();
  IntColumn get customScheduleStartMinutes =>
      integer().withDefault(const Constant(480))();
  IntColumn get customScheduleEndMinutes =>
      integer().withDefault(const Constant(1020))();
  TextColumn get payrollPolicyType =>
      text().withDefault(const Constant('thai_labour'))();
  RealColumn get normalWorkHours => real().withDefault(const Constant(9))();
  RealColumn get otRate1 => real().withDefault(const Constant(1))();
  RealColumn get otRate15 => real().withDefault(const Constant(1.5))();
  RealColumn get otRate2 => real().withDefault(const Constant(2))();
  RealColumn get otRate3 => real().withDefault(const Constant(3))();
  RealColumn get normalDayMultiplier => real().withDefault(const Constant(1))();
  RealColumn get weekendDayMultiplier =>
      real().withDefault(const Constant(3))();
  RealColumn get holidayDayMultiplier =>
      real().withDefault(const Constant(3))();
  RealColumn get normalOtMultiplier =>
      real().withDefault(const Constant(1.5))();
  RealColumn get weekendOtMultiplier => real().withDefault(const Constant(3))();
  RealColumn get holidayOtMultiplier => real().withDefault(const Constant(3))();
  RealColumn get nightOtMultiplier => real().withDefault(const Constant(2))();
  RealColumn get mealAllowanceDefault =>
      real().withDefault(const Constant(0))();
  RealColumn get travelAllowanceDefault =>
      real().withDefault(const Constant(0))();
  RealColumn get otherAllowanceDefault =>
      real().withDefault(const Constant(0))();
  RealColumn get socialSecurityDeduction =>
      real().withDefault(const Constant(750))();
  RealColumn get taxDeduction => real().withDefault(const Constant(0))();
  IntColumn get nightShiftStartMinutes =>
      integer().withDefault(const Constant(1320))();
  IntColumn get nightShiftEndMinutes =>
      integer().withDefault(const Constant(300))();
  IntColumn get defaultBreakMinutes =>
      integer().withDefault(const Constant(0))();
  TextColumn get companyName => text().withDefault(const Constant(''))();
  TextColumn get employeeName => text().withDefault(const Constant(''))();
  TextColumn get employeeId => text().withDefault(const Constant(''))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReportExportHistories extends Table {
  TextColumn get id => text()();
  TextColumn get format => text()();
  DateTimeColumn get exportedAt => dateTime()();
  TextColumn get fileName => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [WorkRecords, AppSettings, ReportExportHistories])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _seedDefaultSettings();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(workRecords);
        await migrator.createTable(appSettings);
        await _seedDefaultSettings();
      }
      if (from < 3) {
        await migrator.addColumn(
          appSettings,
          appSettings.travelAllowanceDefault,
        );
        await migrator.addColumn(appSettings, appSettings.taxDeduction);
        await migrator.addColumn(appSettings, appSettings.companyName);
        await migrator.addColumn(appSettings, appSettings.employeeName);
        await migrator.addColumn(appSettings, appSettings.employeeId);
      }
      if (from < 4) {
        await migrator.createTable(reportExportHistories);
      }
      if (from < 5) {
        await migrator.addColumn(appSettings, appSettings.themeMode);
      }
      if (from < 6) {
        await migrator.addColumn(appSettings, appSettings.normalDayMultiplier);
        await migrator.addColumn(appSettings, appSettings.weekendDayMultiplier);
        await migrator.addColumn(appSettings, appSettings.holidayDayMultiplier);
        await migrator.addColumn(appSettings, appSettings.normalOtMultiplier);
        await migrator.addColumn(appSettings, appSettings.weekendOtMultiplier);
        await migrator.addColumn(appSettings, appSettings.holidayOtMultiplier);
        await migrator.addColumn(appSettings, appSettings.nightOtMultiplier);
        await migrator.addColumn(appSettings, appSettings.mealAllowanceDefault);
        await migrator.addColumn(
          appSettings,
          appSettings.otherAllowanceDefault,
        );
        await migrator.addColumn(
          appSettings,
          appSettings.nightShiftStartMinutes,
        );
        await migrator.addColumn(appSettings, appSettings.nightShiftEndMinutes);
        await customStatement('''
          UPDATE app_settings
          SET normal_day_multiplier = ot_rate1,
              normal_ot_multiplier = ot_rate15,
              weekend_ot_multiplier = ot_rate2,
              holiday_ot_multiplier = ot_rate3
        ''');
      }
      if (from < 7) {
        await migrator.addColumn(workRecords, workRecords.isDemo);
        await migrator.addColumn(appSettings, appSettings.onboardingCompleted);
        await customStatement('''
          UPDATE app_settings
          SET onboarding_completed = 1
        ''');
      }
      if (from < 8) {
        await customStatement('''
          UPDATE app_settings
          SET default_break_minutes = 0
          WHERE default_break_minutes = 60
        ''');
      }
      if (from < 9) {
        await customStatement('''
          UPDATE work_records
          SET break_minutes = 0
          WHERE break_minutes = 60
        ''');
      }
      if (from < 10) {
        await migrator.addColumn(appSettings, appSettings.workSchedule);
        await customStatement('''
          UPDATE app_settings
          SET daily_wage = monthly_salary / 20.0
          WHERE work_schedule = 'monday_friday'
        ''');
      }
      if (from < 11) {
        await migrator.addColumn(appSettings, appSettings.normalWorkSchedule);
        await customStatement('''
          UPDATE app_settings
          SET normal_work_hours = 9.0
        ''');
      }
      if (from < 12) {
        await migrator.addColumn(
          appSettings,
          appSettings.customScheduleStartMinutes,
        );
        await migrator.addColumn(
          appSettings,
          appSettings.customScheduleEndMinutes,
        );
        await migrator.addColumn(appSettings, appSettings.payrollPolicyType);
      }
      if (from < 13) {
        await migrator.addColumn(workRecords, workRecords.importedAt);
        await migrator.addColumn(workRecords, workRecords.sourceEmployeeName);
        await migrator.addColumn(workRecords, workRecords.sourceEmployeeId);
        await migrator.addColumn(workRecords, workRecords.sourceFileName);
      }
    },
  );

  Future<void> _seedDefaultSettings() async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(updatedAt: DateTime.now()),
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: AppConstants.databaseName,
      native: const DriftNativeOptions(shareAcrossIsolates: true),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }
}
