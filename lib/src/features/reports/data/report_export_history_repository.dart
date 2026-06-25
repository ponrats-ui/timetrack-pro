import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../domain/report_export.dart';

final reportExportHistoryRepositoryProvider =
    Provider<ReportExportHistoryRepository>((ref) {
      return ReportExportHistoryRepository(ref.watch(appDatabaseProvider));
    });

final reportExportHistoryProvider =
    StreamProvider<List<ReportExportHistoryEntity>>((ref) {
      return ref.watch(reportExportHistoryRepositoryProvider).watchHistory();
    });

class ReportExportHistoryRepository {
  const ReportExportHistoryRepository(this._database);

  final AppDatabase _database;

  Stream<List<ReportExportHistoryEntity>> watchHistory() {
    final query = _database.select(_database.reportExportHistories)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.exportedAt, mode: OrderingMode.desc),
      ]);

    return query.watch().map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> addHistory({
    required ReportExportFormat format,
    required String fileName,
    DateTime? exportedAt,
  }) {
    final now = exportedAt ?? DateTime.now();
    return _database
        .into(_database.reportExportHistories)
        .insert(
          ReportExportHistoriesCompanion.insert(
            id: '${now.microsecondsSinceEpoch}-${format.extension}',
            format: format.extension,
            exportedAt: now,
            fileName: fileName,
          ),
        );
  }

  ReportExportHistoryEntity _fromRow(ReportExportHistory row) {
    return ReportExportHistoryEntity(
      id: row.id,
      format: ReportExportFormat.fromValue(row.format),
      exportedAt: row.exportedAt,
      fileName: row.fileName,
    );
  }
}
