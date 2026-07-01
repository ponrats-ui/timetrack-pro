import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../../core/widgets/friendly_states.dart';
import '../../settings/data/settings_repository.dart';
import '../application/record_query_service.dart';
import '../data/work_record_repository.dart';
import '../domain/work_record.dart';
import 'record_screen.dart';

enum _RecordAction { edit, delete }

class RecordListScreen extends ConsumerStatefulWidget {
  const RecordListScreen({super.key});

  @override
  ConsumerState<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends ConsumerState<RecordListScreen> {
  final _searchController = TextEditingController();
  final _queryService = const RecordQueryService();
  DateTime? _selectedDate;
  DateTime? _selectedMonth;
  RecordPeriod _period = RecordPeriod.month;
  Set<RecordFilter> _filters = {};
  RecordSortOption _sortOption = RecordSortOption.newest;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(workRecordsProvider);
    final settings = ref.watch(workSettingsProvider);

    return records.when(
      data: (items) => settings.when(
        data: (payrollSettings) {
          final criteria = RecordSearchCriteria(
            query: _searchController.text,
            date: _selectedDate,
            month: _selectedMonth,
            period: _period,
            anchorDate: DateTime.now(),
            filters: _filters,
            sortOption: _sortOption,
          );
          final visibleItems = _queryService.apply(
            records: items,
            settings: payrollSettings,
            criteria: criteria,
          );

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SearchAndFilterPanel(
                    controller: _searchController,
                    selectedDate: _selectedDate,
                    selectedMonth: _selectedMonth,
                    period: _period,
                    filters: _filters,
                    sortOption: _sortOption,
                    onSearchChanged: (_) => setState(() {}),
                    onPeriodChanged: (value) {
                      setState(() {
                        _period = value;
                        _selectedDate = null;
                        _selectedMonth = null;
                      });
                    },
                    onPickDate: _pickDate,
                    onPickMonth: _pickMonth,
                    onClearDate: () => setState(() => _selectedDate = null),
                    onClearMonth: () => setState(() => _selectedMonth = null),
                    onClearAll: _clearSearch,
                    onToggleFilter: _toggleFilter,
                    onSortChanged: (value) {
                      setState(() => _sortOption = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    _EmptyState(onAddFirst: () => _openEditor(context, null))
                  else if (visibleItems.isEmpty)
                    const _NoResultsState()
                  else
                    ..._buildGroupedRecordCards(context, ref, visibleItems),
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _period = RecordPeriod.all;
      });
    }
  }

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'เลือกเดือน',
      fieldLabelText: 'เดือน',
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
        _period = RecordPeriod.all;
      });
    }
  }

  void _toggleFilter(RecordFilter filter, bool selected) {
    setState(() {
      final nextFilters = {..._filters};
      if (selected) {
        nextFilters.add(filter);
      } else {
        nextFilters.remove(filter);
      }
      _filters = nextFilters;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _selectedDate = null;
      _selectedMonth = null;
      _period = RecordPeriod.month;
      _filters = {};
      _sortOption = RecordSortOption.newest;
    });
  }

  List<Widget> _buildGroupedRecordCards(
    BuildContext context,
    WidgetRef ref,
    List<RecordListItem> visibleItems,
  ) {
    final widgets = <Widget>[];
    String? currentMonth;
    for (final item in visibleItems) {
      final monthLabel = formatThaiMonth(item.record.workDate);
      if (monthLabel != currentMonth) {
        currentMonth = monthLabel;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              monthLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        );
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _RecordCard(
            item: item,
            onOpenActions: () => _showRecordActions(context, ref, item.record),
            onDelete: () => _confirmDelete(context, ref, item.record),
          ),
        ),
      );
    }
    return widgets;
  }

  void _openEditor(BuildContext context, WorkRecordEntity? record) {
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

  Future<void> _showRecordActions(
    BuildContext context,
    WidgetRef ref,
    WorkRecordEntity record,
  ) async {
    final action = await showModalBottomSheet<_RecordAction>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('แก้ไขรายการ'),
                  onTap: () => Navigator.of(context).pop(_RecordAction.edit),
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'ลบรายการ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(_RecordAction.delete),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!context.mounted || action == null) {
      return;
    }

    switch (action) {
      case _RecordAction.edit:
        _openEditor(context, record);
      case _RecordAction.delete:
        await _confirmDelete(context, ref, record);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    WorkRecordEntity record,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text(
            'ต้องการลบบันทึกวันที่ ${formatThaiDate(record.workDate)} หรือไม่',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('ยกเลิก'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete),
              label: const Text('ลบ'),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      await ref.read(workRecordRepositoryProvider).deleteRecord(record.id);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ลบรายการสำเร็จ'),
          action: SnackBarAction(label: 'ปิด', onPressed: () {}),
        ),
      );
    }
  }
}

