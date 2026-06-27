import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/domain/work_settings.dart';
import '../data/work_record_repository.dart';
import '../domain/work_record.dart';
import 'work_calculator.dart';

final demoDataServiceProvider = Provider<DemoDataService>((ref) {
  return DemoDataService(ref.watch(workRecordRepositoryProvider));
});

class DemoDataService {
  const DemoDataService(
    this._repository, {
    this.calculator = const WorkCalculator(),
  });

  final WorkRecordRepository _repository;
  final WorkCalculator calculator;

  Future<List<WorkRecordEntity>> installDemoData(WorkSettings settings) async {
    await _repository.deleteDemoRecords();
    final records = generateDemoRecords(
      settings: settings,
      today: DateTime.now(),
    );
    await _repository.saveRecords(records);
    return records;
  }

  Future<int> resetDemoData() {
    return _repository.deleteDemoRecords();
  }

  List<WorkRecordEntity> generateDemoRecords({
    required WorkSettings settings,
    required DateTime today,
  }) {
    final startDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 29));

    return List.generate(30, (index) {
      final date = startDate.add(Duration(days: index));
      final weekday = date.weekday;
      final isWeekend =
          weekday == DateTime.saturday || weekday == DateTime.sunday;
      final isHoliday = index == 6 || index == 21;
      final hasLongOt = index % 5 == 1 || index % 9 == 3;
      final hasShortOt = index % 4 == 0;
      final hasExpense = index % 6 == 2 || index % 11 == 4;
      final hasAllowance = index % 3 == 0;
      final isNightShift = index == 10 || index == 23;
      final dayType = isHoliday
          ? DayType.holiday
          : isWeekend
          ? DayType.weekend
          : DayType.normal;
      final checkIn = isNightShift ? 20 * 60 : 8 * 60 + ((index % 3) * 15);
      final checkOut = isNightShift
          ? 5 * 60
          : 17 * 60 +
                (hasLongOt
                    ? 120
                    : hasShortOt
                    ? 60
                    : 0);
      final record = WorkRecordEntity(
        id: 'demo-${date.year}-${date.month}-${date.day}',
        workDate: date,
        checkInMinutes: checkIn,
        checkOutMinutes: checkOut,
        breakMinutes: settings.defaultBreakMinutes,
        dayType: dayType,
        extraOtHours: index % 8 == 0 ? 1 : 0,
        travelAllowance: hasAllowance
            ? settings.travelAllowanceDefault + 40
            : 0,
        specialAllowance: index % 7 == 0
            ? settings.otherAllowanceDefault + 80
            : 0,
        expense: hasExpense ? 80 + ((index % 4) * 25) : 0,
        note: _noteFor(dayType, isNightShift, hasExpense),
        isDemo: true,
        createdAt: date,
        updatedAt: date,
      );

      calculator.calculateDaily(record, settings);
      return record;
    });
  }

  String _noteFor(DayType dayType, bool isNightShift, bool hasExpense) {
    if (isNightShift) {
      return 'ข้อมูลตัวอย่าง: กะกลางคืน';
    }
    if (dayType == DayType.holiday) {
      return 'ข้อมูลตัวอย่าง: วันหยุดนักขัตฤกษ์';
    }
    if (dayType == DayType.weekend) {
      return 'ข้อมูลตัวอย่าง: วันหยุดสุดสัปดาห์';
    }
    if (hasExpense) {
      return 'ข้อมูลตัวอย่าง: มีค่าใช้จ่ายระหว่างทาง';
    }

    return 'ข้อมูลตัวอย่าง: วันทำงานปกติ';
  }
}
