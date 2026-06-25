import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetrack_pro/src/app/time_track_pro_app.dart';

void main() {
  testWidgets('TimeTrack Pro boots into the record tab', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TimeTrackProApp()));

    expect(find.text('TimeTrack Pro'), findsOneWidget);
    expect(find.text('บันทึกเวลาทำงาน'), findsOneWidget);
    expect(find.text('บันทึก'), findsWidgets);
    expect(find.text('รายการ'), findsOneWidget);
    expect(find.text('รายวัน'), findsOneWidget);
    expect(find.text('รายเดือน'), findsOneWidget);
  });
}
