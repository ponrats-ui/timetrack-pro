import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../settings/data/settings_repository.dart';
import '../../settings/domain/work_settings.dart';
import '../../time_records/data/work_record_repository.dart';
import '../../time_records/domain/work_record.dart';
import '../application/employee_data_transfer_service.dart';

class EmployeeImportScreen extends ConsumerStatefulWidget {
  const EmployeeImportScreen({super.key});

  @override
  ConsumerState<EmployeeImportScreen> createState() =>
      _EmployeeImportScreenState();
}

class _EmployeeImportScreenState extends ConsumerState<EmployeeImportScreen> {
  final _jsonController = TextEditingController();
  final _fileNameController = TextEditingController(text: 'employee.json');
  final _service = const EmployeeDataTransferService();
  EmployeeImportPreview? _preview;
  String? _errorMessage;
  var _isImporting = false;

  @override
  void dispose() {
    _jsonController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(workRecordsProvider);
    final settings = ref.watch(workSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('นำเข้าข้อมูลพนักงาน')),
      body: records.when(
        data: (items) => settings.when(
          data: (workSettings) => Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  const _ImportIntroCard(),
                  TextField(
                    controller: _fileNameController,
                    decoration: const InputDecoration(
                      labelText: 'ชื่อไฟล์',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _jsonController,
                    minLines: 8,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      labelText: 'วางข้อมูล JSON จาก TimeTrack Pro',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.data_object),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      setState(() {
                        _preview = null;
                        _errorMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _pasteFromClipboard,
                        icon: const Icon(Icons.content_paste),
                        label: const Text('วางจากคลิปบอร์ด'),
                      ),
                      FilledButton.icon(
                        onPressed: () => _previewJson(items, workSettings),
                        icon: const Icon(Icons.fact_check_outlined),
                        label: const Text('ตรวจสอบก่อนนำเข้า'),
                      ),
                    ],
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    _ImportMessage(
                      icon: Icons.error_outline,
                      message: _errorMessage!,
                      isWarning: true,
                    ),
                  ],
                  if (_preview != null) ...[
                    const SizedBox(height: 16),
                    _PreviewCard(
                      preview: _preview!,
                      isImporting: _isImporting,
                      onConfirm: _preview!.importableCount == 0
                          ? null
                          : () => _confirmImport(_preview!),
                    ),
                  ],
                ],
              ),
            ),
          ),
          error: (_, _) => const Center(child: Text('เปิดการตั้งค่าไม่ได้')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => const Center(child: Text('เปิดรายการทำงานไม่ได้')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
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

  void _previewJson(
    List<WorkRecordEntity> existingRecords,
    WorkSettings workSettings,
  ) {
    try {
      final preview = _service.previewJson(
        jsonText: _jsonController.text,
        existingRecords: existingRecords,
        currentSettings: workSettings,
        sourceFileName: _fileNameController.text.trim().isEmpty
            ? 'employee.json'
            : _fileNameController.text.trim(),
      );
      setState(() {
        _preview = preview;
        _errorMessage = null;
      });
    } on EmployeeImportException catch (error) {
      setState(() {
        _preview = null;
        _errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        _preview = null;
        _errorMessage = 'นำเข้าไม่ได้ ลองตรวจไฟล์อีกครั้งครับ';
      });
    }
  }

  Future<void> _confirmImport(EmployeeImportPreview preview) async {
    setState(() => _isImporting = true);
    await ref
        .read(workRecordRepositoryProvider)
        .saveRecords(preview.recordsToImport);
    if (!mounted) {
      return;
    }
    setState(() {
      _isImporting = false;
      _preview = null;
      _jsonController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('นำเข้าแล้ว ${preview.importableCount} รายการ')),
    );
  }
}

class _ImportIntroCard extends StatelessWidget {
  const _ImportIntroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'นำไฟล์จากพนักงานมาตรวจดูก่อน',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'ตอนนี้รองรับไฟล์ JSON จาก TimeTrack Pro ก่อน PDF ยังใช้สำหรับอ่านรายงานเท่านั้น ไม่ใช้รวมเงินเดือนอัตโนมัติ',
              style: TextStyle(height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.preview,
    required this.isImporting,
    required this.onConfirm,
  });

  final EmployeeImportPreview preview;
  final bool isImporting;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ตรวจสอบก่อนนำเข้า',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _PreviewRow('พนักงาน', preview.employeeName),
            _PreviewRow('รหัสพนักงาน', preview.employeeId),
            _PreviewRow(
              'ช่วงวันที่',
              '${formatShortDate(preview.dateFrom)} - '
                  '${formatShortDate(preview.dateTo)}',
            ),
            _PreviewRow('จำนวนรายการ', '${preview.recordCount} รายการ'),
            _PreviewRow('ชั่วโมงรวม', formatHours(preview.totalHours)),
            _PreviewRow('OT รวม', formatHours(preview.totalOtHours)),
            _PreviewRow('รายได้ประมาณการ', formatMoney(preview.estimatedPay)),
            _PreviewRow('นำเข้าได้', '${preview.importableCount} รายการ'),
            if (preview.hasDuplicates) ...[
              const SizedBox(height: 12),
              const _ImportMessage(
                icon: Icons.warning_amber,
                message: 'พบบางรายการที่มีอยู่แล้ว',
                isWarning: true,
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isImporting ? null : onConfirm,
                icon: isImporting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.playlist_add_check),
                label: const Text('ยืนยันการนำเข้า'),
              ),
            ),
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

class _ImportMessage extends StatelessWidget {
  const _ImportMessage({
    required this.icon,
    required this.message,
    required this.isWarning,
  });

  final IconData icon;
  final String message;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final color = isWarning
        ? Theme.of(context).colorScheme.errorContainer
        : Theme.of(context).colorScheme.primaryContainer;
    final onColor = isWarning
        ? Theme.of(context).colorScheme.onErrorContainer
        : Theme.of(context).colorScheme.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: onColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(color: onColor)),
          ),
        ],
      ),
    );
  }
}
