import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/database/database_providers.dart';
import '../core/widgets/friendly_states.dart';
import '../features/onboarding/presentation/welcome_screen.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/settings/domain/work_settings.dart';
import '../features/time_records/presentation/home_shell.dart';
import 'theme/app_theme.dart';

class TimeTrackProApp extends ConsumerWidget {
  const TimeTrackProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(workSettingsProvider);
    final preference =
        settingsAsync.asData?.value.themePreference ??
        AppThemePreference.system;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimeTrack Pro',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeAnimationDuration: const Duration(milliseconds: 220),
      themeAnimationCurve: Curves.easeOutCubic,
      themeMode: switch (preference) {
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
        AppThemePreference.system => ThemeMode.system,
      },
      home: settingsAsync.when(
        data: (settings) => settings.onboardingCompleted
            ? const HomeShell()
            : WelcomeScreen(settings: settings),
        error: (error, stackTrace) => _DatabaseStartupError(
          onRetry: () {
            ref.invalidate(appDatabaseProvider);
            ref.invalidate(workSettingsProvider);
          },
        ),
        loading: () => const _StartupLoading(),
      ),
    );
  }
}

class _StartupLoading extends StatelessWidget {
  const _StartupLoading();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FriendlyLoading(message: 'กำลังเตรียมฐานข้อมูล...'),
            const SizedBox(height: 12),
            Text(
              '${AppConstants.appName}\n'
              '${AppConstants.productFamily}\n'
              '${AppConstants.shortCopyright}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatabaseStartupError extends StatelessWidget {
  const _DatabaseStartupError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.storage_rounded,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'เกิดข้อผิดพลาดเล็กน้อย',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ลองอีกครั้งครับ หากยังเปิดไม่ได้ ให้ลองเปิดด้วย Chrome',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('ลองอีกครั้ง'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
