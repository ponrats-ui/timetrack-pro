import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:timetrack_pro/src/features/hr_import/application/employee_data_transfer_service.dart';
import 'package:timetrack_pro/src/features/reports/domain/report_export.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  const service = EmployeeDataTransferService();
  final settings = const WorkSettings.defaults().copyWith(
    companyName: 'ACME',
    employeeName: 'Somchai',
    employeeId: 'EMP-001',
    monthlySalary: 21000,
  );
  final records = [
    _record(date: DateTime(2026, 6, 1), checkIn: 8 * 60, checkOut: 17 * 60),
    _record(date: DateTime(2026, 6, 2), checkIn: 8 * 60, checkOut: 20 * 60),
  ];

  test('export JSON contains required metadata', () {
    final file = service.exportJson(
      records: records,
      settings: settings,
      exportedAt: DateTime(2026, 6, 30, 9),
    );
    final payload = jsonDecode(utf8.decode(file.bytes)) as Map<String, Object?>;

    expect(file.format, ReportExportFormat.json);
    expect(payload['appVersion'], isNotEmpty);
    expect(payload['exportedAt'], '2026-06-30T09:00:00.000');
    expect(payload['employeeName'], 'Somchai');
    expect(payload['employeeId'], 'EMP-001');
    expect(payload['companyName'], 'ACME');
    expect(payload['payrollSettings'], isA<Map<String, Object?>>());
    expect(payload['workRecords'], isA<List<Object?>>());
    expect(payload['totals'], isA<Map<String, Object?>>());
  });

  test('import valid JSON and preview totals before merge', () {
    final jsonText = utf8.decode(
      service.exportJson(records: records, settings: settings).bytes,
    );

    final preview = service.previewJson(
      jsonText: jsonText,
      existingRecords: const [],
      currentSettings: const WorkSettings.defaults(),
      sourceFileName: 'somchai.json',
    );

    expect(preview.employeeName, 'Somchai');
    expect(preview.employeeId, 'EMP-001');
    expect(preview.recordCount, 2);
    expect(preview.importableCount, 2);
    expect(preview.totalHours, 21);
    expect(preview.totalOtHours, 3);
    expect(preview.estimatedPay, greaterThan(0));
    expect(preview.recordsToImport.first.sourceFileName, 'somchai.json');
    expect(preview.recordsToImport.first.importedAt, isNotNull);
  });

  test('reject invalid JSON', () {
    expect(
      () => service.previewJson(
        jsonText: '{not-json',
        existingRecords: const [],
        currentSettings: const WorkSettings.defaults(),
      ),
      throwsA(isA<EmployeeImportException>()),
    );
  });

  test('detect duplicates by employee date and times', () {
    final jsonText = utf8.decode(
      service.exportJson(records: records, settings: settings).bytes,
    );
    final existing = records.first.copyWith(
      sourceEmployeeId: 'EMP-001',
      sourceEmployeeName: 'Somchai',
      sourceFileName: 'old.json',
      importedAt: DateTime(2026, 6, 20),
    );

    final preview = service.previewJson(
      jsonText: jsonText,
      existingRecords: [existing],
      currentSettings: const WorkSettings.defaults(),
    );

    expect(preview.duplicateCount, 1);
    expect(preview.importableCount, 1);
    expect(preview.hasDuplicates, isTrue);
  });
}

WorkRecordEntity _record({
  required DateTime date,
  required int checkIn,
  required int checkOut,
}) {
  return WorkRecordEntity(
    id: 'record-${date.day}-$checkIn-$checkOut',
    workDate: date,
    checkInMinutes: checkIn,
    checkOutMinutes: checkOut,
    breakMinutes: 0,
    dayType: DayType.normal,
    extraOtHours: 0,
    travelAllowance: 0,
    specialAllowance: 0,
    expense: 0,
    note: '',
    createdAt: date,
    updatedAt: date,
  );
}
