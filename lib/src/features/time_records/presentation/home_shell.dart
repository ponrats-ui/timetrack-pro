import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../settings/presentation/settings_screen.dart';
import 'monthly_screen.dart';
import 'record_list_screen.dart';
import 'record_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [
      RecordScreen(),
      RecordListScreen(),
      _DailyPlaceholder(),
      MonthlyScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'ตั้งค่า',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
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

class _DailyPlaceholder extends StatelessWidget {
  const _DailyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('รายวันจะต่อยอดจากข้อมูลบันทึกใน Sprint ถัดไป'),
      ),
    );
  }
}
