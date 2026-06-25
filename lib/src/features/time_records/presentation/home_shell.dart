import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../data/work_entry_repository.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _RecordPlaceholder(),
      const _EntriesPlaceholder(),
      const _DailyPlaceholder(),
      const _MonthlyPlaceholder(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.edit_note), label: 'บันทึก'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'รายการ'),
          NavigationDestination(icon: Icon(Icons.today), label: 'รายวัน'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'รายเดือน'),
        ],
      ),
    );
  }
}

class _RecordPlaceholder extends StatelessWidget {
  const _RecordPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const _PageScaffold(
      title: 'บันทึกเวลาทำงาน',
      description: 'พื้นที่สำหรับฟอร์มบันทึกเวลา OT รายได้พิเศษ และค่าใช้จ่าย',
      icon: Icons.edit_note,
    );
  }
}

class _EntriesPlaceholder extends ConsumerWidget {
  const _EntriesPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(workEntriesProvider);

    return entries.when(
      data: (items) => _PageScaffold(
        title: 'รายการทั้งหมด',
        description: 'เชื่อมต่อฐานข้อมูล Drift แล้ว พบ ${items.length} รายการ',
        icon: Icons.list_alt,
      ),
      error: (error, stackTrace) => _PageScaffold(
        title: 'เปิดฐานข้อมูลไม่สำเร็จ',
        description: error.toString(),
        icon: Icons.error_outline,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _DailyPlaceholder extends StatelessWidget {
  const _DailyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const _PageScaffold(
      title: 'รายงานรายวัน',
      description:
          'โครงสร้างพร้อมสำหรับสรุปชั่วโมงทำงาน รายได้ และค่าใช้จ่ายรายวัน',
      icon: Icons.today,
    );
  }
}

class _MonthlyPlaceholder extends StatelessWidget {
  const _MonthlyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const _PageScaffold(
      title: 'รายงานรายเดือน',
      description: 'โครงสร้างพร้อมสำหรับรายงานส่ง HR และ export ในอนาคต',
      icon: Icons.bar_chart,
    );
  }
}

class _PageScaffold extends StatelessWidget {
  const _PageScaffold({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
