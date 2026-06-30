import 'dart:typed_data';

enum ReportExportFormat {
  pdf('pdf', 'PDF'),
  excel('xlsx', 'Excel'),
  json('json', 'JSON');

  const ReportExportFormat(this.extension, this.label);

  final String extension;
  final String label;

  static ReportExportFormat fromValue(String value) {
    return ReportExportFormat.values.firstWhere(
      (format) => format.extension == value,
      orElse: () => ReportExportFormat.pdf,
    );
  }
}

class ReportExportFile {
  const ReportExportFile({
    required this.format,
    required this.fileName,
    required this.mimeType,
    required this.bytes,
  });

  final ReportExportFormat format;
  final String fileName;
  final String mimeType;
  final Uint8List bytes;
}

class ReportExportHistoryEntity {
  const ReportExportHistoryEntity({
    required this.id,
    required this.format,
    required this.exportedAt,
    required this.fileName,
  });

  final String id;
  final ReportExportFormat format;
  final DateTime exportedAt;
  final String fileName;
}
