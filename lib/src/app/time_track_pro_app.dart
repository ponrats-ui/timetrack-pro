import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/data/settings_repository.dart';
import '../features/settings/domain/work_settings.dart';
import '../features/time_records/presentation/home_shell.dart';
import 'theme/app_theme.dart';

class TimeTrackProApp extends ConsumerWidget {
  const TimeTrackProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference =
        ref.watch(workSettingsProvider).asData?.value.themePreference ??
        AppThemePreference.system;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimeTrack Pro',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: switch (preference) {
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
        AppThemePreference.system => ThemeMode.system,
      },
      home: const HomeShell(),
    );
  }
}