class _SearchAndFilterPanel extends StatelessWidget {
  const _SearchAndFilterPanel({
    required this.controller,
    required this.selectedDate,
    required this.selectedMonth,
    required this.period,
    required this.filters,
    required this.sortOption,
    required this.onSearchChanged,
    required this.onPeriodChanged,
    required this.onPickDate,
    required this.onPickMonth,
    required this.onClearDate,
    required this.onClearMonth,
    required this.onClearAll,
    required this.onToggleFilter,
    required this.onSortChanged,
  });

  final TextEditingController controller;
  final DateTime? selectedDate;
  final DateTime? selectedMonth;
  final RecordPeriod period;
  final Set<RecordFilter> filters;
  final RecordSortOption sortOption;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<RecordPeriod> onPeriodChanged;
  final VoidCallback onPickDate;
  final VoidCallback onPickMonth;
  final VoidCallback onClearDate;
  final VoidCallback onClearMonth;
  final VoidCallback onClearAll;
  final void Function(RecordFilter filter, bool selected) onToggleFilter;
  final ValueChanged<RecordSortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                labelText: 'ค้นหาวันที่ เดือน หรือหมายเหตุ',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'ล้างคำค้นหา',
                        onPressed: () {
                          controller.clear();
                          onSearchChanged('');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<RecordPeriod>(
              segments: const [
                ButtonSegment(value: RecordPeriod.all, label: Text('ทั้งหมด')),
                ButtonSegment(value: RecordPeriod.today, label: Text('วันนี้')),
                ButtonSegment(
                  value: RecordPeriod.week,
                  label: Text('สัปดาห์นี้'),
                ),
                ButtonSegment(
                  value: RecordPeriod.month,
                  label: Text('เดือนนี้'),
                ),
              ],
              selected: {period},
              onSelectionChanged: (values) => onPeriodChanged(values.first),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                InputChip(
                  avatar: const Icon(Icons.event, size: 18),
                  label: Text(
                    selectedDate == null
                        ? 'เลือกวันที่'
                        : formatShortDate(selectedDate!),
                  ),
                  selected: selectedDate != null,
                  onPressed: onPickDate,
                  onDeleted: selectedDate == null ? null : onClearDate,
                ),
                InputChip(
                  avatar: const Icon(Icons.calendar_month, size: 18),
                  label: Text(
                    selectedMonth == null
                        ? 'เลือกเดือน'
                        : formatThaiMonth(selectedMonth!),
                  ),
                  selected: selectedMonth != null,
                  onPressed: onPickMonth,
                  onDeleted: selectedMonth == null ? null : onClearMonth,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RecordFilter.values.map((filter) {
                return FilterChip(
                  label: Text(filter.label),
                  selected: filters.contains(filter),
                  onSelected: (selected) => onToggleFilter(filter, selected),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<RecordSortOption>(
                    initialValue: sortOption,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'เรียงลำดับ',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.sort),
                    ),
                    items: RecordSortOption.values.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(
                          option.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onSortChanged(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  tooltip: 'ล้างตัวกรอง',
                  onPressed: onClearAll,
                  icon: const Icon(Icons.filter_alt_off),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.item,
    required this.onOpenActions,
    required this.onDelete,
  });

  final RecordListItem item;
  final VoidCallback onOpenActions;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final record = item.record;
    final calculation = item.calculation;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            child: const Icon(Icons.work_history),
          ),
          title: Text(formatShortDate(record.workDate)),
          subtitle: Text(
            '${formatClock(record.checkInMinutes)} - '
            '${formatClock(record.checkOutMinutes)} • ${record.dayType.label}'
            '${record.note.isEmpty ? '' : '\n${record.note}'}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    formatMoney(calculation.dailyIncome),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  'OT ${formatHours(calculation.otHours)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          onTap: onOpenActions,
          onLongPress: onDelete,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddFirst});

  final VoidCallback onAddFirst;

  @override
  Widget build(BuildContext context) {
    return FriendlyEmptyState(
      icon: Icons.list_alt,
      title: 'ยังไม่มีข้อมูล',
      message: 'เมื่อเริ่มบันทึกงาน\nระบบจะสรุปรายได้ให้อัตโนมัติ',
      actionLabel: 'เพิ่มรายการ',
      onAction: onAddFirst,
    );
  }
}

class _NoResultsState extends StatelessWidget {
  const _NoResultsState();

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('ไม่พบรายการที่ตรงกับเงื่อนไข'),
      ),
    );
  }
}
