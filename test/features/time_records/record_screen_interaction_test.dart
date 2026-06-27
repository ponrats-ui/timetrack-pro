import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetrack_pro/src/features/settings/data/settings_repository.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/data/work_record_repository.dart';
import 'package:timetrack_pro/src/features/time_records/presentation/record_screen.dart';

void main() {
  testWidgets('add record button accepts taps and focuses the form', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workRecordsProvider.overrideWith((ref) => Stream.value(const [])),
          workSettingsProvider.overrideWith(
            (ref) => Stream.value(const WorkSettings.defaults()),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: RecordScreen(showTodaySummary: true)),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final addButton = find.byKey(const Key('today-add-record-button'));
    expect(addButton, findsOneWidget);
    final buttonRenderObject = tester.renderObject(addButton);
    final hitTest = tester.hitTestOnBinding(tester.getCenter(addButton));
    expect(hitTest.path, isNotEmpty);
    expect(
      hitTest.path.any((entry) => entry.target == buttonRenderObject),
      isTrue,
    );

    await tester.tap(addButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });
}
