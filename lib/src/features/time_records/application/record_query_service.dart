import '../../settings/domain/work_settings.dart';
import '../domain/work_record.dart';
import 'work_calculator.dart';

enum RecordFilter { otOnly, holiday, weekend, expense }

extension RecordFilterLabel on RecordFilter {
  String get label {
    return switch (this) {
      RecordFilter.otOnly => 'เฉพาะ OT',
      RecordFilter.holiday => 'วันหยุด',
      RecordFilter.weekend => 'เสาร์-อาทิตย์',
      RecordFilter.expense => 'มีค่าใช้จ่าย',
    };
  }
}

enum RecordSortOption { newest, oldest, highestIncome, highestOt }

extension RecordSortOptionLabel on RecordSortOption {
  String get label {
    return switch (this) {
      RecordSortOption.newest => 'ใหม่สุด',
      RecordSortOption.oldest => 'เก่าสุด',
      RecordSortOption.highestIncome => 'รายได้สูงสุด',
      RecordSortOption.highestOt => 'OT สูงสุด',
    };
  }
}

enum RecordPeriod { all, today, week, month, custom }

extension RecordPeriodLabel on RecordPeriod {
  String get label {
    return switch (this) {
      RecordPeriod.all => 'ทั้งหมด',
      RecordPeriod.today => 'วันนี้',
      RecordPeriod.week => 'สัปดาห์นี้',
      RecordPeriod.month => 'เดือนนี้',
      RecordPeriod.custom => 'เลือกช่วงเอง',
    };
  }
}

class RecordDateRange {
  const RecordDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  bool contains(DateTime value) {
    final date = DateTime(value.year, value.month, value.day);
    return !date.isBefore(start) && !date.isAfter(end);
  }
}

class RecordSearchCriteria {
  const RecordSearchCriteria({
    this.query = '',
    this.date,
    this.month,
    this.period = RecordPeriod.all,
    this.anchorDate,
    this.customRange,
    this.filters = const {},
    this.sortOption = RecordSortOption.newest,
  });

  final String query;
  final DateTime? date;
  final DateTime? month;
  final RecordPeriod period;
  final DateTime? anchorDate;
  final RecordDateRange? customRange;
  final Set<RecordFilter> filters;
  final RecordSortOption sortOption;
}

class RecordListItem {
  const RecordListItem({required this.record, required this.calculation});

  final WorkRecordEntity record;
  final DailyCalculation calculation;
}

class RecordQueryService {
  const RecordQueryService({this.calculator = const WorkCalculator()});

  final WorkCalculator calculator;

  List<RecordListItem> apply({
    required Iterable<WorkRecordEntity> records,
    required WorkSettings settings,
    required RecordSearchCriteria criteria,
  }) {
    final normalizedQuery = criteria.query.trim().toLowerCase();
    final items = <RecordListItem>[];

    for (final record in records) {
      final calculation = calculator.calculateDaily(record, settings);
      final item = RecordListItem(record: record, calculation: calculation);
      if (!_matchesQuery(record, normalizedQuery)) {
        continue;
      }
      if (!_matchesDate(record, criteria.date)) {
        continue;
      }
      if (!_matchesMonth(record, criteria.month)) {
        continue;
      }
      if (!_matchesPeriod(
        record,
        criteria.period,
        criteria.anchorDate,
        criteria.customRange,
      )) {
        continue;
      }
      if (!_matchesFilters(item, criteria.filters)) {
        continue;
      }
      items.add(item);
    }

    items.sort((a, b) => _compare(a, b, criteria.sortOption));
    return List.unmodifiable(items);
  }

  bool _matchesQuery(WorkRecordEntity record, String query) {
    if (query.isEmpty) {
      return true;
    }

    final date = record.workDate;
    final searchable = [
      record.note,
      record.dayType.label,
      '${date.year}-${_two(date.month)}-${_two(date.day)}',
      '${_two(date.day)}/${_two(date.month)}/${date.year}',
      '${_two(date.day)}/${_two(date.month)}/${date.year + 543}',
      '${date.year}-${_two(date.month)}',
      '${date.year + 543}-${_two(date.month)}',
    ].join(' ').toLowerCase();

    return searchable.contains(query);
  }

  bool _matchesDate(WorkRecordEntity record, DateTime? date) {
    if (date == null) {
      return true;
    }

    return record.workDate.year == date.year &&
        record.workDate.month == date.month &&
        record.workDate.day == date.day;
  }

  bool _matchesMonth(WorkRecordEntity record, DateTime? month) {
    if (month == null) {
      return true;
    }

    return record.workDate.year == month.year &&
        record.workDate.month == month.month;
  }

  bool _matchesPeriod(
    WorkRecordEntity record,
    RecordPeriod period,
    DateTime? anchorDate,
    RecordDateRange? customRange,
  ) {
    if (period == RecordPeriod.all) {
      return true;
    }

    final range = period == RecordPeriod.custom
        ? customRange
        : recordPeriodRange(period, anchorDate ?? DateTime.now());
    if (range == null) {
      return true;
    }

    return range.contains(record.workDate);
  }

  bool _matchesFilters(RecordListItem item, Set<RecordFilter> filters) {
    for (final filter in filters) {
      final matches = switch (filter) {
        RecordFilter.otOnly => item.calculation.otHours > 0,
        RecordFilter.holiday => item.record.dayType == DayType.holiday,
        RecordFilter.weekend => item.record.dayType == DayType.weekend,
        RecordFilter.expense => item.record.expense > 0,
      };
      if (!matches) {
        return false;
      }
    }

    return true;
  }

  int _compare(
    RecordListItem first,
    RecordListItem second,
    RecordSortOption sortOption,
  ) {
    return switch (sortOption) {
      RecordSortOption.newest => second.record.workDate.compareTo(
        first.record.workDate,
      ),
      RecordSortOption.oldest => first.record.workDate.compareTo(
        second.record.workDate,
      ),
      RecordSortOption.highestIncome =>
        second.calculation.dailyIncome.compareTo(first.calculation.dailyIncome),
      RecordSortOption.highestOt => second.calculation.otHours.compareTo(
        first.calculation.otHours,
      ),
    };
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}

RecordDateRange? recordPeriodRange(RecordPeriod period, DateTime anchorDate) {
  final date = DateTime(anchorDate.year, anchorDate.month, anchorDate.day);
  return switch (period) {
    RecordPeriod.all => null,
    RecordPeriod.today => RecordDateRange(start: date, end: date),
    RecordPeriod.week => RecordDateRange(
      start: date.subtract(Duration(days: date.weekday - 1)),
      end: date.add(Duration(days: DateTime.daysPerWeek - date.weekday)),
    ),
    RecordPeriod.month => RecordDateRange(
      start: DateTime(date.year, date.month),
      end: DateTime(date.year, date.month + 1, 0),
    ),
    RecordPeriod.custom => null,
  };
}
