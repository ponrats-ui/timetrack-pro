import 'package:flutter/material.dart';

import '../features/time_records/presentation/home_shell.dart';
import 'theme/app_theme.dart';

class TimeTrackProApp extends StatelessWidget {
  const TimeTrackProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimeTrack Pro',
      theme: AppTheme.light,
      home: const HomeShell(),
    );
  }
}
