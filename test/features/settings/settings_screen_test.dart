import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetrack_pro/src/core/constants/app_constants.dart';
import 'package:timetrack_pro/src/features/settings/data/settings_repository.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/settings/presentation/settings_screen.dart';

void main() {
  testWidgets('settings screen saves and reloads zero break minutes', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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
      'เวลาพักสำหรับบันทึก (นาที, ไม่หักชั่วโมง)',
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
    expect(repository.current.derivedDailyWage, 750);

    repository.emit(repository.current);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
    await tester.pump();

    final reloadedBreakField = find.widgetWithText(
      TextFormField,
      'เวลาพักสำหรับบันทึก (นาที, ไม่หักชั่วโมง)',
    );
    expect(
      tester.widget<TextFormField>(reloadedBreakField).controller?.text,
      '0',
    );
  });

  testWidgets('settings screen shows app ownership information', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _FakeSettingsRepository(const WorkSettings.defaults());
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    final aboutTitle = find.text('เกี่ยวกับแอป');
    await tester.scrollUntilVisible(
      aboutTitle,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    expect(aboutTitle, findsOneWidget);
    expect(find.text(AppConstants.appName), findsWidgets);
    expect(find.textContaining(AppConstants.creatorName), findsWidgets);
    expect(find.text(AppConstants.copyright), findsOneWidget);
    expect(find.text('Part of ${AppConstants.productFamily}'), findsWidgets);
    expect(find.text('ใบอนุญาตซอฟต์แวร์ที่ใช้'), findsOneWidget);
  });
  testWidgets('settings screen saves payroll policy controls', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _FakeSettingsRepository(const WorkSettings.defaults());
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    final otStartField = find.widgetWithText(TextFormField, 'เวลาเริ่มคิด OT');
    await tester.scrollUntilVisible(
      otStartField,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(otStartField, '18:00');
    expect(find.text('OT ขั้นต่ำ'), findsOneWidget);
    expect(find.text('การปัดเวลา OT'), findsOneWidget);
    expect(find.text('ปัดตามนโยบายบริษัท'), findsOneWidget);

    final saveButton = find.byIcon(Icons.save);
    await tester.scrollUntilVisible(
      saveButton,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pump();

    expect(repository.current.otStartMinutes, 18 * 60);
    expect(repository.current.minimumOtMinutes, 0);
    expect(
      repository.current.otRoundingPolicy,
      OtRoundingPolicy.companyHalfHour,
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
