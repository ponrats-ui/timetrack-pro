import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetrack_pro/src/features/onboarding/presentation/welcome_screen.dart';
import 'package:timetrack_pro/src/features/settings/data/settings_repository.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';

void main() {
  testWidgets('onboarding walks through five friendly first-use pages', (
    tester,
  ) async {
    final repository = _FakeSettingsRepository(const WorkSettings.defaults());
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: WelcomeScreen(settings: WorkSettings.defaults()),
        ),
      ),
    );

    expect(find.text('ยินดีต้อนรับสู่ TimeTrack Pro'), findsOneWidget);

    for (var i = 0; i < 4; i += 1) {
      await tester.tap(find.text('ถัดไป'));
      await tester.pumpAndSettle();
    }

    expect(find.text('พร้อมเริ่มใช้งาน'), findsOneWidget);
    await tester.tap(find.text('เริ่มใช้งาน'));
    await tester.pumpAndSettle();

    expect(find.text('First-time Setup'), findsOneWidget);
    await tester.tap(find.text('Finish - Ready to use'));
    await tester.pump();

    expect(repository.current.onboardingCompleted, isTrue);
  });

  testWidgets('replayed onboarding can close without changing settings', (
    tester,
  ) async {
    final repository = _FakeSettingsRepository(
      const WorkSettings.defaults().copyWith(onboardingCompleted: true),
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => WelcomeScreen(
                      settings: repository.current,
                      replay: true,
                    ),
                  ),
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ปิด'));
    await tester.pumpAndSettle();

    expect(repository.current.onboardingCompleted, isTrue);
    expect(find.text('open'), findsOneWidget);
  });
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this.current);

  WorkSettings current;
  final _controller = StreamController<WorkSettings>.broadcast();

  @override
  Stream<WorkSettings> watchSettings() async* {
    yield current;
    yield* _controller.stream;
  }

  @override
  Future<void> saveSettings(WorkSettings settings) async {
    current = settings;
    _controller.add(settings);
  }

  void dispose() {
    _controller.close();
  }
}
