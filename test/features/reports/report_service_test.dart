import 'package:test/test.dart';
import 'package:timetrack_pro/src/features/reports/application/report_service.dart';
import 'package:timetrack_pro/src/features/reports/domain/hr_monthly_report.dart';
import 'package:timetrack_pro/src/features/settings/domain/work_settings.dart';
import 'package:timetrack_pro/src/features/time_records/application/record_query_service.dart';
import 'package:timetrack_pro/src/features/time_records/domain/work_record.dart';

void main() {
  test('builds HR monthly report summary and line items', () {
    final report = const ReportService().buildMonthlyReport(
      month: DateTime(2026, 6),
      records: [
        _record(
          id: '1',
          date: DateTime(2026, 6, 1),
          checkIn: 8 * 60,
          checkOut: 17 * 60,
          breakMinutes: 60,
          travelAllowance: 50,
          expense: 20,
        ),
        _record(
          id: '2',
          date: DateTime(2026, 6, 2),
          checkIn: 8 * 60,
          checkOut: 19 * 60,
          breakMinutes: 60,
        ),
        _record(
          id: 'outside-month',
          date: DateTime(2026, 7, 1),
          checkIn: 8 * 60,
          checkOut: 17 * 60,
          breakMinutes: 60,
        ),
      ],
      settings: const WorkSettings.defaults().copyWith(
        companyName: 'ACME Logistics',
        employeeName: 'Somchai',
        employeeId: 'EMP-001',
        taxDeduction: 100,
      ),
    );

    expect(report.companyName, 'ACME Logistics');
    expect(report.employeeName, 'Somchai');
    expect(report.employeeId, 'EMP-001');
    expect(report.workingDays, 2);
    expect(report.lineItems, hasLength(2));
    expect(report.grossIncome, 1800);
    expect(report.expenseTotal, 20);
    expect(report.socialSecurityDeduction, 750);
    expect(report.taxDeduction, 100);
    expect(report.totalDeductions, 850);
    expect(report.netIncome, 930);
  });

  test('report line items preserve short shift duration with zero break', () {
    final report = const ReportService().buildMonthlyReport(
      month: DateTime(2026, 6),
      records: [
        _record(
          id: 'one-hour',
          date: DateTime(2026, 6, 12),
          checkIn: 19 * 60,
          checkOut: 20 * 60,
          breakMinutes: 0,
        ),
        _record(
          id: 'three-hours',
          date: DateTime(2026, 6, 13),
          checkIn: (16 * 60) + 30,
          checkOut: (19 * 60) + 30,
          breakMinutes: 0,
        ),
      ],
      settings: const WorkSettings.defaults(),
    );

    expect(report.totalWorkHours, 4);
    expect(report.lineItems.map((item) => item.totalWorkHours), [1, 3]);
    expect(report.lineItems.map((item) => item.breakMinutes), [0, 0]);
  });

  test('builds period report from the selected record range only', () {
    final report = const ReportService().buildPeriodReport(
      month: DateTime(2026, 7),
      records: [
        _record(
          id: 'today',
          date: DateTime(2026, 7, 1),
          checkIn: 8 * 60,
          checkOut: 17 * 60,
          breakMinutes: 0,
        ),
        _record(
          id: 'week-cross-month',
          date: DateTime(2026, 6, 29),
          checkIn: 8 * 60,
          checkOut: 20 * 60,
          breakMinutes: 0,
        ),
      ],
      settings: const WorkSettings.defaults(),
    );

    expect(report.workingDays, 2);
    expect(report.lineItems.map((item) => item.workDate.day), [29, 1]);
    expect(report.totalWorkHours, 21);
  });

  test('summary supports day week month and custom period ranges', () {
    final records = [
      _record(
        id: 'today',
        date: DateTime(2026, 7, 1),
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        breakMinutes: 0,
      ),
      _record(
        id: 'week',
        date: DateTime(2026, 6, 29),
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        breakMinutes: 0,
      ),
      _record(
        id: 'month',
        date: DateTime(2026, 7, 3),
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        breakMinutes: 0,
      ),
      _record(
        id: 'outside',
        date: DateTime(2026, 6, 20),
        checkIn: 8 * 60,
        checkOut: 17 * 60,
        breakMinutes: 0,
      ),
    ];

    HrMonthlyReport build(RecordDateRange range) {
      return const ReportService().buildPeriodReport(
        month: range.start,
        records: records.where((record) => range.contains(record.workDate)),
        settings: const WorkSettings.defaults(),
      );
    }

    expect(
      build(
        recordPeriodRange(RecordPeriod.today, DateTime(2026, 7, 1))!,
      ).workingDays,
      1,
    );
    expect(
      build(
        recordPeriodRange(RecordPeriod.week, DateTime(2026, 7, 1))!,
      ).workingDays,
      3,
    );
    expect(
      build(
        recordPeriodRange(RecordPeriod.month, DateTime(2026, 7, 1))!,
      ).workingDays,
      2,
    );
    expect(
      build(
        RecordDateRange(start: DateTime(2026, 7, 3), end: DateTime(2026, 7, 3)),
      ).workingDays,
      1,
    );
  });
}

WorkRecordEntity _record({
  required String id,
  required DateTime date,
  required int checkIn,
  required int checkOut,
  required int breakMinutes,
  double travelAllowance = 0,
  double expense = 0,
}) {
  final now = DateTime(2026, 6, 25, 8);
  return WorkRecordEntity(
    id: id,
    workDate: date,
    checkInMinutes: checkIn,
    checkOutMinutes: checkOut,
    breakMinutes: breakMinutes,
    dayType: DayType.normal,
    extraOtHours: 0,
    travelAllowance: travelAllowance,
    specialAllowance: 0,
    expense: expense,
    note: '',
    createdAt: now,
    updatedAt: now,
  );
}
