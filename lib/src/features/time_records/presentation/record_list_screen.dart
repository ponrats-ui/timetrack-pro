import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../settings/data/settings_repository.dart';
import '../application/work_calculator.dart';
import '../data/work_record_repository.dart';
import '../domain/work_record.dart';
import 'record_screen.dart';

class RecordListScreen extends ConsumerWidget {
  const RecordListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(workRecordsProvider);
    final settings = ref.watch(workSettingsProvider);

    return records.when(
      data: (items) => settings.when(
        data: (payrollSettings) {
          if (items.isEmpty) {
            return const _EmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final record = items[index];
              final calculation = const WorkCalculator().calculateDaily(
                record,
                payrollSettings,
              );

              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                    child: const Icon(Icons.work_history),
                  ),
                  title: Text(formatShortDate(record.workDate)),
                  subtitle: Text(
                    '${formatClock(record.checkInMinutes)} - '
                    '${formatClock(record.checkOutMinutes)} • '
                    '${record.dayType.label}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatMoney(calculation.dailyIncome),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('OT ${formatHours(calculation.otHours)}'),
                    ],
                  ),
                  onTap: () => _openEditor(context, record),
                  onLongPress: () => _confirmDelete(context, ref, record),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _openEditor(BuildContext context, WorkRecordEntity record) {
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

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    WorkRecordEntity record,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ลบรายการนี้?'),
          content: const Text('กดตกลงเพื่อลบข้อมูลออกจากเครื่องนี้'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('ยกเลิก'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('ลบ'),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      await ref.read(workRecordRepositoryProvider).deleteRecord(record.id);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('ยังไม่มีรายการ กดแท็บบันทึกเพื่อเพิ่มข้อมูลการทำงาน'),
      ),
    );
  }
}
