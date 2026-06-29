import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../time_records/application/demo_data_service.dart';
import '../data/settings_repository.dart';
import '../domain/work_settings.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  var _loadedSettings = const WorkSettings.defaults();
  var _isInitialized = false;
  var _themePreference = AppThemePreference.system;

  TextEditingController _controller(String key) {
    return _controllers.putIfAbsent(key, TextEditingController.new);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
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
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
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
                        _number('monthlySalary', 'เงินเดือน'),
                        _number('dailyWage', 'ค่าแรงรายวัน'),
                        _number('normalWorkHours', 'ชั่วโมงทำงานปกติต่อวัน'),
                        _number(
                          'defaultBreakMinutes',
                          'หักเวลาพักอัตโนมัติ (นาที, 0 = ไม่หัก)',
                          integerOnly: true,
                        ),
                        _number('normalDayMultiplier', 'ตัวคูณวันทำงานปกติ'),
                        _number(
                          'weekendDayMultiplier',
                          'ตัวคูณวันหยุดสุดสัปดาห์',
                        ),
                        _number(
                          'holidayDayMultiplier',
                          'ตัวคูณวันหยุดนักขัตฤกษ์',
                        ),
                      ],
                    ),
                    _SettingsCard(
                      title: 'ล่วงเวลาและกะกลางคืน',
                      icon: Icons.more_time,
                      children: [
                        _number('normalOtMultiplier', 'ตัวคูณ OT วันปกติ'),
                        _number(
                          'weekendOtMultiplier',
                          'ตัวคูณ OT วันหยุดสุดสัปดาห์',
                        ),
                        _number(
                          'holidayOtMultiplier',
                          'ตัวคูณ OT วันหยุดนักขัตฤกษ์',
                        ),
                        _number('nightOtMultiplier', 'ตัวคูณกะกลางคืน'),
                        Row(
                          children: [
                            Expanded(
                              child: _TimeField(
                                controller: _controller(
                                  'nightShiftStartMinutes',
                                ),
                                label: 'เริ่มกะกลางคืน',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TimeField(
                                controller: _controller('nightShiftEndMinutes'),
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
                        _number('mealAllowanceDefault', 'ค่าอาหารเริ่มต้น'),
                        _number('travelAllowanceDefault', 'ค่าเดินทางเริ่มต้น'),
                        _number(
                          'otherAllowanceDefault',
                          'ค่าเบี้ยพิเศษอื่น ๆ เริ่มต้น',
                        ),
                      ],
                    ),
                    _SettingsCard(
                      title: 'รายการหัก',
                      icon: Icons.receipt_long,
                      children: [
                        _number('socialSecurityDeduction', 'ประกันสังคม'),
                        _number('taxDeduction', 'ภาษีหัก ณ ที่จ่าย'),
                      ],
                    ),
                    _SettingsCard(
                      title: 'บริษัทและพนักงาน',
                      icon: Icons.business,
                      children: [
                        _text('companyName', 'ชื่อบริษัท'),
                        _text('employeeName', 'ชื่อพนักงาน'),
                        _text('employeeId', 'รหัสพนักงาน'),
                      ],
                    ),
                    _SettingsCard(
                      title: 'ข้อมูลตัวอย่าง',
                      icon: Icons.auto_awesome_motion,
                      children: [
                        const Text(
                          'ลบเฉพาะข้อมูลตัวอย่างที่ระบบสร้างไว้ ข้อมูลใช้งานจริงจะไม่ถูกลบ',
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _confirmResetDemoData,
                          icon: const Icon(Icons.delete_sweep),
                          label: const Text('ลบข้อมูลตัวอย่าง'),
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
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _number(String key, String label, {bool integerOnly = false}) {
    return _NumberField(
      controller: _controller(key),
      label: label,
      integerOnly: integerOnly,
    );
  }

  Widget _text(String key, String label) {
    return _TextField(controller: _controller(key), label: label);
  }

  void _load(WorkSettings settings) {
    _loadedSettings = settings;
    _isInitialized = true;
    _controller('monthlySalary').text = _formatInitial(settings.monthlySalary);
    _controller('dailyWage').text = _formatInitial(settings.dailyWage);
    _controller('normalWorkHours').text = _formatInitial(
      settings.normalWorkHours,
    );
    _controller('defaultBreakMinutes').text = settings.defaultBreakMinutes
        .toString();
    _controller('normalDayMultiplier').text = _formatInitial(
      settings.normalDayMultiplier,
    );
    _controller('weekendDayMultiplier').text = _formatInitial(
      settings.weekendDayMultiplier,
    );
    _controller('holidayDayMultiplier').text = _formatInitial(
      settings.holidayDayMultiplier,
    );
    _controller('normalOtMultiplier').text = _formatInitial(
      settings.normalOtMultiplier,
    );
    _controller('weekendOtMultiplier').text = _formatInitial(
      settings.weekendOtMultiplier,
    );
    _controller('holidayOtMultiplier').text = _formatInitial(
      settings.holidayOtMultiplier,
    );
    _controller('nightOtMultiplier').text = _formatInitial(
      settings.nightOtMultiplier,
    );
    _controller('mealAllowanceDefault').text = _formatInitial(
      settings.mealAllowanceDefault,
    );
    _controller('travelAllowanceDefault').text = _formatInitial(
      settings.travelAllowanceDefault,
    );
    _controller('otherAllowanceDefault').text = _formatInitial(
      settings.otherAllowanceDefault,
    );
    _controller('socialSecurityDeduction').text = _formatInitial(
      settings.socialSecurityDeduction,
    );
    _controller('taxDeduction').text = _formatInitial(settings.taxDeduction);
    _controller('nightShiftStartMinutes').text = _formatMinutes(
      settings.nightShiftStartMinutes,
    );
    _controller('nightShiftEndMinutes').text = _formatMinutes(
      settings.nightShiftEndMinutes,
    );
    _controller('companyName').text = settings.companyName;
    _controller('employeeName').text = settings.employeeName;
    _controller('employeeId').text = settings.employeeId;
    _themePreference = settings.themePreference;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final settings = WorkSettings(
      monthlySalary: _parseDouble('monthlySalary'),
      dailyWage: _parseDouble('dailyWage'),
      normalWorkHours: _parseDouble('normalWorkHours'),
      normalDayMultiplier: _parseDouble('normalDayMultiplier'),
      weekendDayMultiplier: _parseDouble('weekendDayMultiplier'),
      holidayDayMultiplier: _parseDouble('holidayDayMultiplier'),
      normalOtMultiplier: _parseDouble('normalOtMultiplier'),
      weekendOtMultiplier: _parseDouble('weekendOtMultiplier'),
      holidayOtMultiplier: _parseDouble('holidayOtMultiplier'),
      nightOtMultiplier: _parseDouble('nightOtMultiplier'),
      mealAllowanceDefault: _parseDouble('mealAllowanceDefault'),
      travelAllowanceDefault: _parseDouble('travelAllowanceDefault'),
      otherAllowanceDefault: _parseDouble('otherAllowanceDefault'),
      socialSecurityDeduction: _parseDouble('socialSecurityDeduction'),
      taxDeduction: _parseDouble('taxDeduction'),
      nightShiftStartMinutes: _parseMinutes('nightShiftStartMinutes'),
      nightShiftEndMinutes: _parseMinutes('nightShiftEndMinutes'),
      defaultBreakMinutes: int.parse(_controller('defaultBreakMinutes').text),
      companyName: _controller('companyName').text.trim(),
      employeeName: _controller('employeeName').text.trim(),
      employeeId: _controller('employeeId').text.trim(),
      themePreference: _themePreference,
      onboardingCompleted: _loadedSettings.onboardingCompleted,
    );

    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('บันทึกการตั้งค่าเรียบร้อย')));
  }

  Future<void> _confirmResetDemoData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ลบข้อมูลตัวอย่าง?'),
          content: const Text(
            'ระบบจะลบเฉพาะรายการตัวอย่างเท่านั้น ข้อมูลที่คุณบันทึกจริงจะยังอยู่',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('ยกเลิก'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete_sweep),
              label: const Text('ลบข้อมูลตัวอย่าง'),
            ),
          ],
        );
      },
    );

    if (!(confirmed ?? false)) {
      return;
    }

    final deleted = await ref.read(demoDataServiceProvider).resetDemoData();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ลบข้อมูลตัวอย่างแล้ว $deleted รายการ')),
    );
  }

  double _parseDouble(String key) {
    return double.parse(_controller(key).text.trim());
  }

  int _parseMinutes(String key) {
    final parts = _controller(key).text.trim().split(':');
    return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
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
