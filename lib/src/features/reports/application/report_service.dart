import '../../settings/domain/work_settings.dart';
import '../../time_records/application/work_calculator.dart';
import '../../time_records/domain/work_record.dart';
import '../domain/report_export.dart';
import 'excel_report_generator.dart';
import 'pdf_report_generator.dart';
import '../domain/hr_monthly_report.dart';

class ReportService {
  const ReportService({
    this.calculator = const WorkCalculator(),
    this.pdfReportGenerator = const PdfReportGenerator(),
    this.excelReportGenerator = const ExcelReportGenerator(),
  });

  final WorkCalculator calculator;
  final PdfReportGenerator pdfReportGenerator;
  final ExcelReportGenerator excelReportGenerator;

  HrMonthlyReport buildMonthlyReport({
    required DateTime month,
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
  }) {
    final normalizedMonth = DateTime(month.year, month.month);
    final monthlyRecords = records.where((record) {
      return record.workDate.year == normalizedMonth.year &&
          record.workDate.month == normalizedMonth.month;
    }).toList()..sort((a, b) => a.workDate.compareTo(b.workDate));

    return buildPeriodReport(
      month: normalizedMonth,
      records: monthlyRecords,
      settings: settings,
    );
  }

  HrMonthlyReport buildPeriodReport({
    required DateTime month,
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
  }) {
    final normalizedMonth = DateTime(month.year, month.month);
    final periodRecords = records.toList()
      ..sort((a, b) => a.workDate.compareTo(b.workDate));

    final summary = calculator.calculateMonthly(periodRecords, settings);
    final lineItems = periodRecords.map((record) {
      final daily = calculator.calculateDaily(record, settings);
      return HrDailyLineItem(
        workDate: record.workDate,
        dayTypeLabel: record.dayType.label,
        checkInMinutes: record.checkInMinutes,
        checkOutMinutes: record.checkOutMinutes,
        breakMinutes: record.breakMinutes,
        totalWorkHours: daily.totalWorkHours,
        normalHours: daily.normalHours,
        otHours: daily.otHours,
        baseIncome: daily.baseIncome,
        otIncome: daily.otIncome,
        allowanceIncome: daily.allowanceIncome,
        expense: record.expense,
        netIncome: daily.netIncome,
        note: record.note,
      );
    }).toList();

    return HrMonthlyReport(
      month: normalizedMonth,
      companyName: settings.companyName,
      employeeName: settings.employeeName,
      employeeId: settings.employeeId,
      workingDays: summary.workingDays,
      totalWorkHours: summary.totalWorkHours,
      normalHours: summary.normalHours,
      otHours: summary.otHours,
      grossIncome: summary.grossIncome,
      expenseTotal: summary.expenseTotal,
      socialSecurityDeduction: summary.socialSecurityDeduction,
      taxDeduction: summary.taxDeduction,
      totalDeductions: summary.totalDeductions,
      netIncome: summary.netIncome,
      lineItems: lineItems,
    );
  }

  Future<ReportExportFile> generatePdf(HrMonthlyReport report) {
    return pdfReportGenerator.generate(report);
  }

  ReportExportFile generateExcel(HrMonthlyReport report) {
    return excelReportGenerator.generate(report);
  }
}
