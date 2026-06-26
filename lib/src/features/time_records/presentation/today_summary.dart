import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../settings/data/settings_repository.dart';
import '../application/work_calculator.dart';
import '../data/work_record_repository.dart';

class TodaySummary extends ConsumerWidget {
  const TodaySummary({
    super.key,
    required this.onAddRecord,
    required this.onViewMonth,
    required this.onExport,
  });

  final VoidCallback onAddRecord;
  final VoidCallback onViewMonth;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(workRecordsProvider);
    final settings = ref.watch(workSettingsProvider);

    return records.when(
      loading: () => const _TodayLoading(),
      error: (_, _) => const _TodayError(),
      data: (items) => settings.when(
        loading: () => const _TodayLoading(),
        error: (_, _) => const _TodayError(),
        data: (payrollSettings) {
          final now = DateTime.now();
          final todayItems = items.where(
            (record) => _sameDay(record.workDate, now),
          );
          final monthlyItems = items.where(
            (record) =>
                record.workDate.year == now.year &&
                record.workDate.month == now.month,
          );
          const calculator = WorkCalculator();
          final todayCalculations = todayItems
              .map(
                (record) => calculator.calculateDaily(record, payrollSettings),
              )
              .toList();
          final monthCalculation = calculator.calculateMonthly(
            monthlyItems,
            payrollSettings,
          );
          final latest = todayItems.isEmpty
              ? null
              : todayItems.reduce(
                  (current, next) => current.updatedAt.isAfter(next.updatedAt)
                      ? current
                      : next,
                );

          final workHours = todayCalculations.fold<double>(
            0,
            (total, item) => total + item.totalWorkHours,
          );
          final otHours = todayCalculations.fold<double>(
            0,
            (total, item) => total + item.otHours,
          );
          final income = todayCalculations.fold<double>(
            0,
            (total, item) => total + item.dailyIncome,
          );

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'วันนี้ ${formatThaiDate(now)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  latest == null
                      ? 'ยังไม่มีบันทึกเวลาทำงาน'
                      : '${formatClock(latest.checkInMinutes)} - ${formatClock(latest.checkOutMinutes)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 450;
                    final metrics = [
                      _TodayMetric(
                        'ทำงาน',
                        formatHours(workHours),
                        Icons.schedule,
                      ),
                      _TodayMetric('OT', formatHours(otHours), Icons.more_time),
                      _TodayMetric(
                        'รายได้',
                        formatMoney(income),
                        Icons.payments,
                      ),
                      _TodayMetric(
                        'เดือนนี้',
                        formatMoney(monthCalculation.grossIncome),
                        Icons.calendar_month,
                      ),
                    ];
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: metrics.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: wide ? 4 : 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: wide ? 1.15 : 1.65,
                      ),
                      itemBuilder: (context, index) =>
                          _TodayMetricTile(metric: metrics[index]),
                    );
                  },
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final buttons = [
                      FilledButton.tonalIcon(
                        onPressed: onAddRecord,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('เพิ่มรายการ'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: onViewMonth,
                        icon: const Icon(Icons.bar_chart),
                        label: const Text('ดูรายเดือน'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: onExport,
                        icon: const Icon(Icons.ios_share),
                        label: const Text('ส่งออก'),
                      ),
                    ];
                    if (constraints.maxWidth >= 520) {
                      return Row(
                        children: [
                          for (final button in buttons) ...[
                            Expanded(child: button),
                            if (button != buttons.last)
                              const SizedBox(width: 8),
                          ],
                        ],
                      );
                    }
                    return Wrap(spacing: 8, runSpacing: 8, children: buttons);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static bool _sameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _TodayMetric {
  const _TodayMetric(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

class _TodayMetricTile extends StatelessWidget {
  const _TodayMetricTile({required this.metric});

  final _TodayMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(metric.icon, size: 18, color: Colors.white70),
          Text(metric.label, style: const TextStyle(color: Colors.white70)),
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayLoading extends StatelessWidget {
  const _TodayLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _TodayError extends StatelessWidget {
  const _TodayError();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
