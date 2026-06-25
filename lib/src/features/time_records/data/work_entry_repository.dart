import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';

final workEntryRepositoryProvider = Provider<WorkEntryRepository>((ref) {
  return WorkEntryRepository(ref.watch(appDatabaseProvider));
});

final workEntriesProvider = StreamProvider<List<WorkEntry>>((ref) {
  return ref.watch(workEntryRepositoryProvider).watchEntries();
});

class WorkEntryRepository {
  const WorkEntryRepository(this._database);

  final AppDatabase _database;

  Stream<List<WorkEntry>> watchEntries() {
    final query = _database.select(_database.workEntries)
      ..orderBy([
        (entry) =>
            OrderingTerm(expression: entry.workDate, mode: OrderingMode.desc),
      ]);

    return query.watch();
  }

  Future<void> upsertEntry(WorkEntriesCompanion entry) {
    return _database.into(_database.workEntries).insertOnConflictUpdate(entry);
  }

  Future<int> deleteEntry(String id) {
    return (_database.delete(
      _database.workEntries,
    )..where((entry) => entry.id.equals(id))).go();
  }
}
