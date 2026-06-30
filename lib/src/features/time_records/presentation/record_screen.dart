import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/thai_formatters.dart';
import '../../../core/widgets/friendly_states.dart';
import '../../help/presentation/help_screen.dart';
import '../../settings/data/settings_repository.dart';
import '../../settings/domain/work_settings.dart';
import '../../settings/presentation/settings_screen.dart';
import '../application/work_calculator.dart';
import '../data/work_record_repository.dart';
import '../domain/work_record.dart';
import 'today_summary.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({
    super.key,
    this.initialRecord,
    this.initialDate,
    this.onSaved,
    this.showTodaySummary = false,
    this.onViewMonth,
    this.onExport,
  });

  final WorkRecordEntity? initialRecord;
  final DateTime? initialDate;
  final VoidCallback? onSaved;
  final bool showTodaySummary;
  final VoidCallback? onViewMonth;
  final VoidCallback? onExport;

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formSectionKey = GlobalKey();
  final _checkInFieldKey = GlobalKey();
  final _checkInFocusNode = FocusNode();
  final _scrollController = ScrollController();
  final _breakController = TextEditingController();
  final _extraOtController = TextEditingController();
  final _travelController = TextEditingController();
  final _specialController = TextEditingController();
  final _expenseController = TextEditingController();
  final _noteController = TextEditingController();
  final _calculator = const WorkCalculator();
  Timer? _highlightTimer;

  late DateTime _workDate;
  late TimeOfDay _checkIn;
  late TimeOfDay _checkOut;
  late DayType _dayType;
  var _appliedSettingsDefaults = false;
  var _highlightFirstRequiredField = false;

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
    _highlightTimer?.cancel();
    _checkInFocusNode.dispose();
    _scrollController.dispose();
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
    final records = ref.watch(workRecordsProvider);

    return settings.when(
      data: (settings) => records.when(
        data: (items) => _buildForm(settings, isFirstLaunch: items.isEmpty),
        error: (error, stackTrace) => const FriendlyError(),
        loading: () => const FriendlyLoading(message: 'กำลังโหลดข้อมูล...'),
      ),
      error: (error, stackTrace) => const FriendlyError(),
      loading: () => const FriendlyLoading(message: 'กำลังโหลดข้อมูล...'),
    );
  }

  Widget _buildForm(WorkSettings settings, {required bool isFirstLaunch}) {
    _applySettingsDefaults(settings);
    final previewRecord = _buildRecord(settings, persist: false);
    final calculation = _calculator.calculateDaily(previewRecord, settings);
    final showFirstLaunch =
        widget.showTodaySummary && isFirstLaunch && !_isEditing;

    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  (widget.showTodaySummary ? 112 : 32) +
                      MediaQuery.viewInsetsOf(context).bottom,
                ),
                children: [
                  if (showFirstLaunch) ...[
                    _FirstLaunchWelcome(
                      onStart: () => _startNewRecord(settings),
                    ),
                    const SizedBox(height: 16),
                    _QuickStartCard(
                      onSettings: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const SettingsScreen(),
                        ),
                      ),
                      onAddRecord: () => _startNewRecord(settings),
                      onViewSummary: widget.onViewMonth ?? () {},
                    ),
                    const SizedBox(height: 16),
                  ] else if (widget.showTodaySummary) ...[
                    TodaySummary(
                      onAddRecord: () => _startNewRecord(settings),
                      onViewMonth: widget.onViewMonth ?? () {},
                      onExport: widget.onExport ?? () {},
                    ),
                    const SizedBox(height: 24),
                  ],
                  KeyedSubtree(
                    key: _formSectionKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _isEditing ? 'แก้ไขบันทึก' : 'บันทึกเวลาทำงาน',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const ContextHelpButton(
                          title: 'เพิ่มรายการเอง ใช้ตอนไหน',
                          message:
                              'ใช้หน้านี้เมื่อต้องการบันทึกย้อนหลัง หรือรู้เวลาเข้า-ออกอยู่แล้ว เลือกวันที่ เวลาเข้า เวลาออก แล้วกดบันทึกได้เลย',
                          tooltip: 'อธิบายการบันทึกเอง',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('เลือกวันที่ กรอกเวลา แล้วกดบันทึก'),
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
                          key: _checkInFieldKey,
                          focusNode: _checkInFocusNode,
                          icon: Icons.login,
                          label: 'เวลาเข้า',
                          value: _checkIn.format(context),
                          highlighted: _highlightFirstRequiredField,
                          inputKey: const Key('record-check-in-field'),
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
                  TextFormField(
                    controller: _noteController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'หมายเหตุ (ไม่บังคับ)',
                      prefixIcon: Icon(Icons.notes),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _LiveSummary(calculation: calculation),
                  const SizedBox(height: 4),
                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                    leading: const Icon(Icons.tune),
                    title: const Text('รายละเอียดเพิ่มเติม'),
                    subtitle: const Text(
                      'วันหยุด, เวลาพัก, ค่าเดินทาง, ค่าใช้จ่าย',
                    ),
                    childrenPadding: const EdgeInsets.only(bottom: 4),
                    children: [
                      const SizedBox(height: 4),
                      SegmentedButton<DayType>(
                        segments: DayType.values.map((type) {
                          return ButtonSegment(
                            value: type,
                            label: Text(_shortType(type)),
                          );
                        }).toList(),
                        selected: {_dayType},
                        onSelectionChanged: (selection) {
                          setState(() => _dayType = selection.first);
                        },
                      ),
                      const SizedBox(height: 16),
                      _NumberField(
                        controller: _breakController,
                        label: 'เวลาพัก (นาที) ถ้ามี',
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () => _save(settings),
                      icon: const Icon(Icons.save),
                      label: Text(
                        _isEditing ? 'บันทึกการแก้ไข' : 'บันทึก',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.showTodaySummary && !_isEditing)
            _StickyAddRecordButton(onPressed: () => _startNewRecord(settings)),
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

    final recordsBeforeSave = ref.read(workRecordsProvider).asData?.value;
    final isFirstSavedRecord =
        widget.showTodaySummary &&
        !_isEditing &&
        (recordsBeforeSave?.isEmpty ?? false);

    await ref
        .read(workRecordRepositoryProvider)
        .saveRecord(_buildRecord(settings, persist: true));

    if (!mounted) {
      return;
    }

    _reset(settings);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('บันทึกเวลาทำงานเรียบร้อย')));

    if (isFirstSavedRecord) {
      await _showFirstRecordCelebration(settings);
      return;
    }

    if (widget.onSaved != null) {
      widget.onSaved!.call();
      return;
    }
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
      isDemo: current?.isDemo ?? false,
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

  void _startNewRecord(WorkSettings settings) {
    _reset(settings);
    setState(() => _highlightFirstRequiredField = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('กรอกเวลาเข้าและออกงาน แล้วกดบันทึก')),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _scrollToFirstRequiredField();
      _checkInFocusNode.requestFocus();
      _highlightTimer?.cancel();
      _highlightTimer = Timer(const Duration(milliseconds: 1400), () {
        if (mounted) {
          setState(() => _highlightFirstRequiredField = false);
        }
      });
    });
  }

  Future<void> _showFirstRecordCelebration(WorkSettings settings) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.celebration),
          title: const Text('เยี่ยมมาก'),
          content: const Text('บันทึกวันทำงานแรกสำเร็จแล้ว'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewRecord(settings);
              },
              child: const Text('เพิ่มรายการอีกวัน'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onViewMonth?.call();
              },
              child: const Text('ดูรายงาน'),
            ),
          ],
        );
      },
    );
  }

  void _scrollToFirstRequiredField() {
    final targetContext =
        _checkInFieldKey.currentContext ?? _formSectionKey.currentContext;
    if (targetContext != null) {
      if (!targetContext.mounted) {
        return;
      }
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: 0.02,
      );
      return;
    }

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
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
            _SummaryRow('เวลาทำงาน', formatHours(calculation.totalWorkHours)),
            _SummaryRow('เวลาปกติ', formatHours(calculation.normalHours)),
            _SummaryRow('เวลาล่วงเวลา', formatHours(calculation.otHours)),
            _SummaryRow('รายได้วันนี้', formatMoney(calculation.dailyIncome)),
            _SummaryRow(
              'สุทธิหลังหักค่าใช้จ่าย',
              formatMoney(calculation.netIncome),
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: const Text('วิธีคำนวณ'),
              children: [
                _SummaryRow('เวลาปกติ', formatHours(calculation.normalHours)),
                _SummaryRow(
                  'เวลาล่วงเวลา (OT)',
                  formatHours(calculation.otHours),
                ),
                _SummaryRow('ค่าแรงปกติ', formatMoney(calculation.baseIncome)),
                _SummaryRow('ค่าแรง OT', formatMoney(calculation.otIncome)),
                _SummaryRow('รวม', formatMoney(calculation.dailyIncome)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FirstLaunchWelcome extends StatelessWidget {
  const _FirstLaunchWelcome({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ยังไม่มีข้อมูล',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'เริ่มต้นด้วยการกด "เพิ่มรายการ"\nเพื่อบันทึกเวลาทำงานรายการแรก',
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
          const SizedBox(height: 14),
          const Text(
            'เริ่มต้นโดยกด "เพิ่มรายการ"',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: onStart,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text(
                'เริ่มใช้งาน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStartCard extends StatelessWidget {
  const _QuickStartCard({
    required this.onSettings,
    required this.onAddRecord,
    required this.onViewSummary,
  });

  final VoidCallback onSettings;
  final VoidCallback onAddRecord;
  final VoidCallback onViewSummary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เริ่มต้นใช้งาน',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _QuickStartStep(
              number: 1,
              label: 'ตั้งค่าเงินเดือน',
              onTap: onSettings,
            ),
            _QuickStartStep(
              number: 2,
              label: 'ตั้งค่าเวลาทำงาน',
              onTap: onSettings,
            ),
            _QuickStartStep(
              number: 3,
              label: 'เพิ่มรายการแรก',
              onTap: onAddRecord,
            ),
            _QuickStartStep(
              number: 4,
              label: 'ดูสรุปรายได้',
              onTap: onViewSummary,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStartStep extends StatelessWidget {
  const _QuickStartStep({
    required this.number,
    required this.label,
    required this.onTap,
  });

  final int number;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(radius: 16, child: Text('$number')),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _StickyAddRecordButton extends StatelessWidget {
  const _StickyAddRecordButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16 + MediaQuery.paddingOf(context).bottom,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text(
                'เพิ่มรายการ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
          ),
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
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.highlighted = false,
    this.inputKey,
    this.focusNode,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool highlighted;
  final Key? inputKey;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        focusNode: focusNode,
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: InputDecorator(
          key: inputKey,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            filled: highlighted,
            fillColor: highlighted
                ? Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.45)
                : null,
            border: const OutlineInputBorder(),
            enabledBorder: highlighted
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  )
                : const OutlineInputBorder(),
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
