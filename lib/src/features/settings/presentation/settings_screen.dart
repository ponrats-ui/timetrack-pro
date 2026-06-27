import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';
import '../domain/work_settings.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlySalaryController = TextEditingController();
  final _dailyWageController = TextEditingController();
  final _normalWorkHoursController = TextEditingController();
  final _defaultBreakMinutesController = TextEditingController();
  final _normalDayMultiplierController = TextEditingController();
  final _weekendDayMultiplierController = TextEditingController();
  final _holidayDayMultiplierController = TextEditingController();
  final _normalOtMultiplierController = TextEditingController();
  final _weekendOtMultiplierController = TextEditingController();
  final _holidayOtMultiplierController = TextEditingController();
  final _nightOtMultiplierController = TextEditingController();
  final _mealAllowanceDefaultController = TextEditingController();
  final _travelAllowanceDefaultController = TextEditingController();
  final _otherAllowanceDefaultController = TextEditingController();
  final _socialSecurityDeductionController = TextEditingController();
  final _taxDeductionController = TextEditingController();
  final _nightShiftStartController = TextEditingController();
  final _nightShiftEndController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _employeeNameController = TextEditingController();
  final _employeeIdController = TextEditingController();

  var _loadedSettings = const WorkSettings.defaults();
  var _isInitialized = false;
  var _themePreference = AppThemePreference.system;

  @override
  void dispose() {
    _monthlySalaryController.dispose();
    _dailyWageController.dispose();
    _normalWorkHoursController.dispose();
    _defaultBreakMinutesController.dispose();
    _normalDayMultiplierController.dispose();
    _weekendDayMultiplierController.dispose();
    _holidayDayMultiplierController.dispose();
    _normalOtMultiplierController.dispose();
    _weekendOtMultiplierController.dispose();
    _holidayOtMultiplierController.dispose();
    _nightOtMultiplierController.dispose();
    _mealAllowanceDefaultController.dispose();
    _travelAllowanceDefaultController.dispose();
    _otherAllowanceDefaultController.dispose();
    _socialSecurityDeductionController.dispose();
    _taxDeductionController.dispose();
    _nightShiftStartController.dispose();
    _nightShiftEndController.dispose();
    _companyNameController.dispose();
    _employeeNameController.dispose();
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(workSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ตั้งค่า')),
      body: settings.when(
        data: (value) {
          if (!_isInitialized || value != _loadedSettings) {
            _load(value);
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _SettingsCard(
                  title: 'ธีมแอป',
                  icon: Icons.palette,
                  children: [
                    SegmentedButton<AppThemePreference>(
                      segments: AppThemePreference.values.map((item) {
                        return ButtonSegment(
                          value: item,
                          label: Text(item.label),
                          icon: Icon(_themeIcon(item)),
                        );
                      }).toList(),
                      selected: {_themePreference},
                      onSelectionChanged: (value) {
                        setState(() => _themePreference = value.first);
                      },
                    ),
                  ],
                ),
                _SettingsCard(
                  title: 'เงินเดือนและเวลาทำงาน',
                  icon: Icons.payments,
                  children: [
                    _NumberField(
                      controller: _monthlySalaryController,
                      label: 'เงินเดือน',
                    ),
                    _NumberField(
                      controller: _dailyWageController,
                      label: 'ค่าแรงรายวัน',
                    ),
                    _NumberField(
                      controller: _normalWorkHoursController,
                      label: 'ชั่วโมงทำงานปกติต่อวัน',
                    ),
                    _NumberField(
                      controller: _defaultBreakMinutesController,
                      label: 'เวลาพักเริ่มต้น (นาที)',
                      integerOnly: true,
                    ),
                    _NumberField(
                      controller: _normalDayMultiplierController,
                      label: 'ตัวคูณวันทำงานปกติ',
                    ),
                    _NumberField(
                      controller: _weekendDayMultiplierController,
                      label: 'ตัวคูณวันหยุดสุดสัปดาห์',
                    ),
                    _NumberField(
                      controller: _holidayDayMultiplierController,
                      label: 'ตัวคูณวันหยุดนักขัตฤกษ์',
                    ),
                  ],
                ),
                _SettingsCard(
                  title: 'ล่วงเวลาและกะกลางคืน',
                  icon: Icons.more_time,
                  children: [
                    _NumberField(
                      controller: _normalOtMultiplierController,
                      label: 'ตัวคูณ OT วันปกติ',
                    ),
                    _NumberField(
                      controller: _weekendOtMultiplierController,
                      label: 'ตัวคูณ OT วันหยุดสุดสัปดาห์',
                    ),
                    _NumberField(
                      controller: _holidayOtMultiplierController,
                      label: 'ตัวคูณ OT วันหยุดนักขัตฤกษ์',
                    ),
                    _NumberField(
                      controller: _nightOtMultiplierController,
                      label: 'ตัวคูณกะกลางคืน',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _TimeField(
                            controller: _nightShiftStartController,
                            label: 'เริ่มกะกลางคืน',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TimeField(
                            controller: _nightShiftEndController,
                            label: 'จบกะกลางคืน',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _SettingsCard(
                  title: 'ค่าเบี้ยเลี้ยง',
                  icon: Icons.card_giftcard,
                  children: [
                    _NumberField(
                      controller: _mealAllowanceDefaultController,
                      label: 'ค่าอาหารเริ่มต้น',
                    ),
                    _NumberField(
                      controller: _travelAllowanceDefaultController,
                      label: 'ค่าเดินทางเริ่มต้น',
                    ),
                    _NumberField(
                      controller: _otherAllowanceDefaultController,
                      label: 'ค่าเบี้ยพิเศษอื่น ๆ เริ่มต้น',
                    ),
                  ],
                ),
                _SettingsCard(
                  title: 'รายการหัก',
                  icon: Icons.receipt_long,
                  children: [
                    _NumberField(
                      controller: _socialSecurityDeductionController,
                      label: 'ประกันสังคม',
                    ),
                    _NumberField(
                      controller: _taxDeductionController,
                      label: 'ภาษีหัก ณ ที่จ่าย',
                    ),
                  ],
                ),
                _SettingsCard(
                  title: 'บริษัทและพนักงาน',
                  icon: Icons.business,
                  children: [
                    _TextField(
                      controller: _companyNameController,
                      label: 'ชื่อบริษัท',
                    ),
                    _TextField(
                      controller: _employeeNameController,
                      label: 'ชื่อพนักงาน',
                    ),
                    _TextField(
                      controller: _employeeIdController,
                      label: 'รหัสพนักงาน',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('บันทึกการตั้งค่า'),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _load(WorkSettings settings) {
    _loadedSettings = settings;
    _isInitialized = true;
    _monthlySalaryController.text = _formatInitial(settings.monthlySalary);
    _dailyWageController.text = _formatInitial(settings.dailyWage);
    _normalWorkHoursController.text = _formatInitial(settings.normalWorkHours);
    _defaultBreakMinutesController.text = settings.defaultBreakMinutes
        .toString();
    _normalDayMultiplierController.text = _formatInitial(
      settings.normalDayMultiplier,
    );
    _weekendDayMultiplierController.text = _formatInitial(
      settings.weekendDayMultiplier,
    );
    _holidayDayMultiplierController.text = _formatInitial(
      settings.holidayDayMultiplier,
    );
    _normalOtMultiplierController.text = _formatInitial(
      settings.normalOtMultiplier,
    );
    _weekendOtMultiplierController.text = _formatInitial(
      settings.weekendOtMultiplier,
    );
    _holidayOtMultiplierController.text = _formatInitial(
      settings.holidayOtMultiplier,
    );
    _nightOtMultiplierController.text = _formatInitial(
      settings.nightOtMultiplier,
    );
    _mealAllowanceDefaultController.text = _formatInitial(
      settings.mealAllowanceDefault,
    );
    _travelAllowanceDefaultController.text = _formatInitial(
      settings.travelAllowanceDefault,
    );
    _otherAllowanceDefaultController.text = _formatInitial(
      settings.otherAllowanceDefault,
    );
    _socialSecurityDeductionController.text = _formatInitial(
      settings.socialSecurityDeduction,
    );
    _taxDeductionController.text = _formatInitial(settings.taxDeduction);
    _nightShiftStartController.text = _formatMinutes(
      settings.nightShiftStartMinutes,
    );
    _nightShiftEndController.text = _formatMinutes(
      settings.nightShiftEndMinutes,
    );
    _companyNameController.text = settings.companyName;
    _employeeNameController.text = settings.employeeName;
    _employeeIdController.text = settings.employeeId;
    _themePreference = settings.themePreference;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final settings = WorkSettings(
      monthlySalary: _parseDouble(_monthlySalaryController),
      dailyWage: _parseDouble(_dailyWageController),
      normalWorkHours: _parseDouble(_normalWorkHoursController),
      normalDayMultiplier: _parseDouble(_normalDayMultiplierController),
      weekendDayMultiplier: _parseDouble(_weekendDayMultiplierController),
      holidayDayMultiplier: _parseDouble(_holidayDayMultiplierController),
      normalOtMultiplier: _parseDouble(_normalOtMultiplierController),
      weekendOtMultiplier: _parseDouble(_weekendOtMultiplierController),
      holidayOtMultiplier: _parseDouble(_holidayOtMultiplierController),
      nightOtMultiplier: _parseDouble(_nightOtMultiplierController),
      mealAllowanceDefault: _parseDouble(_mealAllowanceDefaultController),
      travelAllowanceDefault: _parseDouble(_travelAllowanceDefaultController),
      otherAllowanceDefault: _parseDouble(_otherAllowanceDefaultController),
      socialSecurityDeduction: _parseDouble(_socialSecurityDeductionController),
      taxDeduction: _parseDouble(_taxDeductionController),
      nightShiftStartMinutes: _parseMinutes(_nightShiftStartController),
      nightShiftEndMinutes: _parseMinutes(_nightShiftEndController),
      defaultBreakMinutes: int.parse(_defaultBreakMinutesController.text),
      companyName: _companyNameController.text.trim(),
      employeeName: _employeeNameController.text.trim(),
      employeeId: _employeeIdController.text.trim(),
      themePreference: _themePreference,
    );

    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('บันทึกการตั้งค่าเรียบร้อย')));
  }

  double _parseDouble(TextEditingController controller) {
    return double.parse(controller.text.trim());
  }

  int _parseMinutes(TextEditingController controller) {
    final parts = controller.text.trim().split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return (hours * 60) + minutes;
  }

  String _formatInitial(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  String _formatMinutes(int value) {
    final normalized = value % (24 * 60);
    final hours = normalized ~/ 60;
    final minutes = normalized % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }

  IconData _themeIcon(AppThemePreference preference) {
    return switch (preference) {
      AppThemePreference.light => Icons.light_mode,
      AppThemePreference.dark => Icons.dark_mode,
      AppThemePreference.system => Icons.brightness_auto,
    };
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    this.integerOnly = false,
  });

  final TextEditingController controller;
  final String label;
  final bool integerOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: !integerOnly),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }

          if (integerOnly) {
            return int.tryParse(text) == null ? 'กรุณากรอกจำนวนเต็ม' : null;
          }

          return double.tryParse(text) == null ? 'กรุณากรอกตัวเลข' : null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        validator: (value) {
          final text = value?.trim() ?? '';
          final match = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').firstMatch(text);
          return match == null ? 'กรุณากรอกเวลาแบบ 22:00' : null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
