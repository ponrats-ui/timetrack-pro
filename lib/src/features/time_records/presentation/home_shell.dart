import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../settings/presentation/settings_screen.dart';
import 'calendar_screen.dart';
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
  late final List<Widget> _pages = [
    RecordScreen(
      showTodaySummary: true,
      onViewMonth: () => _setIndex(3),
      onExport: () => _setIndex(3),
    ),
    const CalendarScreen(),
    const RecordListScreen(),
    const MonthlyScreen(),
  ];

  void _setIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 160),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutCubic,
        child: IndexedStack(
          key: ValueKey(_currentIndex),
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _setIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.edit_note), label: 'บันทึก'),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'ปฏิทิน',
          ),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'รายการ'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'รายเดือน'),
        ],
      ),
    );
  }
}
