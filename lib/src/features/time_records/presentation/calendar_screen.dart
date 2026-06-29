import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../../core/widgets/friendly_states.dart';
import '../../settings/data/settings_repository.dart';
import '../application/calendar_service.dart';
import '../data/work_record_repository.dart';
import '../domain/work_record.dart';
import 'record_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final _calendarService = const CalendarService();
  late DateTime _visibleMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(workRecordsProvider);
    final settings = ref.watch(workSettingsProvider);

    return records.when(
      data: (items) => settings.when(
        data: (payrollSettings) {
          if (items.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FriendlyEmptyState(
                  icon: Icons.calendar_month,
                  title: 'ยังไม่มีข้อมูล',
                  message: 'กด "เพิ่มรายการ"\nเพื่อเริ่มบันทึกวันทำงาน',
                  actionLabel: 'เพิ่มรายการ',
                  onAction: () => _openAddRecord(DateTime.now()),
                ),
              ],
            );
          }

          final monthData = _calendarService.groupMonth(
            month: _visibleMonth,
            records: items,
            settings: payrollSettings,
          );
          final selectedSummary = monthData.summaryFor(_selectedDate);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MonthHeader(
                month: _visibleMonth,
                onPrevious: () => _shiftMonth(-1),
                onNext: () => _shiftMonth(1),
              ),
              const SizedBox(height: 12),
              _CalendarGrid(
                visibleMonth: _visibleMonth,
                selectedDate: _selectedDate,
                monthData: monthData,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 16),
              _SelectedDayPanel(
                date: _selectedDate,
                summary: selectedSummary,
                onAdd: () => _openAddRecord(_selectedDate),
                onEdit: _openEditor,
              ),
            ],
          );
        },
        error: (error, stackTrace) => const FriendlyError(),
        loading: () => const FriendlyLoading(message: 'กำลังโหลดข้อมูล...'),
      ),
      error: (error, stackTrace) => const FriendlyError(),
      loading: () => const FriendlyLoading(message: 'กำลังโหลดข้อมูล...'),
    );
  }

  void _shiftMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
      _selectedDate = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    });
  }

  void _openAddRecord(DateTime date) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RecordScreen(initialDate: date),
      ),
    );
  }

  void _openEditor(WorkRecordEntity record) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: RecordScreen(
            initialRecord: record,
            onSaved: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'เดือนก่อนหน้า',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            formatThaiMonth(month),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        IconButton(
          tooltip: 'เดือนถัดไป',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.visibleMonth,
    required this.selectedDate,
    required this.monthData,
    required this.onDateSelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final CalendarMonthData monthData;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    const weekdays = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
    final daysInMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;
    final leadingBlanks = firstDay.weekday - 1;
    final cellCount = leadingBlanks + daysInMonth;
    final totalCells = ((cellCount / 7).ceil() * 7).clamp(35, 42).toInt();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.25,
              children: weekdays.map((day) {
                return Center(
                  child: Text(
                    day,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }).toList(),
            ),
            GridView.builder(
              itemCount: totalCells,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                final dayNumber = index - leadingBlanks + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox.shrink();
                }

                final date = DateTime(
                  visibleMonth.year,
                  visibleMonth.month,
                  dayNumber,
                );
                final summary = monthData.summaryFor(date);
                return _CalendarDayCell(
                  date: date,
                  selected: _isSameDate(date, selectedDate),
                  summary: summary,
                  onTap: () => onDateSelected(date),
                );
              },
            ),
            const SizedBox(height: 8),
            const _MarkerLegend(),
          ],
        ),
      ),
    );
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.selected,
    required this.summary,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final CalendarDaySummary? summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = selected
        ? colorScheme.primary
        : summary?.hasRecords ?? false
        ? colorScheme.primaryContainer.withValues(alpha: 0.36)
        : Colors.transparent;
    final foreground = selected ? colorScheme.onPrimary : colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
            ),
            if (summary?.hasOt ?? false)
              Text(
                'OT ${summary!.totalOtHours.toStringAsFixed(1)}',
                style: TextStyle(color: foreground, fontSize: 8),
              )
            else
              const SizedBox(height: 2),
            if (summary?.hasRecords ?? false)
              FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatMoney(summary!.totalIncome),
                      style: TextStyle(color: foreground, fontSize: 8),
                    ),
                    if (summary!.hasExpense)
                      const Icon(
                        Icons.receipt_long,
                        size: 9,
                        color: Colors.pink,
                      ),
                  ],
                ),
              ),
            _MarkerDots(summary: summary, selected: selected),
          ],
        ),
      ),
    );
  }
}

