import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetrack_pro/src/features/settings/data/settings_repository.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/settings/presentation/settings_screen.dart';

void main() {
  testWidgets('settings screen saves and reloads zero break minutes', (
    tester,
  ) async {
    final repository = _FakeSettingsRepository(
      const WorkSettings.defaults().copyWith(defaultBreakMinutes: 60),
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    final breakField = find.widgetWithText(
      TextFormField,
      'หักเวลาพักอัตโนมัติ (นาที, 0 = ไม่หัก)',
    );
    expect(breakField, findsOneWidget);
    expect(tester.widget<TextFormField>(breakField).controller?.text, '60');

    await tester.enterText(breakField, '0');
    final saveButton = find.widgetWithText(FilledButton, 'บันทึกการตั้งค่า');
    await tester.scrollUntilVisible(
      saveButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pump();

    expect(repository.current.defaultBreakMinutes, 0);

    repository.emit(repository.current);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
    await tester.pump();

    final reloadedBreakField = find.widgetWithText(
      TextFormField,
      'หักเวลาพักอัตโนมัติ (นาที, 0 = ไม่หัก)',
    );
    expect(
      tester.widget<TextFormField>(reloadedBreakField).controller?.text,
      '0',
    );
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

  void emit(WorkSettings settings) {
    _controller.add(settings);
  }

  void dispose() {
    _controller.close();
  }
}
