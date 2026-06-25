const thaiMonthNames = [
  'มกราคม',
  'กุมภาพันธ์',
  'มีนาคม',
  'เมษายน',
  'พฤษภาคม',
  'มิถุนายน',
  'กรกฎาคม',
  'สิงหาคม',
  'กันยายน',
  'ตุลาคม',
  'พฤศจิกายน',
  'ธันวาคม',
];

String formatThaiDate(DateTime date) {
  return '${date.day} ${thaiMonthNames[date.month - 1]} ${date.year + 543}';
}

String formatThaiMonth(DateTime date) {
  return '${thaiMonthNames[date.month - 1]} ${date.year + 543}';
}

String formatShortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year + 543}';
}

String formatClock(int minutesFromMidnight) {
  final hours = minutesFromMidnight ~/ 60;
  final minutes = minutesFromMidnight % 60;
  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}';
}

String formatMoney(double value) {
  return '${_formatNumber(value)} บาท';
}

String formatHours(double value) {
  return '${_formatNumber(value)} ชม.';
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(2);
}
