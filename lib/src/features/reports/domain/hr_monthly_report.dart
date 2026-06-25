class HrDailyLineItem {
  const HrDailyLineItem({
    required this.workDate,
    required this.dayTypeLabel,
    required this.checkInMinutes,
    required this.checkOutMinutes,
    required this.breakMinutes,
    required this.totalWorkHours,
    required this.normalHours,
    required this.otHours,
    required this.baseIncome,
    required this.otIncome,
    required this.allowanceIncome,
    required this.expense,
    required this.netIncome,
    required this.note,
  });

  final DateTime workDate;
  final String dayTypeLabel;
  final int checkInMinutes;
  final int checkOutMinutes;
  final int breakMinutes;
  final double totalWorkHours;
  final double normalHours;
  final double otHours;
  final double baseIncome;
  final double otIncome;
  final double allowanceIncome;
  final double expense;
  final double netIncome;
  final String note;
}

class HrMonthlyReport {
  const HrMonthlyReport({
    required this.month,
    required this.companyName,
    required this.employeeName,
    required this.employeeId,
    required this.workingDays,
    required this.totalWorkHours,
    required this.normalHours,
    required this.otHours,
    required this.grossIncome,
    required this.expenseTotal,
    required this.socialSecurityDeduction,
    required this.taxDeduction,
    required this.totalDeductions,
    required this.netIncome,
    required this.lineItems,
  });

  final DateTime month;
  final String companyName;
  final String employeeName;
  final String employeeId;
  final int workingDays;
  final double totalWorkHours;
  final double normalHours;
  final double otHours;
  final double grossIncome;
  final double expenseTotal;
  final double socialSecurityDeduction;
  final double taxDeduction;
  final double totalDeductions;
  final double netIncome;
  final List<HrDailyLineItem> lineItems;
}
