import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetrack_pro/src/features/settings/data/settings_repository.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/data/work_record_repository.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';
import 'package:timetrack_pro/src/features/time_records/presentation/record_screen.dart';

void main() {
  testWidgets('empty database shows friendly first launch welcome', (
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

    expect(find.text('ยังไม่มีข้อมูล'), findsOneWidget);
    expect(find.text('เริ่มใช้งาน'), findsOneWidget);
    expect(find.text('เพิ่มรายการ'), findsOneWidget);
    expect(find.text('ตั้งค่าเงินเดือน'), findsOneWidget);
    expect(find.text('ตั้งค่าเวลาทำงาน'), findsOneWidget);
    expect(find.text('เพิ่มรายการแรก'), findsOneWidget);
    expect(find.text('ดูสรุปรายได้'), findsOneWidget);
  });

  testWidgets('add record button accepts taps and focuses the form', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workRecordsProvider.overrideWith(
            (ref) => Stream.value([_recordForToday()]),
          ),
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
    expect(find.text('กดเพื่อบันทึกเวลาเข้า-ออกงาน'), findsOneWidget);
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
    expect(find.text('กรอกเวลาเข้าและออกงาน แล้วกดบันทึก'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });

  testWidgets('mobile record form shows simple fields and live preview', (
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
        child: const MaterialApp(home: Scaffold(body: RecordScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('บันทึกเวลาทำงาน'), findsOneWidget);
    expect(find.text('วันที่'), findsOneWidget);
    expect(find.text('เวลาเข้า'), findsOneWidget);
    expect(find.text('เวลาออก'), findsOneWidget);
    expect(find.text('หมายเหตุ (ไม่บังคับ)'), findsOneWidget);
    expect(find.text('เวลาปกติ'), findsOneWidget);
    expect(find.text('เวลาล่วงเวลา'), findsOneWidget);
  });
}

WorkRecordEntity _recordForToday() {
  final now = DateTime.now();
  return WorkRecordEntity(
    id: 'existing-record',
    workDate: DateTime(now.year, now.month, now.day),
    checkInMinutes: 8 * 60,
    checkOutMinutes: 17 * 60,
    breakMinutes: 60,
    dayType: DayType.normal,
    extraOtHours: 0,
    travelAllowance: 0,
    specialAllowance: 0,
    expense: 0,
    note: '',
    createdAt: now,
    updatedAt: now,
  );
}
