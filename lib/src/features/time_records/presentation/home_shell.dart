import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../backup/presentation/backup_screen.dart';
import '../../help/presentation/help_screen.dart';
import '../../hr_import/presentation/employee_import_screen.dart';
import '../../onboarding/presentation/welcome_screen.dart';
import '../../settings/data/settings_repository.dart';
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
          PopupMenuButton<_HomeMenuAction>(
            tooltip: 'เน€เธกเธเธน',
            onSelected: _handleMenuAction,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _HomeMenuAction.gettingStarted,
                child: ListTile(
                  leading: Icon(Icons.flag),
                  title: Text('เน€เธฃเธดเนเธกเธ•เนเธเนเธเนเธเธฒเธ'),
                ),
              ),
              PopupMenuItem(
                value: _HomeMenuAction.onboarding,
                child: ListTile(
                  leading: Icon(Icons.swipe),
                  title: Text('เธ”เธนเธซเธเนเธฒเธ•เนเธญเธเธฃเธฑเธ'),
                ),
              ),
              PopupMenuItem(
                value: _HomeMenuAction.importEmployee,
                child: ListTile(
                  leading: Icon(Icons.upload_file),
                  title: Text(
                    'เธเธณเน€เธเนเธฒเธเนเธญเธกเธนเธฅเธเธเธฑเธเธเธฒเธ',
                  ),
                ),
              ),
              PopupMenuItem(
                value: _HomeMenuAction.backup,
                child: ListTile(
                  leading: Icon(Icons.backup_outlined),
                  title: Text('สำรองและกู้คืนข้อมูล'),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: _HomeMenuAction.settings,
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('เธ•เธฑเนเธเธเนเธฒ'),
                ),
              ),
            ],
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
          NavigationDestination(
            icon: Icon(Icons.edit_note),
            label: 'เธเธฑเธเธ—เธถเธเน€เธงเธฅเธฒ',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'เธ”เธนเธงเธฑเธเธ—เธณเธเธฒเธ',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'เธ”เธนเธฃเธฒเธขเธเธฒเธฃเธขเนเธญเธเธซเธฅเธฑเธ',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'เธชเธฃเธธเธเธฃเธฒเธขเนเธ”เน',
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(_HomeMenuAction action) {
    switch (action) {
      case _HomeMenuAction.gettingStarted:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => const HelpScreen()),
        );
        return;
      case _HomeMenuAction.onboarding:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const _OnboardingReplayPage(),
          ),
        );
        return;
      case _HomeMenuAction.importEmployee:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const EmployeeImportScreen(),
          ),
        );
        return;
      case _HomeMenuAction.backup:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => const BackupScreen()),
        );
        return;
      case _HomeMenuAction.settings:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => const SettingsScreen()),
        );
        return;
    }
  }
}

enum _HomeMenuAction {
  gettingStarted,
  onboarding,
  importEmployee,
  backup,
  settings,
}

class _OnboardingReplayPage extends ConsumerWidget {
  const _OnboardingReplayPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(workSettingsProvider);
    return settings.when(
      data: (settings) => WelcomeScreen(settings: settings, replay: true),
      error: (_, _) => const Scaffold(
        body: Center(
          child: Text(
            'เน€เธเธดเธ”เนเธกเนเนเธ”เน เธฅเธญเธเธญเธตเธเธเธฃเธฑเนเธเธเธฃเธฑเธ',
          ),
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
