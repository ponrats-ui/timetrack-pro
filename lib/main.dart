import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/time_track_pro_app.dart';
import 'src/core/logging/error_log_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    ErrorLogService.instance.record(
      details.exception,
      details.stack,
      source: 'flutter',
    );
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    ErrorLogService.instance.record(error, stackTrace, source: 'platform');
    return false;
  };

  runZonedGuarded(
    () => runApp(const ProviderScope(child: TimeTrackProApp())),
    (error, stackTrace) =>
        ErrorLogService.instance.record(error, stackTrace, source: 'zone'),
  );
}
