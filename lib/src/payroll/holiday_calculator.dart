import '../features/time_records/domain/work_record.dart';

class HolidayCalculator {
  const HolidayCalculator();

  bool isHolidayLike(DayType dayType) {
    return dayType == DayType.weekend || dayType == DayType.holiday;
  }
}
