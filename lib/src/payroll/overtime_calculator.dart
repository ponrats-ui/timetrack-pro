class OvertimeCalculator {
  const OvertimeCalculator();

  double overtimeHours({
    required double totalWorkHours,
    required double normalHours,
    required double extraOtHours,
  }) {
    final scheduledOt = (totalWorkHours - normalHours).clamp(
      0,
      double.infinity,
    );
    return scheduledOt + extraOtHours;
  }
}
