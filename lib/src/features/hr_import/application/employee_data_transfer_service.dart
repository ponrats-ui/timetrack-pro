import 'dart:convert';
import 'dart:typed_data';

import '../../../core/constants/app_constants.dart';
import '../../reports/domain/report_export.dart';
import '../../settings/domain/work_settings.dart';
import '../../time_records/application/work_calculator.dart';
import '../../time_records/domain/work_record.dart';

class EmployeeDataTransferService {
  const EmployeeDataTransferService({this.calculator = const WorkCalculator()});

  final WorkCalculator calculator;

  ReportExportFile exportJson({
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
    DateTime? exportedAt,
  }) {
    final exportTime = exportedAt ?? DateTime.now();
    final sortedRecords = records.toList()
      ..sort((a, b) => a.workDate.compareTo(b.workDate));
    final totals = calculator.calculateMonthly(sortedRecords, settings);
    final payload = {
      'format': 'timetrack_pro_employee_records',
      'formatVersion': 1,
      'appVersion': '${AppConstants.version}+${AppConstants.buildNumber}',
      'exportedAt': exportTime.toIso8601String(),
      'employeeName': settings.employeeName,
      'employeeId': settings.employeeId,
      'companyName': settings.companyName,
      'payrollSettings': _settingsToJson(settings),
      'workRecords': sortedRecords.map(_recordToJson).toList(),
      'totals': {
        'recordCount': sortedRecords.length,
        'totalHours': totals.totalWorkHours,
        'totalOtHours': totals.otHours,
        'estimatedPay': totals.grossIncome,
        'netIncome': totals.netIncome,
      },
    };
    final prettyJson = const JsonEncoder.withIndent('  ').convert(payload);

    return ReportExportFile(
      format: ReportExportFormat.json,
      fileName: _jsonFileName(exportTime, settings),
      mimeType: 'application/json',
      bytes: Uint8List.fromList(utf8.encode(prettyJson)),
    );
  }

  EmployeeImportPreview previewJson({
    required String jsonText,
    required Iterable<WorkRecordEntity> existingRecords,
    required WorkSettings currentSettings,
    String sourceFileName = 'นำเข้าจาก JSON',
  }) {
    final payload = _decodePayload(jsonText);
    _validatePayload(payload);

    final sourceSettings = _settingsFromJson(
      _asMap(payload['payrollSettings'], 'payrollSettings'),
    );
    final employeeName = _asString(payload['employeeName'], 'employeeName');
    final employeeId = _asString(payload['employeeId'], 'employeeId');
    final companyName = _asString(payload['companyName'], 'companyName');
    final exportedAt = DateTime.tryParse(
      _asString(payload['exportedAt'], 'exportedAt'),
    );
    if (exportedAt == null) {
      throw const EmployeeImportException('วันที่ส่งออกไม่ถูกต้อง');
    }

    final importedAt = DateTime.now();
    final records = _asList(payload['workRecords'], 'workRecords')
        .map(
          (item) => _recordFromJson(
            _asMap(item, 'workRecords'),
            sourceEmployeeName: employeeName,
            sourceEmployeeId: employeeId,
            sourceFileName: sourceFileName,
            importedAt: importedAt,
          ),
        )
        .toList();
    if (records.isEmpty) {
      throw const EmployeeImportException('ไม่พบรายการทำงานในไฟล์นี้');
    }

    final existingKeys = existingRecords
        .map((record) => _duplicateKey(record, currentSettings.employeeId))
        .toSet();
    final duplicateRecords = records
        .where(
          (record) => existingKeys.contains(_duplicateKey(record, employeeId)),
        )
        .toList();
    final newRecords = records
        .where(
          (record) => !existingKeys.contains(_duplicateKey(record, employeeId)),
        )
        .toList();
    final totals = calculator.calculateMonthly(records, sourceSettings);
    final sortedDates = records.map((record) => record.workDate).toList()
      ..sort();

    return EmployeeImportPreview(
      appVersion: _asString(payload['appVersion'], 'appVersion'),
      exportedAt: exportedAt,
      employeeName: employeeName,
      employeeId: employeeId,
      companyName: companyName,
      sourceFileName: sourceFileName,
      dateFrom: sortedDates.first,
      dateTo: sortedDates.last,
      recordCount: records.length,
      duplicateCount: duplicateRecords.length,
      totalHours: totals.totalWorkHours,
      totalOtHours: totals.otHours,
      estimatedPay: totals.grossIncome,
      recordsToImport: newRecords,
      duplicateRecords: duplicateRecords,
    );
  }

