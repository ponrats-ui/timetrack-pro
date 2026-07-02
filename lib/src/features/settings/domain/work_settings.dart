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

enum WorkSchedule {
  mondayFriday('monday_friday', 'จันทร์-ศุกร์ (20 วัน/เดือน)', 20),
  days22('days_22', '22 วัน/เดือน', 22),
  mondaySaturday('monday_saturday', 'จันทร์-เสาร์ (24 วัน/เดือน)', 24),
  days26('days_26', '26 วัน/เดือน', 26),
  days30('days_30', '30 วัน/เดือน', 30);

  const WorkSchedule(this.value, this.label, this.workingDaysPerMonth);

  final String value;
  final String label;
  final int workingDaysPerMonth;

  static WorkSchedule fromValue(String value) {
    return WorkSchedule.values.firstWhere(
      (item) => item.value == value,
      orElse: () => WorkSchedule.mondayFriday,
    );
  }
}

enum NormalWorkSchedule {
  eightToFive('08_17', '08:00-17:00', 8 * 60, 17 * 60),
  eightThirtyToFiveThirty(
    '0830_1730',
    '08:30-17:30',
    (8 * 60) + 30,
    (17 * 60) + 30,
  ),
  nineToSix('09_18', '09:00-18:00', 9 * 60, 18 * 60),
  custom('custom', 'กำหนดเอง', 8 * 60, 17 * 60);

  const NormalWorkSchedule(
    this.value,
    this.label,
    this.startMinutes,
    this.endMinutes,
  );

  final String value;
  final String label;
  final int startMinutes;
  final int endMinutes;

  double get normalHours {
    var minutes = endMinutes - startMinutes;
    if (minutes < 0) {
      minutes += 24 * 60;
    }
    return minutes / 60;
  }

  static NormalWorkSchedule fromValue(String value) {
    return NormalWorkSchedule.values.firstWhere(
      (item) => item.value == value,
      orElse: () => NormalWorkSchedule.eightToFive,
    );
  }
}

enum PayrollPolicyType {
  thaiLabour('thai_labour', 'กฎหมายแรงงานไทย'),
  company('company', 'นโยบายบริษัท'),
  custom('custom', 'กำหนดเอง');

  const PayrollPolicyType(this.value, this.label);

  final String value;
  final String label;

  static PayrollPolicyType fromValue(String value) {
    return PayrollPolicyType.values.firstWhere(
      (item) => item.value == value,
      orElse: () => PayrollPolicyType.thaiLabour,
    );
  }
}

enum OtRoundingPolicy {
  none('none', 'ไม่ปัดเวลา OT'),
  companyHalfHour('company_half_hour', 'ปัดตามนโยบายบริษัท');

  const OtRoundingPolicy(this.value, this.label);

  final String value;
  final String label;

  static OtRoundingPolicy fromValue(String value) {
    return OtRoundingPolicy.values.firstWhere(
      (item) => item.value == value,
      orElse: () => OtRoundingPolicy.companyHalfHour,
    );
  }

  static OtRoundingPolicy fromStorageCode(int code) {
    return switch (code) {
      0 => OtRoundingPolicy.none,
      _ => OtRoundingPolicy.companyHalfHour,
    };
  }

  int get storageCode {
    return switch (this) {
      OtRoundingPolicy.none => 0,
      OtRoundingPolicy.companyHalfHour => 1,
    };
  }
}

class PayrollRules {
  const PayrollRules({
    required this.dailyWage,
    required this.normalWorkHours,
    required this.normalScheduleStartMinutes,
    required this.normalScheduleEndMinutes,
    required this.payrollPolicyType,
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
    required this.otStartMinutes,
    required this.minimumOtMinutes,
    required this.otRoundingPolicy,
  });

