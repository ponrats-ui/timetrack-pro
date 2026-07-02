import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../../features/reports/domain/report_export.dart';
import '../constants/app_constants.dart';

class ErrorLogService {
  ErrorLogService._();

  static final ErrorLogService instance = ErrorLogService._();

  final _entries = <String>[];

  void record(Object error, StackTrace? stackTrace, {String source = 'app'}) {
    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer()
      ..writeln('[$timestamp] $source')
      ..writeln(error);
    if (stackTrace != null) {
      buffer.writeln(stackTrace);
    }
    _entries.add(buffer.toString());
    if (_entries.length > 100) {
      _entries.removeAt(0);
    }
  }

  FutureOr<void> recordAsync(
    Object error,
    StackTrace stackTrace, {
    String source = 'async',
  }) {
    record(error, stackTrace, source: source);
  }

  String exportText() {
    final buffer = StringBuffer()
      ..writeln('TimeTrack Pro logs.txt')
      ..writeln('Version: ${AppConstants.version}+${AppConstants.buildNumber}')
      ..writeln('Build: ${AppConstants.buildLabel}')
      ..writeln('Commit: ${AppConstants.gitCommit}')
      ..writeln('GeneratedAt: ${DateTime.now().toIso8601String()}')
      ..writeln();
    if (_entries.isEmpty) {
      buffer.writeln('No unexpected exceptions recorded.');
    } else {
      buffer.writeln(_entries.join('\n---\n'));
    }
    return buffer.toString();
  }

  ReportExportFile exportFile() {
    final text = exportText();
    return ReportExportFile(
      format: ReportExportFormat.json,
      fileName: 'logs.txt',
      mimeType: 'text/plain',
      bytes: Uint8List.fromList(utf8.encode(text)),
    );
  }
}
