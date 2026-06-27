enum AppThemePreference {
  light('light', 'สว่าง'),
  dark('dark', 'มืด'),
  system('system', 'ตามระบบ');

  const AppThemePreference(this.value, this.label);

  final String value;
  final String label;

  static AppThemePreference fromValue(String value) {
    return AppThemePreference.values.firstWhere(
      (item) => item.value == value,
      orElse: () => AppThemePreference.system,
    );
  }
}

class PayrollRules {
  const PayrollRules({
    required this.dailyWage,
    required this.normalWorkHours,
    required this.normalDayMultiplier,
    required this.weekendDayMultiplier,
    required this.holidayDayMultiplier,
    required this.normalOtMultiplier,
    required this.weekendOtMultiplier,
    required this.holidayOtMultiplier,
    required this.nightOtMultiplier,
    required this.mealAllowanceDefault,
    required this.travelAllowanceDefault,
    required this.otherAllowanceDefault,
    required this.socialSecurityDeduction,
    required this.taxDeduction,
    required this.nightShiftStartMinutes,
    required this.nightShiftEndMinutes,
  });

  final double dailyWage;
  final double normalWorkHours;
  final double normalDayMultiplier;
  final double weekendDayMultiplier;
  final double holidayDayMultiplier;
  final double normalOtMultiplier;
  final double weekendOtMultiplier;
  final double holidayOtMultiplier;
  final double nightOtMultiplier;
  final double mealAllowanceDefault;
  final double travelAllowanceDefault;
  final double otherAllowanceDefault;
  final double socialSecurityDeduction;
  final double taxDeduction;
  final int nightShiftStartMinutes;
  final int nightShiftEndMinutes;

  double get hourlyWage {
    if (normalWorkHours <= 0) {
      return 0;
    }

    return dailyWage / normalWorkHours;
  }

  double get totalMonthlyDeductions => socialSecurityDeduction + taxDeduction;
}

class WorkSettings {
  const WorkSettings({
    required this.monthlySalary,
    required this.dailyWage,
    required this.normalWorkHours,
    required this.normalDayMultiplier,
    required this.weekendDayMultiplier,
    required this.holidayDayMultiplier,
    required this.normalOtMultiplier,
    required this.weekendOtMultiplier,
    required this.holidayOtMultiplier,
    required this.nightOtMultiplier,
    required this.mealAllowanceDefault,
    required this.travelAllowanceDefault,
    required this.otherAllowanceDefault,
    required this.socialSecurityDeduction,
    required this.taxDeduction,
    required this.nightShiftStartMinutes,
    required this.nightShiftEndMinutes,
    required this.defaultBreakMinutes,
    required this.companyName,
    required this.employeeName,
    required this.employeeId,
    required this.themePreference,
    required this.onboardingCompleted,
  });

  const WorkSettings.defaults()
    : monthlySalary = 15000,
      dailyWage = 500,
      normalWorkHours = 8,
      normalDayMultiplier = 1,
      weekendDayMultiplier = 3,
      holidayDayMultiplier = 3,
      normalOtMultiplier = 1.5,
      weekendOtMultiplier = 3,
      holidayOtMultiplier = 3,
      nightOtMultiplier = 2,
      mealAllowanceDefault = 0,
      travelAllowanceDefault = 0,
      otherAllowanceDefault = 0,
      socialSecurityDeduction = 750,
      taxDeduction = 0,
      nightShiftStartMinutes = 22 * 60,
      nightShiftEndMinutes = 5 * 60,
      defaultBreakMinutes = 60,
      companyName = '',
      employeeName = '',
      employeeId = '',
      themePreference = AppThemePreference.system,
      onboardingCompleted = false;

  final double monthlySalary;
  final double dailyWage;
  final double normalWorkHours;
  final double normalDayMultiplier;
  final double weekendDayMultiplier;
  final double holidayDayMultiplier;
  final double normalOtMultiplier;
  final double weekendOtMultiplier;
  final double holidayOtMultiplier;
  final double nightOtMultiplier;
  final double mealAllowanceDefault;
  final double travelAllowanceDefault;
  final double otherAllowanceDefault;
  final double socialSecurityDeduction;
  final double taxDeduction;
  final int nightShiftStartMinutes;
  final int nightShiftEndMinutes;
  final int defaultBreakMinutes;
  final String companyName;
  final String employeeName;
  final String employeeId;
  final AppThemePreference themePreference;
  final bool onboardingCompleted;

