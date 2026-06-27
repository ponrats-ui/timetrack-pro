import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../settings/data/settings_repository.dart';
import '../../settings/domain/work_settings.dart';
import '../application/work_calculator.dart';
import '../data/work_record_repository.dart';
import '../domain/work_record.dart';

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
                _QuickRecordActions(
                  latest: latest,
                  settings: payrollSettings,
                  onSaved: (message) => _showSnackBar(context, message),
                ),
                const SizedBox(height: 12),
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _QuickRecordActions extends ConsumerWidget {
  const _QuickRecordActions({
    required this.latest,
    required this.settings,
    required this.onSaved,
  });

  final WorkRecordEntity? latest;
  final WorkSettings settings;
  final ValueChanged<String> onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () => _checkIn(ref),
            icon: const Icon(Icons.login),
            label: const Text('เข้างาน'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: latest == null ? null : () => _checkOut(ref, latest!),
            icon: const Icon(Icons.logout),
            label: const Text('ออกงาน'),
          ),
        ),
      ],
    );
  }

  Future<void> _checkIn(WidgetRef ref) async {
    final now = DateTime.now();
    final minutes = (now.hour * 60) + now.minute;
    await ref
        .read(workRecordRepositoryProvider)
        .saveRecord(
          WorkRecordEntity(
            id: 'quick-${now.microsecondsSinceEpoch}',
            workDate: DateTime(now.year, now.month, now.day),
            checkInMinutes: minutes,
            checkOutMinutes: minutes,
            breakMinutes: 0,
            dayType: DayType.normal,
            extraOtHours: 0,
            travelAllowance: settings.travelAllowanceDefault,
            specialAllowance: 0,
            expense: 0,
            note: 'บันทึกด่วน: เข้างาน',
            createdAt: now,
            updatedAt: now,
          ),
        );
    onSaved('บันทึกเวลาเข้างานแล้ว');
  }

  Future<void> _checkOut(WidgetRef ref, WorkRecordEntity record) async {
    final now = DateTime.now();
    final minutes = (now.hour * 60) + now.minute;
    final breakMinutes = record.breakMinutes == 0
        ? settings.defaultBreakMinutes
        : record.breakMinutes;
    await ref
        .read(workRecordRepositoryProvider)
        .saveRecord(
          record.copyWith(
            checkOutMinutes: minutes,
            breakMinutes: breakMinutes,
            note: record.note.isEmpty ? 'บันทึกด่วน: ออกงาน' : record.note,
            updatedAt: now,
          ),
        );
    onSaved('บันทึกเวลาออกงานแล้ว');
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