  final double dailyWage;
  final double normalWorkHours;
  final int normalScheduleStartMinutes;
  final int normalScheduleEndMinutes;
  final PayrollPolicyType payrollPolicyType;
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
  final int? otStartMinutes;
  final int minimumOtMinutes;
  final OtRoundingPolicy otRoundingPolicy;

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
    required this.workSchedule,
    required this.normalWorkSchedule,
    required this.customScheduleStartMinutes,
    required this.customScheduleEndMinutes,
    required this.payrollPolicyType,
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
    required this.otStartMinutes,
    required this.minimumOtMinutes,
    required this.otRoundingPolicy,
    required this.defaultBreakMinutes,
    required this.companyName,
    required this.employeeName,
    required this.employeeId,
    required this.themePreference,
    required this.onboardingCompleted,
  });

  const WorkSettings.defaults()
    : monthlySalary = 15000,
      dailyWage = 750,
      workSchedule = WorkSchedule.mondayFriday,
      normalWorkSchedule = NormalWorkSchedule.eightToFive,
      customScheduleStartMinutes = 8 * 60,
      customScheduleEndMinutes = 17 * 60,
      payrollPolicyType = PayrollPolicyType.thaiLabour,
      normalWorkHours = 0,
      normalDayMultiplier = 1,
      weekendDayMultiplier = 1.5,
      holidayDayMultiplier = 1.5,
      normalOtMultiplier = 1.5,
      weekendOtMultiplier = 3,
      holidayOtMultiplier = 3,
      nightOtMultiplier = 0,
      mealAllowanceDefault = 0,
      travelAllowanceDefault = 0,
      otherAllowanceDefault = 0,
      socialSecurityDeduction = 750,
      taxDeduction = 0,
      nightShiftStartMinutes = 22 * 60,
      nightShiftEndMinutes = 5 * 60,
      otStartMinutes = null,
      minimumOtMinutes = 0,
      otRoundingPolicy = OtRoundingPolicy.companyHalfHour,
      defaultBreakMinutes = 0,
      companyName = '',
      employeeName = '',
      employeeId = '',
      themePreference = AppThemePreference.system,
      onboardingCompleted = false;

  final double monthlySalary;
  final double dailyWage;
  final WorkSchedule workSchedule;
  final NormalWorkSchedule normalWorkSchedule;
  final int customScheduleStartMinutes;
  final int customScheduleEndMinutes;
  final PayrollPolicyType payrollPolicyType;
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
  final int? otStartMinutes;
  final int minimumOtMinutes;
  final OtRoundingPolicy otRoundingPolicy;
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

  int get effectiveScheduleStartMinutes {
    return normalWorkSchedule == NormalWorkSchedule.custom
        ? customScheduleStartMinutes
        : normalWorkSchedule.startMinutes;
  }

  int get effectiveScheduleEndMinutes {
    return normalWorkSchedule == NormalWorkSchedule.custom
        ? customScheduleEndMinutes
        : normalWorkSchedule.endMinutes;
  }

  double get effectiveNormalWorkHours {
    var minutes = effectiveScheduleEndMinutes - effectiveScheduleStartMinutes;
    if (minutes < 0) {
      minutes += 24 * 60;
    }
    return minutes / 60;
  }

  double get derivedDailyWage {
    if (workSchedule.workingDaysPerMonth <= 0) {
      return 0;
    }

    return monthlySalary / workSchedule.workingDaysPerMonth;
  }

  double get totalMonthlyDeductions => payrollRules.totalMonthlyDeductions;

  PayrollRules get payrollRules {
    return PayrollRules(
      dailyWage: derivedDailyWage,
      normalWorkHours: effectiveNormalWorkHours,
      normalScheduleStartMinutes: effectiveScheduleStartMinutes,
      normalScheduleEndMinutes: effectiveScheduleEndMinutes,
      payrollPolicyType: payrollPolicyType,
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
      otStartMinutes: otStartMinutes,
      minimumOtMinutes: minimumOtMinutes,
      otRoundingPolicy: otRoundingPolicy,
    );
  }

  WorkSettings copyWith({
    double? monthlySalary,
    double? dailyWage,
    WorkSchedule? workSchedule,
    NormalWorkSchedule? normalWorkSchedule,
    int? customScheduleStartMinutes,
    int? customScheduleEndMinutes,
    PayrollPolicyType? payrollPolicyType,
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
    Object? otStartMinutes = _unset,
    int? minimumOtMinutes,
    OtRoundingPolicy? otRoundingPolicy,
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
      workSchedule: workSchedule ?? this.workSchedule,
      normalWorkSchedule: normalWorkSchedule ?? this.normalWorkSchedule,
      customScheduleStartMinutes:
          customScheduleStartMinutes ?? this.customScheduleStartMinutes,
      customScheduleEndMinutes:
          customScheduleEndMinutes ?? this.customScheduleEndMinutes,
      payrollPolicyType: payrollPolicyType ?? this.payrollPolicyType,
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
      otStartMinutes: identical(otStartMinutes, _unset)
          ? this.otStartMinutes
          : otStartMinutes as int?,
      minimumOtMinutes: minimumOtMinutes ?? this.minimumOtMinutes,
      otRoundingPolicy: otRoundingPolicy ?? this.otRoundingPolicy,
      defaultBreakMinutes: defaultBreakMinutes ?? this.defaultBreakMinutes,
      companyName: companyName ?? this.companyName,
      employeeName: employeeName ?? this.employeeName,
      employeeId: employeeId ?? this.employeeId,
      themePreference: themePreference ?? this.themePreference,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkSettings &&
            monthlySalary == other.monthlySalary &&
            dailyWage == other.dailyWage &&
            workSchedule == other.workSchedule &&
            normalWorkSchedule == other.normalWorkSchedule &&
            customScheduleStartMinutes == other.customScheduleStartMinutes &&
            customScheduleEndMinutes == other.customScheduleEndMinutes &&
            payrollPolicyType == other.payrollPolicyType &&
            normalWorkHours == other.normalWorkHours &&
            normalDayMultiplier == other.normalDayMultiplier &&
            weekendDayMultiplier == other.weekendDayMultiplier &&
            holidayDayMultiplier == other.holidayDayMultiplier &&
            normalOtMultiplier == other.normalOtMultiplier &&
            weekendOtMultiplier == other.weekendOtMultiplier &&
            holidayOtMultiplier == other.holidayOtMultiplier &&
            nightOtMultiplier == other.nightOtMultiplier &&
            mealAllowanceDefault == other.mealAllowanceDefault &&
            travelAllowanceDefault == other.travelAllowanceDefault &&
            otherAllowanceDefault == other.otherAllowanceDefault &&
            socialSecurityDeduction == other.socialSecurityDeduction &&
            taxDeduction == other.taxDeduction &&
            nightShiftStartMinutes == other.nightShiftStartMinutes &&
            nightShiftEndMinutes == other.nightShiftEndMinutes &&
            otStartMinutes == other.otStartMinutes &&
            minimumOtMinutes == other.minimumOtMinutes &&
            otRoundingPolicy == other.otRoundingPolicy &&
            defaultBreakMinutes == other.defaultBreakMinutes &&
            companyName == other.companyName &&
            employeeName == other.employeeName &&
            employeeId == other.employeeId &&
            themePreference == other.themePreference &&
            onboardingCompleted == other.onboardingCompleted;
  }

  @override
  int get hashCode => Object.hashAll([
    monthlySalary,
    dailyWage,
    workSchedule,
    normalWorkSchedule,
    customScheduleStartMinutes,
    customScheduleEndMinutes,
    payrollPolicyType,
    normalWorkHours,
    normalDayMultiplier,
    weekendDayMultiplier,
    holidayDayMultiplier,
    normalOtMultiplier,
    weekendOtMultiplier,
    holidayOtMultiplier,
    nightOtMultiplier,
    mealAllowanceDefault,
    travelAllowanceDefault,
    otherAllowanceDefault,
    socialSecurityDeduction,
    taxDeduction,
    nightShiftStartMinutes,
    nightShiftEndMinutes,
    otStartMinutes,
    minimumOtMinutes,
    otRoundingPolicy,
    defaultBreakMinutes,
    companyName,
    employeeName,
    employeeId,
    themePreference,
    onboardingCompleted,
  ]);
}

const _unset = Object();
