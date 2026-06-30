import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetrack_pro/src/core/constants/app_constants.dart';
import 'package:timetrack_pro/src/features/reports/application/excel_report_generator.dart';
import 'package:timetrack_pro/src/features/reports/application/pdf_report_generator.dart';
import 'package:timetrack_pro/src/features/reports/domain/hr_monthly_report.dart';
import 'package:timetrack_pro/src/features/reports/domain/report_export.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generates professional PDF report bytes', () async {
    final file = await const PdfReportGenerator().generate(_report());

    expect(file.format, ReportExportFormat.pdf);
    expect(file.fileName, 'timetrack_hr_report_2026_06.pdf');
    expect(file.mimeType, 'application/pdf');
    expect(String.fromCharCodes(file.bytes.take(4)), '%PDF');
  });

  test('generates Excel report with summary, daily, and settings sheets', () {
    final file = const ExcelReportGenerator().generate(_report());
    final workbook = Excel.decodeBytes(file.bytes);

    expect(file.format, ReportExportFormat.excel);
    expect(file.fileName, 'timetrack_hr_report_2026_06.xlsx');
    expect(
      workbook.tables.keys,
      containsAll(['Summary', 'Daily Records', 'Settings']),
    );
    expect(
      _sheetText(workbook['Summary']),
      contains(AppConstants.generatedByTitle),
    );
    expect(
      _sheetText(workbook['Summary']),
      contains('Part of ${AppConstants.productFamily}'),
    );
    expect(_sheetText(workbook['Settings']), contains(AppConstants.copyright));
  });
}

List<String> _sheetText(Sheet sheet) {
  return sheet.rows
      .expand((row) => row)
      .where((cell) => cell?.value != null)
      .map((cell) => cell!.value.toString())
      .toList();
}

HrMonthlyReport _report() {
  return HrMonthlyReport(
    month: DateTime(2026, 6),
    companyName: 'ACME Logistics',
    employeeName: 'Somchai Driver',
    employeeId: 'EMP-007',
    workingDays: 1,
    totalWorkHours: 8,
    normalHours: 8,
    otHours: 0,
    grossIncome: 550,
    expenseTotal: 20,
    socialSecurityDeduction: 50,
    taxDeduction: 30,
    totalDeductions: 80,
    netIncome: 450,
    lineItems: [
      HrDailyLineItem(
        workDate: DateTime(2026, 6, 1),
        dayTypeLabel: 'วันปกติ',
        checkInMinutes: 8 * 60,
        checkOutMinutes: 17 * 60,
        breakMinutes: 60,
        totalWorkHours: 8,
        normalHours: 8,
        otHours: 0,
        baseIncome: 500,
        otIncome: 0,
        allowanceIncome: 50,
        expense: 20,
        netIncome: 530,
        note: 'ทดสอบ',
      ),
    ],
  );
}