  double get otRate1 => normalDayMultiplier;

  double get otRate15 => normalOtMultiplier;

  double get otRate2 => weekendOtMultiplier;

  double get otRate3 => holidayOtMultiplier;

  double get hourlyWage => payrollRules.hourlyWage;

  double get totalMonthlyDeductions => payrollRules.totalMonthlyDeductions;

  PayrollRules get payrollRules {
    return PayrollRules(
      dailyWage: dailyWage,
      normalWorkHours: normalWorkHours,
      normalDayMultiplier: normalDayMultiplier,
      weekendDayMultiplier: weekendDayMultiplier,
      holidayDayMultiplier: holidayDayMultiplier,
      normalOtMultiplier: normalOtMultiplier,
      weekendOtMultiplier: weekendOtMultiplier,
      holidayOtMultiplier: holidayOtMultiplier,
      nightOtMultiplier: nightOtMultiplier,
      mealAllowanceDefault: mealAllowanceDefault,
      travelAllowanceDefault: travelAllowanceDefault,
      otherAllowanceDefault: otherAllowanceDefault,
      socialSecurityDeduction: socialSecurityDeduction,
      taxDeduction: taxDeduction,
      nightShiftStartMinutes: nightShiftStartMinutes,
      nightShiftEndMinutes: nightShiftEndMinutes,
    );
  }

  WorkSettings copyWith({
    double? monthlySalary,
    double? dailyWage,
    double? normalWorkHours,
    double? normalDayMultiplier,
    double? weekendDayMultiplier,
    double? holidayDayMultiplier,
    double? normalOtMultiplier,
    double? weekendOtMultiplier,
    double? holidayOtMultiplier,
    double? nightOtMultiplier,
    double? otRate1,
    double? otRate15,
    double? otRate2,
    double? otRate3,
    double? mealAllowanceDefault,
    double? travelAllowanceDefault,
    double? otherAllowanceDefault,
    double? socialSecurityDeduction,
    double? taxDeduction,
    int? nightShiftStartMinutes,
    int? nightShiftEndMinutes,
    int? defaultBreakMinutes,
    String? companyName,
    String? employeeName,
    String? employeeId,
    AppThemePreference? themePreference,
    bool? onboardingCompleted,
  }) {
    return WorkSettings(
      monthlySalary: monthlySalary ?? this.monthlySalary,
      dailyWage: dailyWage ?? this.dailyWage,
      normalWorkHours: normalWorkHours ?? this.normalWorkHours,
      normalDayMultiplier:
          normalDayMultiplier ?? otRate1 ?? this.normalDayMultiplier,
      weekendDayMultiplier: weekendDayMultiplier ?? this.weekendDayMultiplier,
      holidayDayMultiplier: holidayDayMultiplier ?? this.holidayDayMultiplier,
      normalOtMultiplier:
          normalOtMultiplier ?? otRate15 ?? this.normalOtMultiplier,
      weekendOtMultiplier:
          weekendOtMultiplier ?? otRate2 ?? this.weekendOtMultiplier,
      holidayOtMultiplier:
          holidayOtMultiplier ?? otRate3 ?? this.holidayOtMultiplier,
      nightOtMultiplier: nightOtMultiplier ?? this.nightOtMultiplier,
      mealAllowanceDefault: mealAllowanceDefault ?? this.mealAllowanceDefault,
      travelAllowanceDefault:
          travelAllowanceDefault ?? this.travelAllowanceDefault,
      otherAllowanceDefault:
          otherAllowanceDefault ?? this.otherAllowanceDefault,
      socialSecurityDeduction:
          socialSecurityDeduction ?? this.socialSecurityDeduction,
      taxDeduction: taxDeduction ?? this.taxDeduction,
      nightShiftStartMinutes:
          nightShiftStartMinutes ?? this.nightShiftStartMinutes,
      nightShiftEndMinutes: nightShiftEndMinutes ?? this.nightShiftEndMinutes,
      defaultBreakMinutes: defaultBreakMinutes ?? this.defaultBreakMinutes,
      companyName: companyName ?? this.companyName,
      employeeName: employeeName ?? this.employeeName,
      employeeId: employeeId ?? this.employeeId,
      themePreference: themePreference ?? this.themePreference,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
