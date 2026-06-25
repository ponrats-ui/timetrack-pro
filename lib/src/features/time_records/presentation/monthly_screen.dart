import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../reports/application/report_service.dart';
import '../../reports/application/report_share_service.dart';
import '../../reports/data/report_export_history_repository.dart';
import '../../reports/domain/hr_monthly_report.dart';
import '../../reports/domain/report_export.dart';
import '../../settings/data/settings_repository.dart';
import '../data/work_record_repository.dart';

class MonthlyScreen extends ConsumerWidget {
  const MonthlyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(workRecordsProvider);
    final settings = ref.watch(workSettingsProvider);
    final history = ref.watch(reportExportHistoryProvider);
    final currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

    return records.when(
      data: (items) => settings.when(
        data: (payrollSettings) {
          final report = const ReportService().buildMonthlyReport(
            month: currentMonth,
            records: items,
            settings: payrollSettings,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'สรุปเดือน${formatThaiMonth(currentMonth)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (report.companyName.isNotEmpty ||
                  report.employeeName.isNotEmpty ||
                  report.employeeId.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (report.companyName.isNotEmpty)
                          _SummaryRow('บริษัท', report.companyName),
                        if (report.employeeName.isNotEmpty)
                          _SummaryRow('พนักงาน', report.employeeName),
                        if (report.employeeId.isNotEmpty)
                          _SummaryRow('รหัสพนักงาน', report.employeeId),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'รายได้สุทธิ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatMoney(report.netIncome),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SummaryCard(
                rows: [
                  _SummaryRow('จำนวนวันทำงาน', '${report.workingDays} วัน'),
                  _SummaryRow(
                    'ชั่วโมงทำงานรวม',
                    formatHours(report.totalWorkHours),
                  ),
                  _SummaryRow('OT รวม', formatHours(report.otHours)),
                  _SummaryRow('รายได้รวม', formatMoney(report.grossIncome)),
                  _SummaryRow(
                    'ค่าใช้จ่ายรวม',
                    formatMoney(report.expenseTotal),
                  ),
                  _SummaryRow(
                    'ประกันสังคม',
                    formatMoney(report.socialSecurityDeduction),
                  ),
                  _SummaryRow('ภาษี', formatMoney(report.taxDeduction)),
                  _SummaryRow(
                    'รายการหักรวม',
                    formatMoney(report.totalDeductions),
                  ),
                  _SummaryRow(
                    'รายได้สุทธิ',
                    formatMoney(report.netIncome),
                    bold: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () =>
                          _export(context, ref, report, ReportExportFormat.pdf),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('ส่งออก PDF'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _export(
                        context,
                        ref,
                        report,
                        ReportExportFormat.excel,
                      ),
                      icon: const Icon(Icons.table_chart),
                      label: const Text('ส่งออก Excel'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'ประวัติการส่งออก',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              history.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('ยังไม่มีประวัติการส่งออก'),
                      ),
                    );
                  }

                  return Column(
                    children: items.map((item) {
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            item.format == ReportExportFormat.pdf
                                ? Icons.picture_as_pdf
                                : Icons.table_chart,
                          ),
                          title: Text(item.fileName),
                          subtitle: Text(
                            '${item.format.label} • '
                            '${formatThaiDate(item.exportedAt)}',
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => const LinearProgressIndicator(),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _export(
    BuildContext context,
    WidgetRef ref,
    HrMonthlyReport report,
    ReportExportFormat format,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text('กำลังสร้างรายงาน...')),
            ],
          ),
        );
      },
    );

    try {
      final reportService = const ReportService();
      final file = switch (format) {
        ReportExportFormat.pdf => await reportService.generatePdf(report),
        ReportExportFormat.excel => reportService.generateExcel(report),
      };
      await ref
          .read(reportExportHistoryRepositoryProvider)
          .addHistory(format: file.format, fileName: file.fileName);
      await const ReportShareService().share(file);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('สร้างและแชร์ ${file.fileName} เรียบร้อย')),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ส่งออกไม่สำเร็จ: $error')));
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.rows});

  final List<_SummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: rows),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