  Map<String, Object?> _decodePayload(String jsonText) {
    try {
      return _asMap(jsonDecode(jsonText), 'JSON');
    } on EmployeeImportException {
      rethrow;
    } catch (_) {
      throw const EmployeeImportException('ไฟล์นี้ไม่ใช่ JSON ที่ระบบอ่านได้');
    }
  }

  void _validatePayload(Map<String, Object?> payload) {
    final format = payload['format'];
    if (format != 'timetrack_pro_employee_records') {
      throw const EmployeeImportException(
        'ไฟล์นี้ไม่ใช่ไฟล์ข้อมูลจาก TimeTrack Pro',
      );
    }
    for (final key in [
      'appVersion',
      'exportedAt',
      'employeeName',
      'employeeId',
      'companyName',
      'payrollSettings',
      'workRecords',
      'totals',
    ]) {
      if (!payload.containsKey(key)) {
        throw EmployeeImportException('ไฟล์นี้ขาดข้อมูล $key');
      }
    }
  }

  Map<String, Object?> _settingsToJson(WorkSettings settings) {
    return {
      'monthlySalary': settings.monthlySalary,
      'dailyWage': settings.derivedDailyWage,
      'workSchedule': settings.workSchedule.value,
      'normalWorkSchedule': settings.normalWorkSchedule.value,
      'customScheduleStartMinutes': settings.customScheduleStartMinutes,
      'customScheduleEndMinutes': settings.customScheduleEndMinutes,
      'payrollPolicyType': settings.payrollPolicyType.value,
      'normalWorkHours': settings.effectiveNormalWorkHours,
      'normalDayMultiplier': settings.normalDayMultiplier,
      'weekendDayMultiplier': settings.weekendDayMultiplier,
      'holidayDayMultiplier': settings.holidayDayMultiplier,
      'normalOtMultiplier': settings.normalOtMultiplier,
      'weekendOtMultiplier': settings.weekendOtMultiplier,
      'holidayOtMultiplier': settings.holidayOtMultiplier,
      'nightOtMultiplier': settings.nightOtMultiplier,
      'mealAllowanceDefault': settings.mealAllowanceDefault,
      'travelAllowanceDefault': settings.travelAllowanceDefault,
      'otherAllowanceDefault': settings.otherAllowanceDefault,
      'socialSecurityDeduction': settings.socialSecurityDeduction,
      'taxDeduction': settings.taxDeduction,
      'nightShiftStartMinutes': settings.nightShiftStartMinutes,
      'nightShiftEndMinutes': settings.nightShiftEndMinutes,
      'otStartMinutes': settings.otStartMinutes,
      'minimumOtMinutes': settings.minimumOtMinutes,
      'otRoundingPolicy': settings.otRoundingPolicy.value,
      'defaultBreakMinutes': settings.defaultBreakMinutes,
    };
  }

