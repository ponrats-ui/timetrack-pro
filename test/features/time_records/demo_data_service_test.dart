import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:timetrack_pro/src/core/database/app_database.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/application/demo_data_service.dart';
import 'package:timetrack_pro/src/features/time_records/data/work_record_repository.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  test('generates 30 realistic demo records', () {
    final service = DemoDataService(_FakeRepository());
    final records = service.generateDemoRecords(
      settings: const WorkSettings.defaults(),
      today: DateTime(2026, 6, 30),
    );

    expect(records, hasLength(30));
    expect(records.every((record) => record.isDemo), isTrue);
    expect(records.any((record) => record.dayType == DayType.normal), isTrue);
    expect(records.any((record) => record.dayType == DayType.weekend), isTrue);
    expect(records.any((record) => record.dayType == DayType.holiday), isTrue);
    expect(records.any((record) => record.extraOtHours > 0), isTrue);
    expect(records.any((record) => record.expense > 0), isTrue);
    expect(records.any((record) => record.travelAllowance > 0), isTrue);
  });

  test('demo reset deletes demo data only', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = WorkRecordRepository(database);
    final service = DemoDataService(repository);
    final now = DateTime(2026, 6, 30);

    await repository.saveRecord(_record(id: 'real', isDemo: false));
    await service.installDemoData(const WorkSettings.defaults());

    final deleted = await service.resetDemoData();
    final remaining = await repository.watchRecords().first;

    expect(deleted, 30);
    expect(remaining, hasLength(1));
    expect(remaining.single.id, 'real');
    expect(remaining.single.isDemo, isFalse);
    expect(remaining.single.workDate, DateTime(now.year, now.month, now.day));
  });
}

WorkRecordEntity _record({required String id, required bool isDemo}) {
  final now = DateTime(2026, 6, 30);
  return WorkRecordEntity(
    id: id,
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
    isDemo: isDemo,
    createdAt: now,
    updatedAt: now,
  );
}

class _FakeRepository implements WorkRecordRepository {
  @override
  Future<int> deleteDemoRecords() async => 0;

  @override
  Future<int> deleteRecord(String id) async => 0;

  @override
  Future<void> saveRecord(WorkRecordEntity record) async {}

  @override
  Future<void> saveRecords(Iterable<WorkRecordEntity> records) async {}

  @override
  Stream<List<WorkRecordEntity>> watchRecords() => const Stream.empty();
}
