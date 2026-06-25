import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../settings/data/settings_repository.dart';
import '../../settings/domain/work_settings.dart';
import '../application/work_calculator.dart';
import '../data/work_record_repository.dart';
import '../domain/work_record.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({
    super.key,
    this.initialRecord,
    this.initialDate,
    this.onSaved,
  });

  final WorkRecordEntity? initialRecord;
  final DateTime? initialDate;
  final VoidCallback? onSaved;

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _breakController = TextEditingController();
  final _extraOtController = TextEditingController();
  final _travelController = TextEditingController();
  final _specialController = TextEditingController();
  final _expenseController = TextEditingController();
  final _noteController = TextEditingController();
  final _calculator = const WorkCalculator();

  late DateTime _workDate;
  late TimeOfDay _checkIn;
  late TimeOfDay _checkOut;
  late DayType _dayType;
  var _appliedSettingsDefaults = false;

  bool get _isEditing => widget.initialRecord != null;

  @override
  void initState() {
    super.initState();
    final record = widget.initialRecord;
    _workDate = record?.workDate ?? widget.initialDate ?? DateTime.now();
    _checkIn = _timeOfDay(record?.checkInMinutes ?? 8 * 60);
    _checkOut = _timeOfDay(record?.checkOutMinutes ?? 17 * 60);
    _dayType = record?.dayType ?? DayType.normal;
    _breakController.text = _initialNumber(record?.breakMinutes.toDouble());
    _extraOtController.text = _initialNumber(record?.extraOtHours);
    _travelController.text = _initialNumber(record?.travelAllowance);
    _specialController.text = _initialNumber(record?.specialAllowance);
    _expenseController.text = _initialNumber(record?.expense);
    _noteController.text = record?.note ?? '';
  }

  @override
  void dispose() {
    _breakController.dispose();
    _extraOtController.dispose();
    _travelController.dispose();
    _specialController.dispose();
    _expenseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(workSettingsProvider);

    return settings.when(
      data: _buildForm,
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildForm(WorkSettings settings) {
    _applySettingsDefaults(settings);
    final previewRecord = _buildRecord(settings, persist: false);
    final calculation = _calculator.calculateDaily(previewRecord, settings);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _isEditing ? 'แก้ไขบันทึก' : 'บันทึกเวลาทำงาน',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _PickerTile(
            icon: Icons.event,
            label: 'วันที่',
            value: formatThaiDate(_workDate),
            onTap: _pickDate,
          ),
          Row(
            children: [
              Expanded(
                child: _PickerTile(
                  icon: Icons.login,
                  label: 'เวลาเข้า',
                  value: _checkIn.format(context),
                  onTap: () => _pickTime(isCheckIn: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerTile(
                  icon: Icons.logout,
                  label: 'เวลาออก',
                  value: _checkOut.format(context),
                  onTap: () => _pickTime(isCheckIn: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SegmentedButton<DayType>(
            segments: DayType.values.map((type) {
              return ButtonSegment(value: type, label: Text(_shortType(type)));
            }).toList(),
            selected: {_dayType},
            onSelectionChanged: (selection) {
              setState(() => _dayType = selection.first);
            },
          ),
          const SizedBox(height: 16),
          _NumberField(
            controller: _breakController,
            label: 'เวลาพัก (นาที)',
            icon: Icons.free_breakfast,
            onChanged: (_) => setState(() {}),
          ),
          _NumberField(
            controller: _extraOtController,
            label: 'OT เพิ่มเติม (ชั่วโมง)',
            icon: Icons.more_time,
            onChanged: (_) => setState(() {}),
          ),
          _NumberField(
            controller: _travelController,
            label: 'ค่าเดินทาง',
            icon: Icons.directions_car,
            onChanged: (_) => setState(() {}),
          ),
          _NumberField(
            controller: _specialController,
            label: 'เบี้ยพิเศษ',
            icon: Icons.payments,
            onChanged: (_) => setState(() {}),
          ),
          _NumberField(
            controller: _expenseController,
            label: 'ค่าใช้จ่าย',
            icon: Icons.receipt_long,
            onChanged: (_) => setState(() {}),
          ),
          TextFormField(
            controller: _noteController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'หมายเหตุ',
              prefixIcon: Icon(Icons.notes),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          _LiveSummary(calculation: calculation),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _save(settings),
            icon: const Icon(Icons.save),
            label: Text(_isEditing ? 'บันทึกการแก้ไข' : 'บันทึก'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _workDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() => _workDate = picked);
    }
  }

  Future<void> _pickTime({required bool isCheckIn}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isCheckIn ? _checkIn : _checkOut,
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  Future<void> _save(WorkSettings settings) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(workRecordRepositoryProvider)
        .saveRecord(_buildRecord(settings, persist: true));

    if (!mounted) {
      return;
    }

    widget.onSaved?.call();
    _reset(settings);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อย')));
  }

  WorkRecordEntity _buildRecord(
    WorkSettings settings, {
    required bool persist,
  }) {
    final now = DateTime.now();
    final current = widget.initialRecord;
    return WorkRecordEntity(
      id: current?.id ?? now.microsecondsSinceEpoch.toString(),
      workDate: DateTime(_workDate.year, _workDate.month, _workDate.day),
      checkInMinutes: _minutes(_checkIn),
      checkOutMinutes: _minutes(_checkOut),
      breakMinutes:
          int.tryParse(_breakController.text.trim()) ??
          settings.defaultBreakMinutes,
      dayType: _dayType,
      extraOtHours: _parseDouble(_extraOtController.text),
      travelAllowance: _parseDouble(_travelController.text),
      specialAllowance: _parseDouble(_specialController.text),
      expense: _parseDouble(_expenseController.text),
      note: _noteController.text.trim(),
      createdAt: current?.createdAt ?? now,
      updatedAt: persist ? now : current?.updatedAt ?? now,
    );
  }

  void _reset(WorkSettings settings) {
    if (_isEditing) {
      return;
    }

    _breakController.text = settings.defaultBreakMinutes.toString();
    _extraOtController.clear();
    _travelController.text = _initialNumber(settings.travelAllowanceDefault);
    _specialController.clear();
    _expenseController.clear();
    _noteController.clear();
    setState(() {
      _workDate = widget.initialDate ?? DateTime.now();
      _checkIn = const TimeOfDay(hour: 8, minute: 0);
      _checkOut = const TimeOfDay(hour: 17, minute: 0);
      _dayType = DayType.normal;
    });
  }

  TimeOfDay _timeOfDay(int minutes) {
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  int _minutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  double _parseDouble(String value) {
    return double.tryParse(value.trim()) ?? 0;
  }

  String _initialNumber(double? value) {
    if (value == null || value == 0) {
      return '';
    }

    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  String _shortType(DayType type) {
    return switch (type) {
      DayType.normal => 'ปกติ',
      DayType.weekend => 'สุดสัปดาห์',
      DayType.holiday => 'วันหยุด',
    };
  }

  void _applySettingsDefaults(WorkSettings settings) {
    if (_isEditing || _appliedSettingsDefaults) {
      return;
    }

    _breakController.text = settings.defaultBreakMinutes.toString();
    _travelController.text = _initialNumber(settings.travelAllowanceDefault);
    _appliedSettingsDefaults = true;
  }
}

class _LiveSummary extends StatelessWidget {
  const _LiveSummary({required this.calculation});

  final DailyCalculation calculation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สรุปก่อนบันทึก',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _SummaryRow('ชั่วโมงรวม', formatHours(calculation.totalWorkHours)),
            _SummaryRow('ชั่วโมงปกติ', formatHours(calculation.normalHours)),
            _SummaryRow('OT', formatHours(calculation.otHours)),
            _SummaryRow('รายได้วันนี้', formatMoney(calculation.dailyIncome)),
            _SummaryRow(
              'สุทธิหลังหักค่าใช้จ่าย',
              formatMoney(calculation.netIncome),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
          child: Text(value),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) {
            return null;
          }

          return double.tryParse(text) == null ? 'กรุณากรอกตัวเลข' : null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
