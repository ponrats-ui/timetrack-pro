import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../reports/application/report_share_service.dart';
import '../../reports/domain/report_export.dart';
import '../../settings/data/settings_repository.dart';
import '../../time_records/data/work_record_repository.dart';
import '../application/backup_service.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  final _jsonController = TextEditingController();
  final _service = const BackupService();
  final _shareService = const ReportShareService();
  BackupPreview? _preview;
  String? _errorMessage;
  var _isWorking = false;

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สำรองและกู้คืนข้อมูล')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _BackupCard(
                isWorking: _isWorking,
                onShare: _shareBackup,
                onCopy: _copyBackup,
              ),
              const SizedBox(height: 12),
              _RestoreCard(
                controller: _jsonController,
                isWorking: _isWorking,
                preview: _preview,
                errorMessage: _errorMessage,
                onPaste: _pasteFromClipboard,
                onPreview: _previewRestore,
                onRestore: _preview == null ? null : _restorePreview,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareBackup() async {
    await _runBackupAction((file) async {
      await _shareService.share(file);
    });
  }

  Future<void> _copyBackup() async {
    await _runBackupAction((file) async {
      await Clipboard.setData(ClipboardData(text: utf8.decode(file.bytes)));
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('คัดลอก JSON สำรองแล้ว')));
    });
  }

  Future<void> _runBackupAction(
    Future<void> Function(ReportExportFile file) action,
  ) async {
    setState(() => _isWorking = true);
    try {
      final records = await ref
          .read(workRecordRepositoryProvider)
          .fetchRecords();
      final settings = await ref.read(workSettingsProvider.future);
      final file = _service.exportJson(records: records, settings: settings);
      await action(file);
    } finally {
      if (mounted) {
        setState(() => _isWorking = false);
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';
    if (text.trim().isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ยังไม่มีข้อมูลในคลิปบอร์ด')),
      );
      return;
    }
    setState(() {
      _jsonController.text = text;
      _preview = null;
      _errorMessage = null;
    });
  }

  void _previewRestore() {
    try {
      final preview = _service.previewJson(_jsonController.text);
      setState(() {
        _preview = preview;
        _errorMessage = null;
      });
    } on BackupException catch (error) {
      setState(() {
        _preview = null;
        _errorMessage = error.message;
      });
    }
  }

  Future<void> _restorePreview() async {
    final preview = _preview;
    if (preview == null) {
      return;
    }
    setState(() => _isWorking = true);
    await ref.read(settingsRepositoryProvider).saveSettings(preview.settings);
    await ref.read(workRecordRepositoryProvider).saveRecords(preview.records);
    if (!mounted) {
      return;
    }
    setState(() {
      _isWorking = false;
      _preview = null;
      _jsonController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('กู้คืนข้อมูลแล้ว ${preview.recordCount} รายการ')),
    );
  }
}

class _BackupCard extends StatelessWidget {
  const _BackupCard({
    required this.isWorking,
    required this.onShare,
    required this.onCopy,
  });

  final bool isWorking;
  final VoidCallback onShare;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manual Backup',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'ส่งออกข้อมูลทั้งหมดเป็น JSON เก็บไว้ก่อนเปลี่ยนเครื่องหรือก่อนทดสอบ',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: isWorking ? null : onShare,
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Export JSON'),
                ),
                OutlinedButton.icon(
                  onPressed: isWorking ? null : onCopy,
                  icon: const Icon(Icons.copy),
                  label: const Text('คัดลอก JSON'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RestoreCard extends StatelessWidget {
  const _RestoreCard({
    required this.controller,
    required this.isWorking,
    required this.preview,
    required this.errorMessage,
    required this.onPaste,
    required this.onPreview,
    required this.onRestore,
  });

  final TextEditingController controller;
  final bool isWorking;
  final BackupPreview? preview;
  final String? errorMessage;
  final VoidCallback onPaste;
  final VoidCallback onPreview;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restore',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text('วาง JSON สำรอง แล้วตรวจสอบก่อนกู้คืนข้อมูล'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              minLines: 7,
              maxLines: 12,
              decoration: const InputDecoration(
                labelText: 'Backup JSON',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.data_object),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: isWorking ? null : onPaste,
                  icon: const Icon(Icons.content_paste),
                  label: const Text('วางจากคลิปบอร์ด'),
                ),
                FilledButton.icon(
                  onPressed: isWorking ? null : onPreview,
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('ตรวจสอบก่อนกู้คืน'),
                ),
              ],
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (preview != null) ...[
              const SizedBox(height: 16),
              _PreviewRow('Version', preview!.appVersion),
              _PreviewRow('Company', preview!.companyName),
              _PreviewRow('Employee', preview!.employeeName),
              _PreviewRow('Records', preview!.recordCount.toString()),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isWorking ? null : onRestore,
                  icon: const Icon(Icons.restore),
                  label: const Text('ยืนยันการกู้คืน'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
