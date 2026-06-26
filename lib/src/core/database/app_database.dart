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
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get id => text().withDefault(const Constant('default'))();
  RealColumn get monthlySalary => real().withDefault(const Constant(15000))();
  RealColumn get dailyWage => real().withDefault(const Constant(500))();
  RealColumn get normalWorkHours => real().withDefault(const Constant(8))();
  RealColumn get otRate1 => real().withDefault(const Constant(1))();
  RealColumn get otRate15 => real().withDefault(const Constant(1.5))();
  RealColumn get otRate2 => real().withDefault(const Constant(2))();
  RealColumn get otRate3 => real().withDefault(const Constant(3))();
  RealColumn get travelAllowanceDefault =>
      real().withDefault(const Constant(0))();
  RealColumn get socialSecurityDeduction =>
      real().withDefault(const Constant(750))();
  RealColumn get taxDeduction => real().withDefault(const Constant(0))();
  IntColumn get defaultBreakMinutes =>
      integer().withDefault(const Constant(60))();
  TextColumn get companyName => text().withDefault(const Constant(''))();
  TextColumn get employeeName => text().withDefault(const Constant(''))();
  TextColumn get employeeId => text().withDefault(const Constant(''))();
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
  int get schemaVersion => 4;

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