  WorkSettings _settingsFromJson(Map<String, Object?> json) {
    const defaults = WorkSettings.defaults();
    return defaults.copyWith(
      monthlySalary: _asDouble(json['monthlySalary'], 'monthlySalary'),
      dailyWage: _asDouble(json['dailyWage'], 'dailyWage'),
      workSchedule: WorkSchedule.fromValue(
        _asString(json['workSchedule'], 'workSchedule'),
      ),
      normalWorkSchedule: NormalWorkSchedule.fromValue(
        _asString(json['normalWorkSchedule'], 'normalWorkSchedule'),
      ),
      customScheduleStartMinutes: _asInt(
        json['customScheduleStartMinutes'],
        'customScheduleStartMinutes',
      ),
      customScheduleEndMinutes: _asInt(
        json['customScheduleEndMinutes'],
        'customScheduleEndMinutes',
      ),
      payrollPolicyType: PayrollPolicyType.fromValue(
        _asString(json['payrollPolicyType'], 'payrollPolicyType'),
      ),
      normalWorkHours: _asDouble(json['normalWorkHours'], 'normalWorkHours'),
      normalDayMultiplier: _asDouble(
        json['normalDayMultiplier'],
        'normalDayMultiplier',
      ),
      weekendDayMultiplier: _asDouble(
        json['weekendDayMultiplier'],
        'weekendDayMultiplier',
      ),
      holidayDayMultiplier: _asDouble(
        json['holidayDayMultiplier'],
        'holidayDayMultiplier',
      ),
      normalOtMultiplier: _asDouble(
        json['normalOtMultiplier'],
        'normalOtMultiplier',
      ),
      weekendOtMultiplier: _asDouble(
        json['weekendOtMultiplier'],
        'weekendOtMultiplier',
      ),
      holidayOtMultiplier: _asDouble(
        json['holidayOtMultiplier'],
        'holidayOtMultiplier',
      ),
      nightOtMultiplier: _asDouble(
        json['nightOtMultiplier'],
        'nightOtMultiplier',
      ),
      mealAllowanceDefault: _asDouble(
        json['mealAllowanceDefault'],
        'mealAllowanceDefault',
      ),
      travelAllowanceDefault: _asDouble(
        json['travelAllowanceDefault'],
        'travelAllowanceDefault',
      ),
      otherAllowanceDefault: _asDouble(
        json['otherAllowanceDefault'],
        'otherAllowanceDefault',
      ),
      socialSecurityDeduction: _asDouble(
        json['socialSecurityDeduction'],
        'socialSecurityDeduction',
      ),
      taxDeduction: _asDouble(json['taxDeduction'], 'taxDeduction'),
      nightShiftStartMinutes: _asInt(
        json['nightShiftStartMinutes'],
        'nightShiftStartMinutes',
      ),
      nightShiftEndMinutes: _asInt(
        json['nightShiftEndMinutes'],
        'nightShiftEndMinutes',
      ),
      otStartMinutes: _optionalInt(json['otStartMinutes']),
      minimumOtMinutes:
          _optionalInt(json['minimumOtMinutes']) ?? defaults.minimumOtMinutes,
      otRoundingPolicy: OtRoundingPolicy.fromValue(
        _optionalString(json['otRoundingPolicy']) ??
            defaults.otRoundingPolicy.value,
      ),
      defaultBreakMinutes: _asInt(
        json['defaultBreakMinutes'],
        'defaultBreakMinutes',
      ),
    );
  }

  Map<String, Object?> _recordToJson(WorkRecordEntity record) {
    return {
      'id': record.id,
      'workDate': _dateOnly(record.workDate),
      'checkInMinutes': record.checkInMinutes,
      'checkOutMinutes': record.checkOutMinutes,
      'breakMinutes': record.breakMinutes,
      'dayType': record.dayType.value,
      'extraOtHours': record.extraOtHours,
      'travelAllowance': record.travelAllowance,
      'specialAllowance': record.specialAllowance,
      'expense': record.expense,
      'note': record.note,
      'createdAt': record.createdAt.toIso8601String(),
      'updatedAt': record.updatedAt.toIso8601String(),
    };
  }

