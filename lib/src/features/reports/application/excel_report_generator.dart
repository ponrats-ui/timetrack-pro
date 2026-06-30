import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/thai_formatters.dart';
import '../domain/hr_monthly_report.dart';
import '../domain/report_export.dart';
import 'pdf_report_generator.dart';

class ExcelReportGenerator {
  const ExcelReportGenerator();

  ReportExportFile generate(HrMonthlyReport report) {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Summary');
    _buildSummarySheet(excel['Summary'], report);
    _buildDailySheet(excel['Daily Records'], report);
    _buildSettingsSheet(excel['Settings'], report);

    final bytes = excel.encode();
    if (bytes == null) {
      throw StateError('Unable to encode Excel report.');
    }

    return ReportExportFile(
      format: ReportExportFormat.excel,
      fileName: reportFileName(report.month, ReportExportFormat.excel),
      mimeType:
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      bytes: Uint8List.fromList(bytes),
    );
  }

  void _buildSummarySheet(Sheet sheet, HrMonthlyReport report) {
    _appendRows(sheet, [
      ['รายงานเวลาทำงานรายเดือน', ''],
      ['เดือน', formatThaiMonth(report.month)],
      ['บริษัท', report.companyName],
      ['พนักงาน', report.employeeName],
      ['รหัสพนักงาน', report.employeeId],
      ['วันทำงาน', report.workingDays],
      ['ชั่วโมงทำงานรวม', report.totalWorkHours],
      ['ชั่วโมงปกติ', report.normalHours],
      ['OT รวม', report.otHours],
      ['รายได้รวม', report.grossIncome],
      ['ค่าใช้จ่ายรวม', report.expenseTotal],
      ['ประกันสังคม', report.socialSecurityDeduction],
      ['ภาษี', report.taxDeduction],
      ['รายการหักรวม', report.totalDeductions],
      ['รายได้สุทธิ', report.netIncome],
      ['', ''],
      ..._ownershipRows(),
    ]);
  }

  void _buildDailySheet(Sheet sheet, HrMonthlyReport report) {
    _appendRows(sheet, [
      [
        'วันที่',
        'ประเภทวัน',
        'เวลาเข้า',
        'เวลาออก',
        'พัก (นาที)',
        'ชั่วโมงรวม',
        'ชั่วโมงปกติ',
        'OT',
        'ค่าแรงปกติ',
        'รายได้ OT',
        'เบี้ยเลี้ยง',
        'ค่าใช้จ่าย',
        'สุทธิ',
        'หมายเหตุ',
      ],
      ...report.lineItems.map((item) {
        return [
          formatShortDate(item.workDate),
          item.dayTypeLabel,
          formatClock(item.checkInMinutes),
          formatClock(item.checkOutMinutes),
          item.breakMinutes,
          item.totalWorkHours,
          item.normalHours,
          item.otHours,
          item.baseIncome,
          item.otIncome,
          item.allowanceIncome,
          item.expense,
          item.netIncome,
          item.note,
        ];
      }),
      [AppConstants.generatedByTitle],
    ]);
  }

  void _buildSettingsSheet(Sheet sheet, HrMonthlyReport report) {
    _appendRows(sheet, [
      ['ตั้งค่าที่ใช้ในรายงาน', ''],
      ['บริษัท', report.companyName],
      ['พนักงาน', report.employeeName],
      ['รหัสพนักงาน', report.employeeId],
      ['ประกันสังคม', report.socialSecurityDeduction],
      ['ภาษี', report.taxDeduction],
      ['รายการหักรวม', report.totalDeductions],
      ['', ''],
      ..._ownershipRows(),
    ]);
  }

  List<List<Object?>> _ownershipRows() {
    return const [
      [AppConstants.generatedByTitle, ''],
      ['Part of ${AppConstants.productFamily}', ''],
      [AppConstants.copyright, ''],
    ];
  }

  void _appendRows(Sheet sheet, Iterable<List<Object?>> rows) {
    for (final row in rows) {
      sheet.appendRow(row.map(_cell).toList());
    }
  }

  CellValue _cell(Object? value) {
    return switch (value) {
      null => TextCellValue(''),
      int value => IntCellValue(value),
      double value => DoubleCellValue(value),
      bool value => BoolCellValue(value),
      DateTime value => DateTimeCellValue(
        year: value.year,
        month: value.month,
        day: value.day,
        hour: value.hour,
        minute: value.minute,
      ),
      _ => TextCellValue(value.toString()),
    };
  }
}
