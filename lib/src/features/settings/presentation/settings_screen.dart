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
  final _otRate1Controller = TextEditingController();
  final _otRate15Controller = TextEditingController();
  final _otRate2Controller = TextEditingController();
  final _otRate3Controller = TextEditingController();
  final _travelAllowanceDefaultController = TextEditingController();
  final _socialSecurityDeductionController = TextEditingController();
  final _taxDeductionController = TextEditingController();
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
    _otRate1Controller.dispose();
    _otRate15Controller.dispose();
    _otRate2Controller.dispose();
    _otRate3Controller.dispose();
    _travelAllowanceDefaultController.dispose();
    _socialSecurityDeductionController.dispose();
    _taxDeductionController.dispose();
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
                _SectionTitle('ลักษณะการแสดงผล'),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ธีมแอป',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
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
                  ),
                ),
                const SizedBox(height: 20),
                _SectionTitle('ข้อมูลบริษัทและพนักงาน'),
                _TextField(
                  controller: _companyNameController,
                  label: 'ชื่อบริษัท',
                  icon: Icons.business,
                ),
                _TextField(
                  controller: _employeeNameController,
                  label: 'ชื่อพนักงาน',
                  icon: Icons.person,
                ),
                _TextField(
                  controller: _employeeIdController,
                  label: 'รหัสพนักงาน',
                  icon: Icons.badge,
                ),
                const SizedBox(height: 16),
                _SectionTitle('ค่าจ้างและเวลาทำงาน'),
                _NumberField(
                  controller: _monthlySalaryController,
                  label: 'เงินเดือน',
                  icon: Icons.account_balance_wallet,
                ),
                _NumberField(
                  controller: _dailyWageController,
                  label: 'ค่าแรงรายวัน',
                  icon: Icons.payments,
                ),
                _NumberField(
                  controller: _normalWorkHoursController,
                  label: 'ชั่วโมงทำงานปกติ',
                  icon: Icons.schedule,
                ),
                _NumberField(
                  controller: _defaultBreakMinutesController,
                  label: 'เวลาพักเริ่มต้น (นาที)',
                  icon: Icons.free_breakfast,
                  integerOnly: true,
                ),
                const SizedBox(height: 16),
                _SectionTitle('อัตรา OT และค่าเริ่มต้น'),
                _NumberField(
                  controller: _otRate1Controller,
                  label: 'OT 1x',
                  icon: Icons.looks_one,
                ),
                _NumberField(
                  controller: _otRate15Controller,
                  label: 'OT 1.5x',
                  icon: Icons.more_time,
                ),
                _NumberField(
                  controller: _otRate2Controller,
                  label: 'OT 2x',
                  icon: Icons.looks_two,
                ),
                _NumberField(
                  controller: _otRate3Controller,
                  label: 'OT 3x',
                  icon: Icons.looks_3,
                ),
                _NumberField(
                  controller: _travelAllowanceDefaultController,
                  label: 'ค่าเดินทางเริ่มต้น',
                  icon: Icons.directions_car,
                ),
                const SizedBox(height: 16),
                _SectionTitle('รายการหัก'),
                _NumberField(
                  controller: _socialSecurityDeductionController,
                  label: 'ประกันสังคม',
                  icon: Icons.health_and_safety,
                ),
                _NumberField(
                  controller: _taxDeductionController,
                  label: 'ภาษีหัก ณ ที่จ่าย',
                  icon: Icons.receipt,
                ),
                const SizedBox(height: 20),
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
    _otRate1Controller.text = _formatInitial(settings.otRate1);
    _otRate15Controller.text = _formatInitial(settings.otRate15);
    _otRate2Controller.text = _formatInitial(settings.otRate2);
    _otRate3Controller.text = _formatInitial(settings.otRate3);
    _travelAllowanceDefaultController.text = _formatInitial(
      settings.travelAllowanceDefault,
    );
    _socialSecurityDeductionController.text = _formatInitial(
      settings.socialSecurityDeduction,
    );
    _taxDeductionController.text = _formatInitial(settings.taxDeduction);
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
      otRate1: _parseDouble(_otRate1Controller),
      otRate15: _parseDouble(_otRate15Controller),
      otRate2: _parseDouble(_otRate2Controller),
      otRate3: _parseDouble(_otRate3Controller),
      travelAllowanceDefault: _parseDouble(_travelAllowanceDefaultController),
      socialSecurityDeduction: _parseDouble(_socialSecurityDeductionController),
      taxDeduction: _parseDouble(_taxDeductionController),
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

  String _formatInitial(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  IconData _themeIcon(AppThemePreference preference) {
    return switch (preference) {
      AppThemePreference.light => Icons.light_mode,
      AppThemePreference.dark => Icons.dark_mode,
      AppThemePreference.system => Icons.brightness_auto,
    };
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
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
    required this.icon,
    this.integerOnly = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
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
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