class _MarkerDots extends StatelessWidget {
  const _MarkerDots({required this.summary, required this.selected});

  final CalendarDaySummary? summary;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final markers = <Color>[];
    if (summary case final summary?) {
      if (summary.hasNormal) markers.add(Colors.teal);
      if (summary.hasWeekend) markers.add(Colors.indigo);
      if (summary.hasHoliday) markers.add(Colors.red);
      if (summary.hasOt) markers.add(Colors.orange);
      if (summary.hasExpense) markers.add(Colors.pink);
    }

    if (markers.isEmpty) {
      return const SizedBox(height: 6);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 2,
      runSpacing: 2,
      children: markers.take(5).map((color) {
        return Container(
          width: selected ? 5 : 6,
          height: selected ? 5 : 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      }).toList(),
    );
  }
}

class _MarkerLegend extends StatelessWidget {
  const _MarkerLegend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 10,
      runSpacing: 6,
      children: [
        _LegendItem(color: Colors.teal, label: 'วันปกติ'),
        _LegendItem(color: Colors.indigo, label: 'เสาร์-อาทิตย์'),
        _LegendItem(color: Colors.red, label: 'วันหยุด'),
        _LegendItem(color: Colors.orange, label: 'OT'),
        _LegendItem(color: Colors.pink, label: 'ค่าใช้จ่าย'),
      ],
    );
  }
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _SelectedDayPanel extends StatelessWidget {
  const _SelectedDayPanel({
    required this.date,
    required this.summary,
    required this.onAdd,
    required this.onEdit,
  });

  final DateTime date;
  final CalendarDaySummary? summary;
  final VoidCallback onAdd;
  final ValueChanged<WorkRecordEntity> onEdit;

  @override
  Widget build(BuildContext context) {
    final hasRecords = summary?.hasRecords ?? false;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatThaiDate(date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('เพิ่ม'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!hasRecords)
              const _EmptyDay()
            else ...[
              _DayTotals(summary: summary!),
              const SizedBox(height: 12),
              ...summary!.records.map((record) {
                return _RecordTile(
                  record: record,
                  onEdit: () => onEdit(record),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _DayTotals extends StatelessWidget {
  const _DayTotals({required this.summary});

  final CalendarDaySummary summary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _TotalChip(
          label: 'ชั่วโมงงาน',
          value: formatHours(summary.totalWorkHours),
        ),
        _TotalChip(label: 'OT', value: formatHours(summary.totalOtHours)),
        _TotalChip(label: 'รายได้', value: formatMoney(summary.totalIncome)),
        _TotalChip(
          label: 'ค่าใช้จ่าย',
          value: formatMoney(summary.totalExpense),
        ),
      ],
    );
  }
}

class _TotalChip extends StatelessWidget {
  const _TotalChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record, required this.onEdit});

  final WorkRecordEntity record;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.work_history),
      title: Text(
        '${formatClock(record.checkInMinutes)} - '
        '${formatClock(record.checkOutMinutes)}',
      ),
      subtitle: Text(
        [
          record.dayType.label,
          if (record.note.isNotEmpty) record.note,
        ].join(' • '),
      ),
      trailing: IconButton(
        tooltip: 'แก้ไข',
        onPressed: onEdit,
        icon: const Icon(Icons.edit),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text('ยังไม่มีข้อมูล\nกด "เพิ่มรายการ" เพื่อเริ่มบันทึกวันทำงาน'),
    );
  }
}