  WorkRecordEntity _recordFromJson(
    Map<String, Object?> json, {
    required String sourceEmployeeName,
    required String sourceEmployeeId,
    required String sourceFileName,
    required DateTime importedAt,
  }) {
    final workDate = DateTime.tryParse(_asString(json['workDate'], 'workDate'));
    if (workDate == null) {
      throw const EmployeeImportException('วันที่ทำงานในไฟล์ไม่ถูกต้อง');
    }
    final checkIn = _asInt(json['checkInMinutes'], 'checkInMinutes');
    final checkOut = _asInt(json['checkOutMinutes'], 'checkOutMinutes');
    final createdAt =
        DateTime.tryParse(_optionalString(json['createdAt']) ?? '') ??
        importedAt;
    final updatedAt =
        DateTime.tryParse(_optionalString(json['updatedAt']) ?? '') ??
        importedAt;

    return WorkRecordEntity(
      id:
          'import-${sourceEmployeeId.isEmpty ? 'employee' : sourceEmployeeId}-'
          '${_dateOnly(workDate)}-$checkIn-$checkOut-'
          '${importedAt.microsecondsSinceEpoch}',
      workDate: DateTime(workDate.year, workDate.month, workDate.day),
      checkInMinutes: checkIn,
      checkOutMinutes: checkOut,
      breakMinutes: _asInt(json['breakMinutes'], 'breakMinutes'),
      dayType: DayType.fromValue(_asString(json['dayType'], 'dayType')),
      extraOtHours: _asDouble(json['extraOtHours'], 'extraOtHours'),
      travelAllowance: _asDouble(json['travelAllowance'], 'travelAllowance'),
      specialAllowance: _asDouble(json['specialAllowance'], 'specialAllowance'),
      expense: _asDouble(json['expense'], 'expense'),
      note: _asString(json['note'], 'note'),
      importedAt: importedAt,
      sourceEmployeeName: sourceEmployeeName,
      sourceEmployeeId: sourceEmployeeId,
      sourceFileName: sourceFileName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  String _duplicateKey(WorkRecordEntity record, String fallbackEmployeeId) {
    final employeeId = (record.sourceEmployeeId?.trim().isNotEmpty ?? false)
        ? record.sourceEmployeeId!.trim()
        : fallbackEmployeeId.trim();
    return [
      employeeId,
      _dateOnly(record.workDate),
      record.checkInMinutes,
      record.checkOutMinutes,
    ].join('|');
  }

  String _jsonFileName(DateTime exportedAt, WorkSettings settings) {
    final employee = settings.employeeId.trim().isEmpty
        ? 'employee'
        : settings.employeeId.trim().replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final date =
        '${exportedAt.year.toString().padLeft(4, '0')}'
        '${exportedAt.month.toString().padLeft(2, '0')}'
        '${exportedAt.day.toString().padLeft(2, '0')}';
    return 'timetrack_employee_${employee}_$date.json';
  }

  String _dateOnly(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, Object?> _asMap(Object? value, String field) {
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw EmployeeImportException('ข้อมูล $field ไม่ถูกต้อง');
  }

  List<Object?> _asList(Object? value, String field) {
    if (value is List) {
      return value;
    }
    throw EmployeeImportException('ข้อมูล $field ไม่ถูกต้อง');
  }

  String _asString(Object? value, String field) {
    if (value is String) {
      return value;
    }
    throw EmployeeImportException('ข้อมูล $field ไม่ถูกต้อง');
  }

  String? _optionalString(Object? value) {
    return value is String ? value : null;
  }

  int? _optionalInt(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    return null;
  }

  int _asInt(Object? value, String field) {
    if (value is int) {
      return value;
    }
    if (value is num && value == value.roundToDouble()) {
      return value.toInt();
    }
    throw EmployeeImportException('ข้อมูล $field ไม่ถูกต้อง');
  }

  double _asDouble(Object? value, String field) {
    if (value is num) {
      return value.toDouble();
    }
    throw EmployeeImportException('ข้อมูล $field ไม่ถูกต้อง');
  }
}

class EmployeeImportPreview {
  const EmployeeImportPreview({
    required this.appVersion,
    required this.exportedAt,
    required this.employeeName,
    required this.employeeId,
    required this.companyName,
    required this.sourceFileName,
    required this.dateFrom,
    required this.dateTo,
    required this.recordCount,
    required this.duplicateCount,
    required this.totalHours,
    required this.totalOtHours,
    required this.estimatedPay,
    required this.recordsToImport,
    required this.duplicateRecords,
  });

  final String appVersion;
  final DateTime exportedAt;
  final String employeeName;
  final String employeeId;
  final String companyName;
  final String sourceFileName;
  final DateTime dateFrom;
  final DateTime dateTo;
  final int recordCount;
  final int duplicateCount;
  final double totalHours;
  final double totalOtHours;
  final double estimatedPay;
  final List<WorkRecordEntity> recordsToImport;
  final List<WorkRecordEntity> duplicateRecords;

  int get importableCount => recordsToImport.length;
  bool get hasDuplicates => duplicateCount > 0;
}

class EmployeeImportException implements Exception {
  const EmployeeImportException(this.message);

  final String message;

  @override
  String toString() => message;
}
