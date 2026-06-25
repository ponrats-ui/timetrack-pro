import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:timetrack_pro/src/core/database/app_database.dart';
import 'package:timetrack_pro/src/features/reports/data/report_export_history_repository.dart';
import 'package:timetrack_pro/src/features/reports/domain/report_export.dart';

void main() {
  test('saves export history with format, date, and file name', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ReportExportHistoryRepository(database);
    final exportedAt = DateTime(2026, 6, 25, 9, 30);

    await repository.addHistory(
      format: ReportExportFormat.pdf,
      fileName: 'timetrack_hr_report_2026_06.pdf',
      exportedAt: exportedAt,
    );

    final history = await repository.watchHistory().first;

    expect(history, hasLength(1));
    expect(history.first.format, ReportExportFormat.pdf);
    expect(history.first.exportedAt, exportedAt);
    expect(history.first.fileName, 'timetrack_hr_report_2026_06.pdf');
  });
}
