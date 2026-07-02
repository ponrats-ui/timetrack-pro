import 'dart:convert';
import 'dart:typed_data';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../reports/domain/report_export.dart';
import '../../settings/domain/work_settings.dart';
import '../../time_records/domain/work_record.dart';

class BackupService {
  const BackupService();

  ReportExportFile exportJson({
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
    DateTime? exportedAt,
  }) {
    final exportTime = exportedAt ?? DateTime.now();
    final sortedRecords = records.toList()
      ..sort((a, b) => a.workDate.compareTo(b.workDate));
    final payload = {
      'format': 'timetrack_pro_backup',
      'formatVersion': 1,
      'appVersion': '${AppConstants.version}+${AppConstants.buildNumber}',
      'buildLabel': AppConstants.buildLabel,
      'gitCommit': AppConstants.gitCommit,
      'databaseVersion': AppDatabase.currentSchemaVersion,
      'exportedAt': exportTime.toIso8601String(),
      'settings': _settingsToJson(settings),
      'workRecords': sortedRecords.map(_recordToJson).toList(),
    };
    final prettyJson = const JsonEncoder.withIndent('  ').convert(payload);

    return ReportExportFile(
      format: ReportExportFormat.json,
      fileName: _backupFileName(exportTime),
      mimeType: 'application/json',
      bytes: Uint8List.fromList(utf8.encode(prettyJson)),
    );
  }

  BackupPreview previewJson(String jsonText) {
    final payload = _decodePayload(jsonText);
    _validatePayload(payload);
    final settings = _settingsFromJson(_asMap(payload['settings'], 'settings'));
    final records = _asList(
      payload['workRecords'],
      'workRecords',
    ).map((item) => _recordFromJson(_asMap(item, 'workRecords'))).toList();
    final exportedAt = DateTime.tryParse(
      _asString(payload['exportedAt'], 'exportedAt'),
    );
    if (exportedAt == null) {
      throw const BackupException('Backup exported date is invalid.');
    }

    return BackupPreview(
      appVersion: _asString(payload['appVersion'], 'appVersion'),
      exportedAt: exportedAt,
      settings: settings,
      records: records,
      recordCount: records.length,
      employeeName: settings.employeeName,
      companyName: settings.companyName,
    );
  }

  Map<String, Object?> _decodePayload(String jsonText) {
    try {
      final decoded = jsonDecode(jsonText);
      return _asMap(decoded, 'JSON');
    } on BackupException {
      rethrow;
    } catch (_) {
      throw const BackupException('This is not a readable JSON backup.');
    }
  }

  void _validatePayload(Map<String, Object?> payload) {
    if (payload['format'] != 'timetrack_pro_backup') {
      throw const BackupException('This file is not a TimeTrack Pro backup.');
    }
    for (final key in ['appVersion', 'exportedAt', 'settings', 'workRecords']) {
      if (!payload.containsKey(key)) {
        throw BackupException('Backup is missing $key.');
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
      'companyName': settings.companyName,
      'employeeName': settings.employeeName,
      'employeeId': settings.employeeId,
      'themePreference': settings.themePreference.value,
      'onboardingCompleted': settings.onboardingCompleted,
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
      companyName: _optionalString(json['companyName']) ?? '',
      employeeName: _optionalString(json['employeeName']) ?? '',
      employeeId: _optionalString(json['employeeId']) ?? '',
      themePreference: AppThemePreference.fromValue(
        _optionalString(json['themePreference']) ??
            defaults.themePreference.value,
      ),
      onboardingCompleted: json['onboardingCompleted'] is bool
          ? json['onboardingCompleted']! as bool
          : true,
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
      'isDemo': record.isDemo,
      'importedAt': record.importedAt?.toIso8601String(),
      'sourceEmployeeName': record.sourceEmployeeName,
      'sourceEmployeeId': record.sourceEmployeeId,
      'sourceFileName': record.sourceFileName,
      'createdAt': record.createdAt.toIso8601String(),
      'updatedAt': record.updatedAt.toIso8601String(),
    };
  }

  WorkRecordEntity _recordFromJson(Map<String, Object?> json) {
    final workDate = DateTime.tryParse(_asString(json['workDate'], 'workDate'));
    if (workDate == null) {
      throw const BackupException('A work record date is invalid.');
    }
    final now = DateTime.now();
    return WorkRecordEntity(
      id: _asString(json['id'], 'id'),
      workDate: DateTime(workDate.year, workDate.month, workDate.day),
      checkInMinutes: _asInt(json['checkInMinutes'], 'checkInMinutes'),
      checkOutMinutes: _asInt(json['checkOutMinutes'], 'checkOutMinutes'),
      breakMinutes: _asInt(json['breakMinutes'], 'breakMinutes'),
      dayType: DayType.fromValue(_asString(json['dayType'], 'dayType')),
      extraOtHours: _asDouble(json['extraOtHours'], 'extraOtHours'),
      travelAllowance: _asDouble(json['travelAllowance'], 'travelAllowance'),
      specialAllowance: _asDouble(json['specialAllowance'], 'specialAllowance'),
      expense: _asDouble(json['expense'], 'expense'),
      note: _asString(json['note'], 'note'),
      isDemo: json['isDemo'] is bool ? json['isDemo']! as bool : false,
      importedAt: _optionalDate(json['importedAt']),
      sourceEmployeeName: _optionalString(json['sourceEmployeeName']),
      sourceEmployeeId: _optionalString(json['sourceEmployeeId']),
      sourceFileName: _optionalString(json['sourceFileName']),
      createdAt: _optionalDate(json['createdAt']) ?? now,
      updatedAt: _optionalDate(json['updatedAt']) ?? now,
    );
  }

  String _backupFileName(DateTime exportedAt) {
    final date =
        '${exportedAt.year.toString().padLeft(4, '0')}'
        '${exportedAt.month.toString().padLeft(2, '0')}'
        '${exportedAt.day.toString().padLeft(2, '0')}';
    return 'timetrack_backup_$date.json';
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
    throw BackupException('$field is invalid.');
  }

  List<Object?> _asList(Object? value, String field) {
    if (value is List) {
      return value;
    }
    throw BackupException('$field is invalid.');
  }

  String _asString(Object? value, String field) {
    if (value is String) {
      return value;
    }
    throw BackupException('$field is invalid.');
  }

  String? _optionalString(Object? value) {
    return value is String && value.trim().isNotEmpty ? value : null;
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
    if (value is num) {
      return value.toInt();
    }
    throw BackupException('$field is invalid.');
  }

  double _asDouble(Object? value, String field) {
    if (value is num) {
      return value.toDouble();
    }
    throw BackupException('$field is invalid.');
  }

  DateTime? _optionalDate(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}

class BackupPreview {
  const BackupPreview({
    required this.appVersion,
    required this.exportedAt,
    required this.settings,
    required this.records,
    required this.recordCount,
    required this.employeeName,
    required this.companyName,
  });

  final String appVersion;
  final DateTime exportedAt;
  final WorkSettings settings;
  final List<WorkRecordEntity> records;
  final int recordCount;
  final String employeeName;
  final String companyName;
}

class BackupException implements Exception {
  const BackupException(this.message);

  final String message;

  @override
  String toString() => message;
}
