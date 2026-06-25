import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../constants/app_constants.dart';

part 'app_database.g.dart';

class WorkEntries extends Table {
  TextColumn get id => text()();
  DateTimeColumn get workDate => dateTime()();
  IntColumn get checkInMinutes => integer()();
  IntColumn get checkOutMinutes => integer()();
  RealColumn get otExtraHours => real().withDefault(const Constant(0))();
  RealColumn get specialAllowance => real().withDefault(const Constant(0))();
  RealColumn get expense => real().withDefault(const Constant(0))();
  TextColumn get dayType => text().withDefault(const Constant('normal'))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [WorkEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: AppConstants.databaseName,
      native: const DriftNativeOptions(shareAcrossIsolates: true),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
