import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/thai_formatters.dart';
import '../domain/hr_monthly_report.dart';
import '../domain/report_export.dart';

class PdfReportGenerator {
  const PdfReportGenerator();

  Future<ReportExportFile> generate(HrMonthlyReport report) async {
    final fontData = await rootBundle.load('assets/fonts/tahoma.ttf');
    final thaiFont = pw.Font.ttf(fontData);
    final document = pw.Document(
      theme: pw.ThemeData.withFont(base: thaiFont, bold: thaiFont),
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _header(report),
          pw.SizedBox(height: 16),
          _identity(report),
          pw.SizedBox(height: 16),
          _summary(report),
          pw.SizedBox(height: 16),
          _dailyTable(report),
          pw.SizedBox(height: 16),
          _incomeAndDeductions(report),
          pw.SizedBox(height: 40),
          _signatureSection(),
          pw.SizedBox(height: 24),
          _footer(),
        ],
      ),
    );

    return ReportExportFile(
      format: ReportExportFormat.pdf,
      fileName: reportFileName(report.month, ReportExportFormat.pdf),
      mimeType: 'application/pdf',
      bytes: await document.save(),
    );
  }

  pw.Widget _header(HrMonthlyReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'รายงานเวลาทำงานรายเดือน',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('ประจำเดือน ${formatThaiMonth(report.month)}'),
      ],
    );
  }

  pw.Widget _identity(HrMonthlyReport report) {
    return pw.TableHelper.fromTextArray(
      headers: const ['ข้อมูล', 'รายละเอียด'],
      data: [
        ['บริษัท', report.companyName],
        ['พนักงาน', report.employeeName],
        ['รหัสพนักงาน', report.employeeId],
      ],
      headerDecoration: const pw.BoxDecoration(color: PdfColors.teal100),
      cellAlignment: pw.Alignment.centerLeft,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    );
  }

  pw.Widget _summary(HrMonthlyReport report) {
    return pw.TableHelper.fromTextArray(
      headers: const ['สรุปรายเดือน', 'จำนวน'],
      data: [
        ['วันทำงาน', '${report.workingDays} วัน'],
        ['ชั่วโมงทำงานรวม', formatHours(report.totalWorkHours)],
        ['ชั่วโมงปกติ', formatHours(report.normalHours)],
        ['OT รวม', formatHours(report.otHours)],
      ],
      headerDecoration: const pw.BoxDecoration(color: PdfColors.teal100),
      cellAlignment: pw.Alignment.centerLeft,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    );
  }

  pw.Widget _dailyTable(HrMonthlyReport report) {
    return pw.TableHelper.fromTextArray(
      headers: const [
        'วันที่',
        'ประเภท',
        'เข้า',
        'ออก',
        'พัก',
        'ชม.',
        'OT',
        'สุทธิ',
      ],
      data: report.lineItems.map((item) {
        return [
          formatShortDate(item.workDate),
          item.dayTypeLabel,
          formatClock(item.checkInMinutes),
          formatClock(item.checkOutMinutes),
          '${item.breakMinutes}',
          _number(item.totalWorkHours),
          _number(item.otHours),
          formatMoney(item.netIncome),
        ];
      }).toList(),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.teal100),
      cellStyle: const pw.TextStyle(fontSize: 8),
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  pw.Widget _incomeAndDeductions(HrMonthlyReport report) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.TableHelper.fromTextArray(
            headers: const ['รายได้', 'จำนวน'],
            data: [
              ['รายได้รวม', formatMoney(report.grossIncome)],
              ['ค่าใช้จ่าย', formatMoney(report.expenseTotal)],
            ],
            headerDecoration: const pw.BoxDecoration(color: PdfColors.teal100),
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(
          child: pw.TableHelper.fromTextArray(
            headers: const ['รายการหัก', 'จำนวน'],
            data: [
              ['ประกันสังคม', formatMoney(report.socialSecurityDeduction)],
              ['ภาษี', formatMoney(report.taxDeduction)],
              ['หักรวม', formatMoney(report.totalDeductions)],
              ['รายได้สุทธิ', formatMoney(report.netIncome)],
            ],
            headerDecoration: const pw.BoxDecoration(color: PdfColors.teal100),
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    );
  }

  pw.Widget _signatureSection() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _signatureBox('พนักงาน'),
        _signatureBox('ฝ่ายบุคคล'),
        _signatureBox('ผู้อนุมัติ'),
      ],
    );
  }

  pw.Widget _signatureBox(String label) {
    return pw.Column(
      children: [
        pw.Container(width: 120, height: 1, color: PdfColors.grey600),
        pw.SizedBox(height: 6),
        pw.Text(label),
        pw.SizedBox(height: 20),
        pw.Text('วันที่ ____ / ____ / ______'),
      ],
    );
  }

  pw.Widget _footer() {
    return pw.Align(
      alignment: pw.Alignment.center,
      child: pw.Text(
        AppConstants.generatedByFooter,
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
      ),
    );
  }
}

String reportFileName(DateTime month, ReportExportFormat format) {
  final year = month.year.toString().padLeft(4, '0');
  final monthText = month.month.toString().padLeft(2, '0');
  return 'timetrack_hr_report_${year}_$monthText.${format.extension}';
}

String _number(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}
