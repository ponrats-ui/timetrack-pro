class WorkSettings {
  const WorkSettings({
    required this.monthlySalary,
    required this.dailyWage,
    required this.normalWorkHours,
    required this.otRate1,
    required this.otRate15,
    required this.otRate2,
    required this.otRate3,
    required this.travelAllowanceDefault,
    required this.socialSecurityDeduction,
    required this.taxDeduction,
    required this.defaultBreakMinutes,
    required this.companyName,
    required this.employeeName,
    required this.employeeId,
  });

  const WorkSettings.defaults()
    : monthlySalary = 15000,
      dailyWage = 500,
      normalWorkHours = 8,
      otRate1 = 1,
      otRate15 = 1.5,
      otRate2 = 2,
      otRate3 = 3,
      travelAllowanceDefault = 0,
      socialSecurityDeduction = 750,
      taxDeduction = 0,
      defaultBreakMinutes = 60,
      companyName = '',
      employeeName = '',
      employeeId = '';

  final double monthlySalary;
  final double dailyWage;
  final double normalWorkHours;
  final double otRate1;
  final double otRate15;
  final double otRate2;
  final double otRate3;
  final double travelAllowanceDefault;
  final double socialSecurityDeduction;
  final double taxDeduction;
  final int defaultBreakMinutes;
  final String companyName;
  final String employeeName;
  final String employeeId;

  double get hourlyWage => dailyWage / normalWorkHours;

  double get totalMonthlyDeductions => socialSecurityDeduction + taxDeduction;

  WorkSettings copyWith({
    double? monthlySalary,
    double? dailyWage,
    double? normalWorkHours,
    double? otRate1,
    double? otRate15,
    double? otRate2,
    double? otRate3,
    double? travelAllowanceDefault,
    double? socialSecurityDeduction,
    double? taxDeduction,
    int? defaultBreakMinutes,
    String? companyName,
    String? employeeName,
    String? employeeId,
  }) {
    return WorkSettings(
      monthlySalary: monthlySalary ?? this.monthlySalary,
      dailyWage: dailyWage ?? this.dailyWage,
      normalWorkHours: normalWorkHours ?? this.normalWorkHours,
      otRate1: otRate1 ?? this.otRate1,
      otRate15: otRate15 ?? this.otRate15,
      otRate2: otRate2 ?? this.otRate2,
      otRate3: otRate3 ?? this.otRate3,
      travelAllowanceDefault:
          travelAllowanceDefault ?? this.travelAllowanceDefault,
      socialSecurityDeduction:
          socialSecurityDeduction ?? this.socialSecurityDeduction,
      taxDeduction: taxDeduction ?? this.taxDeduction,
      defaultBreakMinutes: defaultBreakMinutes ?? this.defaultBreakMinutes,
      companyName: companyName ?? this.companyName,
      employeeName: employeeName ?? this.employeeName,
      employeeId: employeeId ?? this.employeeId,
    );
  }
}
