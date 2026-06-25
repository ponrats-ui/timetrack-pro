class WorkSettings {
  const WorkSettings({
    required this.monthlySalary,
    required this.dailyWage,
    required this.normalWorkHours,
    required this.otRate1,
    required this.otRate15,
    required this.otRate2,
    required this.otRate3,
    required this.socialSecurityDeduction,
    required this.defaultBreakMinutes,
  });

  const WorkSettings.defaults()
    : monthlySalary = 15000,
      dailyWage = 500,
      normalWorkHours = 8,
      otRate1 = 1,
      otRate15 = 1.5,
      otRate2 = 2,
      otRate3 = 3,
      socialSecurityDeduction = 750,
      defaultBreakMinutes = 60;

  final double monthlySalary;
  final double dailyWage;
  final double normalWorkHours;
  final double otRate1;
  final double otRate15;
  final double otRate2;
  final double otRate3;
  final double socialSecurityDeduction;
  final int defaultBreakMinutes;

  double get hourlyWage => dailyWage / normalWorkHours;
}
