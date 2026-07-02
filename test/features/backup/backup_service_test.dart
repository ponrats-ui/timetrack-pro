import 'dart:convert';

import 'package:test/test.dart';
import 'package:timetrack_pro/src/features/backup/application/backup_service.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  const service = BackupService();

  test('export JSON contains production backup metadata', () {
    final file = service.exportJson(
      records: [_record()],
      settings: const WorkSettings.defaults().copyWith(
        employeeName: 'Founder',
        companyName: 'Business OS',
      ),
      exportedAt: DateTime(2026, 7, 2, 9),
    );
    final payload = jsonDecode(utf8.decode(file.bytes)) as Map<String, Object?>;

    expect(payload['format'], 'timetrack_pro_backup');
    expect(payload['formatVersion'], 1);
    expect(payload['appVersion'], '0.9.6+4');
    expect(payload['databaseVersion'], 13);
    expect(payload['settings'], isA<Map>());
    expect(payload['workRecords'], isA<List>());
  });

  test('preview JSON restores settings and records', () {
    final sourceSettings = const WorkSettings.defaults().copyWith(
      monthlySalary: 23000,
      employeeName: 'Founder',
      companyName: 'Business OS',
      onboardingCompleted: true,
    );
    final file = service.exportJson(
      records: [_record()],
      settings: sourceSettings,
      exportedAt: DateTime(2026, 7, 2, 9),
    );

    final preview = service.previewJson(utf8.decode(file.bytes));

    expect(preview.appVersion, '0.9.6+4');
    expect(preview.recordCount, 1);
    expect(preview.employeeName, 'Founder');
    expect(preview.companyName, 'Business OS');
    expect(preview.settings.monthlySalary, 23000);
    expect(preview.records.single.checkInMinutes, 8 * 60);
  });

  test('rejects invalid backup JSON', () {
    expect(
      () => service.previewJson('{"format":"wrong"}'),
      throwsA(isA<BackupException>()),
    );
  });
}

WorkRecordEntity _record() {
  final now = DateTime(2026, 7, 2, 9);
  return WorkRecordEntity(
    id: 'record-1',
    workDate: DateTime(2026, 7, 2),
    checkInMinutes: 8 * 60,
    checkOutMinutes: 17 * 60,
    breakMinutes: 0,
    dayType: DayType.normal,
    extraOtHours: 0,
    travelAllowance: 0,
    specialAllowance: 0,
    expense: 0,
    note: '',
    createdAt: now,
    updatedAt: now,
  );
}
