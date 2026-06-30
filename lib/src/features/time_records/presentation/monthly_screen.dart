import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../../core/widgets/friendly_states.dart';
import '../../reports/application/report_service.dart';
import '../../reports/application/report_share_service.dart';
import '../../reports/data/report_export_history_repository.dart';
import '../../reports/domain/hr_monthly_report.dart';
import '../../reports/domain/report_export.dart';
import '../../help/presentation/help_screen.dart';
import '../../hr_import/application/employee_data_transfer_service.dart';
import '../../settings/data/settings_repository.dart';
import '../../settings/domain/work_settings.dart';
import '../application/dashboard_service.dart';
import '../application/statistics_service.dart';
import '../data/work_record_repository.dart';
import '../domain/work_record.dart';

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
          if (items.isEmpty) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const FriendlyEmptyState(
                      icon: Icons.bar_chart,
                      title: 'เริ่มใช้งานเพียงวันแรก',
                      message: 'คุณก็จะเห็นรายงานรายเดือน',
                    ),
                    const SizedBox(height: 8),
                    const ContextHelpButton(
                      title: 'รายงานจะเริ่มเมื่อไหร่',
                      message:
                          'หลังจากบันทึกเวลาทำงานรายการแรก หน้านี้จะเริ่มสรุปรายได้ ชั่วโมงทำงาน OT และปุ่มส่งออก PDF / Excel ให้ทันที',
                    ),
                  ],
                ),
              ),
            );
          }

          final report = const ReportService().buildMonthlyReport(
            month: currentMonth,
            records: items,
            settings: payrollSettings,
          );
          final dashboard = const DashboardService().buildMonthlyDashboard(
            month: currentMonth,
            records: items,
            settings: payrollSettings,
          );
          final statistics = StatisticsPeriod.values.map((period) {
            return const StatisticsService().buildSummary(
              period: period,
              anchorDate: currentMonth,
              records: items,
              settings: payrollSettings,
            );
          }).toList();

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'สรุปเดือน${formatThaiMonth(currentMonth)}',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const ContextHelpButton(
                        title: 'หน้านี้สรุปอะไร',
                        message:
                            'หน้านี้รวมเวลาทำงาน OT รายได้ และยอดสุทธิของเดือนนี้ ถ้าต้องส่งต่อให้บัญชีหรือ HR ให้ใช้ปุ่ม PDF หรือ Excel ด้านล่าง',
                        tooltip: 'อธิบายสรุปรายเดือน',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _StatisticsSection(items: statistics),
                  const SizedBox(height: 16),
                  _DashboardGrid(data: dashboard),
                  const SizedBox(height: 16),
                  _DashboardCharts(data: dashboard),
                  if (report.companyName.isNotEmpty ||
                      report.employeeName.isNotEmpty ||
                      report.employeeId.isNotEmpty) ...[
                    const SizedBox(height: 16),
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 520;
                      final buttons = [
                        FilledButton.icon(
                          onPressed: () => _export(
                            context,
                            ref,
                            report,
                            ReportExportFormat.pdf,
                          ),
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('ส่งออก PDF'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _export(
                            context,
                            ref,
                            report,
                            ReportExportFormat.excel,
                          ),
                          icon: const Icon(Icons.table_chart),
                          label: const Text('ส่งออก Excel'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _exportEmployeeData(
                            context,
                            ref,
                            items,
                            payrollSettings,
                          ),
                          icon: const Icon(Icons.badge_outlined),
                          label: const Text('ส่งออกข้อมูลให้ HR'),
                        ),
                      ];

                      if (wide) {
                        return Row(
                          children: [
                            for (final button in buttons) ...[
                              Expanded(child: button),
                              if (button != buttons.last)
                                const SizedBox(width: 12),
                            ],
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buttons.first,
                          const SizedBox(height: 8),
                          buttons[1],
                          const SizedBox(height: 8),
                          buttons.last,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ประวัติการส่งออก',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
                              leading: Icon(switch (item.format) {
                                ReportExportFormat.pdf => Icons.picture_as_pdf,
                                ReportExportFormat.excel => Icons.table_chart,
                                ReportExportFormat.json => Icons.badge_outlined,
                              }),
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
                    error: (error, stackTrace) => const _InlineError(),
                    loading: () => const LinearProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => const FriendlyError(),
        loading: () => const FriendlyLoading(message: 'กำลังโหลดข้อมูล...'),
      ),
      error: (error, stackTrace) => const FriendlyError(),
      loading: () => const FriendlyLoading(message: 'กำลังโหลดข้อมูล...'),
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
        ReportExportFormat.json => throw StateError('Use HR JSON export.'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดเล็กน้อย ลองอีกครั้งครับ')),
      );
    }
  }

  Future<void> _exportEmployeeData(
    BuildContext context,
    WidgetRef ref,
    Iterable<WorkRecordEntity> records,
    WorkSettings settings,
  ) async {
    try {
      final file = const EmployeeDataTransferService().exportJson(
        records: records,
        settings: settings,
      );
      await ref
          .read(reportExportHistoryRepositoryProvider)
          .addHistory(format: file.format, fileName: file.fileName);
      await const ReportShareService().share(file);

      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ส่งออกข้อมูลให้ HR แล้ว: ${file.fileName}')),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งออกข้อมูลให้ HR ไม่สำเร็จ ลองอีกครั้งครับ'),
        ),
      );
    }
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid({required this.data});

  final MonthlyDashboardData data;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _MetricData('รายได้รวม', formatMoney(data.grossIncome), Icons.payments),
      _MetricData('รายได้สุทธิ', formatMoney(data.netIncome), Icons.savings),
      _MetricData('OT รวม', formatHours(data.totalOtHours), Icons.more_time),
      _MetricData('วันทำงาน', '${data.workingDays} วัน', Icons.work_history),
      _MetricData('ค่าใช้จ่าย', formatMoney(data.totalExpenses), Icons.receipt),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: columns == 3 ? 2.35 : 1.55,
          ),
          itemBuilder: (context, index) => _MetricCard(data: cards[index]),
        );
      },
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection({required this.items});

  final List<StatisticsSummary> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 3 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: columns == 3 ? 1.7 : 2.35,
          ),
          itemBuilder: (context, index) {
            return _StatisticsCard(summary: items[index]);
          },
        );
      },
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({required this.summary});

  final StatisticsSummary summary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    summary.period.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '${formatShortDate(summary.startDate)} - '
              '${formatShortDate(summary.endDate)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 4,
              children: [
                _MiniStat('รายได้', formatMoney(summary.grossIncome)),
                _MiniStat('สุทธิ', formatMoney(summary.netIncome)),
                _MiniStat('OT', formatHours(summary.totalOtHours)),
                _MiniStat('วัน', '${summary.workingDays}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label $value',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}

class _MetricData {
  const _MetricData(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _MetricData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(data.icon, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(data.label, style: Theme.of(context).textTheme.labelMedium),
            Text(
              data.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCharts extends StatelessWidget {
  const _DashboardCharts({required this.data});

  final MonthlyDashboardData data;

  @override
  Widget build(BuildContext context) {
    if (!data.hasChartData) {
      return const Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'ยังไม่มีข้อมูล เมื่อเริ่มบันทึกงาน ระบบจะสรุปรายได้ให้อัตโนมัติ',
          ),
        ),
      );
    }

    return Column(
      children: [
        _ChartCard(
          title: 'รายได้รายวัน',
          child: _IncomeLineChart(points: data.chartPoints),
        ),
        const SizedBox(height: 12),
        _ChartCard(
          title: 'OT รายวัน',
          child: _DailyBarChart(
            points: data.chartPoints,
            valueOf: (point) => point.otHours,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 12),
        _ChartCard(
          title: 'ค่าใช้จ่ายรายวัน',
          child: _DailyBarChart(
            points: data.chartPoints,
            valueOf: (point) => point.expense,
            color: Colors.pink,
          ),
        ),
        const SizedBox(height: 12),
        _ChartCard(
          title: 'รายได้เทียบค่าใช้จ่าย',
          child: _IncomeExpensePieChart(summary: data.incomeExpenseSummary),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 190, child: child),
          ],
        ),
      ),
    );
  }
}

class _IncomeLineChart extends StatelessWidget {
  const _IncomeLineChart({required this.points});

  final List<DailyChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final maxIncome = points.fold<double>(
      0,
      (previous, point) => point.income > previous ? point.income : previous,
    );

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: _chartMax(maxIncome),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: _titlesData(),
        lineBarsData: [
          LineChartBarData(
            spots: points
                .map((point) => FlSpot(point.day.toDouble(), point.income))
                .toList(),
            color: color,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  const _DailyBarChart({
    required this.points,
    required this.valueOf,
    required this.color,
  });

  final List<DailyChartPoint> points;
  final double Function(DailyChartPoint point) valueOf;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final maxValue = points.fold<double>(0, (previous, point) {
      final value = valueOf(point);
      return value > previous ? value : previous;
    });

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: _chartMax(maxValue),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: _titlesData(),
        barGroups: points.map((point) {
          return BarChartGroupData(
            x: point.day,
            barRods: [
              BarChartRodData(
                toY: valueOf(point),
                color: color,
                width: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _IncomeExpensePieChart extends StatelessWidget {
  const _IncomeExpensePieChart({required this.summary});

  final IncomeExpenseSummary summary;

  @override
  Widget build(BuildContext context) {
    final income = summary.income <= 0 ? 1.0 : summary.income;
    final expense = summary.expense <= 0 ? 0.0 : summary.expense;

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 42,
              sections: [
                PieChartSectionData(
                  value: income,
                  title: 'รายได้',
                  color: Theme.of(context).colorScheme.primary,
                  radius: 48,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (expense > 0)
                  PieChartSectionData(
                    value: expense,
                    title: 'จ่าย',
                    color: Colors.pink,
                    radius: 48,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 4,
          children: [
            _LegendItem(
              color: Theme.of(context).colorScheme.primary,
              label: formatMoney(summary.income),
            ),
            _LegendItem(
              color: Colors.pink,
              label: formatMoney(summary.expense),
            ),
          ],
        ),
      ],
    );
  }
}

FlTitlesData _titlesData() {
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        getTitlesWidget: (value, meta) {
          final day = value.toInt();
          if (day != 1 && day % 5 != 0) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('$day', style: const TextStyle(fontSize: 10)),
          );
        },
      ),
    ),
  );
}

double _chartMax(double value) {
  if (value <= 0) {
    return 1;
  }

  return value * 1.2;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
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

class _InlineError extends StatelessWidget {
  const _InlineError();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: const Text('เกิดข้อผิดพลาดเล็กน้อย ลองอีกครั้งครับ'),
      ),
    );
  }
}
