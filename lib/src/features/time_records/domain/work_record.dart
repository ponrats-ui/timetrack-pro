enum DayType {
  normal('normal', 'วันปกติ'),
  weekend('weekend', 'วันหยุดสุดสัปดาห์'),
  holiday('holiday', 'วันหยุดนักขัตฤกษ์');

  const DayType(this.value, this.label);

  final String value;
  final String label;

  static DayType fromValue(String value) {
    return DayType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => DayType.normal,
    );
  }
}

class WorkRecordEntity {
  const WorkRecordEntity({
    required this.id,
    required this.workDate,
    required this.checkInMinutes,
    required this.checkOutMinutes,
    required this.breakMinutes,
    required this.dayType,
    required this.extraOtHours,
    required this.travelAllowance,
    required this.specialAllowance,
    required this.expense,
    required this.note,
    this.isDemo = false,
    this.importedAt,
    this.sourceEmployeeName,
    this.sourceEmployeeId,
    this.sourceFileName,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final DateTime workDate;
  final int checkInMinutes;
  final int checkOutMinutes;
  final int breakMinutes;
  final DayType dayType;
  final double extraOtHours;
  final double travelAllowance;
  final double specialAllowance;
  final double expense;
  final String note;
  final bool isDemo;
  final DateTime? importedAt;
  final String? sourceEmployeeName;
  final String? sourceEmployeeId;
  final String? sourceFileName;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkRecordEntity copyWith({
    DateTime? workDate,
    int? checkInMinutes,
    int? checkOutMinutes,
    int? breakMinutes,
    DayType? dayType,
    double? extraOtHours,
    double? travelAllowance,
    double? specialAllowance,
    double? expense,
    String? note,
    bool? isDemo,
    DateTime? importedAt,
    String? sourceEmployeeName,
    String? sourceEmployeeId,
    String? sourceFileName,
    DateTime? updatedAt,
  }) {
    return WorkRecordEntity(
      id: id,
      workDate: workDate ?? this.workDate,
      checkInMinutes: checkInMinutes ?? this.checkInMinutes,
      checkOutMinutes: checkOutMinutes ?? this.checkOutMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      dayType: dayType ?? this.dayType,
      extraOtHours: extraOtHours ?? this.extraOtHours,
      travelAllowance: travelAllowance ?? this.travelAllowance,
      specialAllowance: specialAllowance ?? this.specialAllowance,
      expense: expense ?? this.expense,
      note: note ?? this.note,
      isDemo: isDemo ?? this.isDemo,
      importedAt: importedAt ?? this.importedAt,
      sourceEmployeeName: sourceEmployeeName ?? this.sourceEmployeeName,
      sourceEmployeeId: sourceEmployeeId ?? this.sourceEmployeeId,
      sourceFileName: sourceFileName ?? this.sourceFileName,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
