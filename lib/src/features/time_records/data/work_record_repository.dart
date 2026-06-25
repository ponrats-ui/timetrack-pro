import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../domain/work_record.dart';

final workRecordRepositoryProvider = Provider<WorkRecordRepository>((ref) {
  return WorkRecordRepository(ref.watch(appDatabaseProvider));
});

final workRecordsProvider = StreamProvider<List<WorkRecordEntity>>((ref) {
  return ref.watch(workRecordRepositoryProvider).watchRecords();
});

class WorkRecordRepository {
  const WorkRecordRepository(this._database);

  final AppDatabase _database;

  Stream<List<WorkRecordEntity>> watchRecords() {
    final query = _database.select(_database.workRecords)
      ..orderBy([
        (record) =>
            OrderingTerm(expression: record.workDate, mode: OrderingMode.desc),
        (record) =>
            OrderingTerm(expression: record.createdAt, mode: OrderingMode.desc),
      ]);

    return query.watch().map((records) => records.map(_fromRow).toList());
  }

  Future<void> saveRecord(WorkRecordEntity record) {
    return _database
        .into(_database.workRecords)
        .insertOnConflictUpdate(_toCompanion(record));
  }

  Future<int> deleteRecord(String id) {
    return (_database.delete(
      _database.workRecords,
    )..where((record) => record.id.equals(id))).go();
  }

  WorkRecordEntity _fromRow(WorkRecord row) {
    return WorkRecordEntity(
      id: row.id,
      workDate: row.workDate,
      checkInMinutes: row.checkInMinutes,
      checkOutMinutes: row.checkOutMinutes,
      breakMinutes: row.breakMinutes,
      dayType: DayType.fromValue(row.dayType),
      extraOtHours: row.extraOtHours,
      travelAllowance: row.travelAllowance,
      specialAllowance: row.specialAllowance,
      expense: row.expense,
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  WorkRecordsCompanion _toCompanion(WorkRecordEntity record) {
    return WorkRecordsCompanion.insert(
      id: record.id,
      workDate: record.workDate,
      checkInMinutes: record.checkInMinutes,
      checkOutMinutes: record.checkOutMinutes,
      breakMinutes: Value(record.breakMinutes),
      dayType: Value(record.dayType.value),
      extraOtHours: Value(record.extraOtHours),
      travelAllowance: Value(record.travelAllowance),
      specialAllowance: Value(record.specialAllowance),
      expense: Value(record.expense),
      note: Value(record.note),
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }
}
