import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../reports/application/report_service.dart';
import '../../settings/data/settings_repository.dart';
import '../data/work_record_repository.dart';

class MonthlyScreen extends ConsumerWidget {
  const MonthlyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(workRecordsProvider);
    final settings = ref.watch(workSettingsProvider);
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
