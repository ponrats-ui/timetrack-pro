import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../help/presentation/help_screen.dart';
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
  var _workSchedule = WorkSchedule.mondayFriday;
  var _normalWorkSchedule = NormalWorkSchedule.eightToFive;
  var _payrollPolicyType = PayrollPolicyType.thaiLabour;

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
      appBar: AppBar(
        title: const Text('ตั้งค่า'),
        actions: const [
          ContextHelpButton(
            title: 'ตั้งค่าอะไรบ้าง',
            message:
                'ใส่เฉพาะข้อมูลที่ใช้คำนวณเงินก่อนก็พอ เช่น เงินเดือน วันทำงาน เวลาเข้างาน-ออกงานปกติ และค่า OT ส่วนอื่นค่อยกลับมาเติมทีหลังได้',
            tooltip: 'อธิบายหน้าตั้งค่า',
          ),
        ],
      ),
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
                      title: 'เงินเดือน',
                      icon: Icons.payments,
                      children: [
                        _number(
                          'monthlySalary',
                          'เงินเดือน',
                          onChanged: (_) => setState(() {}),
                        ),
                        _WorkScheduleSelector(
                          value: _workSchedule,
                          onChanged: (value) {
                            setState(() => _workSchedule = value);
                          },
                        ),
                        _DerivedDailyWage(
                          dailyWage: _derivedDailyWagePreview(),
                          hourlyWage: _derivedHourlyWagePreview(),
                        ),
                      ],
                    ),
                    _SettingsCard(
                      title: 'เวลาทำงาน',
                      icon: Icons.schedule,
                      children: [
                        _NormalWorkScheduleSelector(
                          value: _normalWorkSchedule,
                          onChanged: (value) {
                            setState(() => _normalWorkSchedule = value);
                          },
                        ),
                        if (_normalWorkSchedule ==
                            NormalWorkSchedule.custom) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _TimeField(
                                  controller: _controller(
                                    'customScheduleStartMinutes',
                                  ),
                                  label: 'เริ่มงาน',
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _TimeField(
                                  controller: _controller(
                                    'customScheduleEndMinutes',
                                  ),
                                  label: 'เลิกงาน',
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ],
                        _number(
                          'defaultBreakMinutes',
                          'เวลาพักสำหรับบันทึก (นาที, ไม่หักชั่วโมง)',
                          integerOnly: true,
                        ),
                        _number('normalDayMultiplier', 'ค่าแรงวันปกติ'),
                        _number(
                          'weekendDayMultiplier',
                          'ค่าแรงวันหยุดสุดสัปดาห์',
                        ),
                        _number(
                          'holidayDayMultiplier',
                          'ค่าแรงวันหยุดนักขัตฤกษ์',
                        ),
                      ],
                    ),
                    _SettingsCard(
                      title: 'Payroll',
                      icon: Icons.more_time,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  const CalculationHelpScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.help_outline),
                          label: const Text('วิธีคำนวณ'),
                        ),
                        const SizedBox(height: 12),
                        _PayrollPolicySelector(
                          value: _payrollPolicyType,
                          onChanged: (value) {
                            setState(() => _payrollPolicyType = value);
                          },
                        ),
                        _number('normalOtMultiplier', 'ค่าแรง OT วันปกติ'),
                        _number(
                          'weekendOtMultiplier',
                          'ค่าแรง OT วันหยุดสุดสัปดาห์',
                        ),
                        _number(
                          'holidayOtMultiplier',
                          'ค่าแรง OT วันหยุดนักขัตฤกษ์',
                        ),
                        _number('nightOtMultiplier', 'ค่าแรงกะกลางคืน'),
                        Row(
                          children: [
                            Expanded(
                              child: _TimeField(
                                controller: _controller(
                                  'nightShiftStartMinutes',
                                ),
                                label: 'เริ่มกะกลางคืน',
                                onChanged: (_) {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TimeField(
                                controller: _controller('nightShiftEndMinutes'),
                                label: 'จบกะกลางคืน',
                                onChanged: (_) {},
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
                      title: 'เกี่ยวกับ',
                      icon: Icons.info_outline,
                      children: const [
                        Text(
                          '${AppConstants.appName} ${AppConstants.betaName}',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Created by ${AppConstants.creatorName}\n'
                          'Part of ${AppConstants.productFamily}\n'
                          '${AppConstants.copyright}\n'
                          'Version ${AppConstants.version} '
                          '(Build ${AppConstants.buildNumber})',
                        ),
                      ],
                    ),
                    _SettingsCard(
                      title: 'ส่งความคิดเห็น',
                      icon: Icons.feedback_outlined,
                      children: [
                        const Text(
                          'พบจุดที่สับสนหรือคำนวณไม่ตรง ช่วยส่งความคิดเห็นให้ทีมปรับปรุงได้ทันที',
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.icon(
                              onPressed: _shareFeedback,
                              icon: const Icon(Icons.mail_outline),
                              label: const Text('เปิดอีเมล'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _copyText(
                                _feedbackText(),
                                'คัดลอกข้อความความคิดเห็นแล้ว',
                              ),
                              icon: const Icon(Icons.copy),
                              label: const Text('คัดลอกข้อความ'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _copyText(
                                AppConstants.version,
                                'คัดลอกเวอร์ชันแล้ว',
                              ),
                              icon: const Icon(Icons.new_releases_outlined),
                              label: const Text('คัดลอกเวอร์ชัน'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _copyText(
                                AppConstants.buildNumber,
                                'คัดลอกเลขบิลด์แล้ว',
                              ),
                              icon: const Icon(Icons.tag),
                              label: const Text('คัดลอกบิลด์'),
                            ),
                          ],
                        ),
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

  Future<void> _shareFeedback() async {
    await SharePlus.instance.share(
      ShareParams(text: _feedbackText(), subject: 'TimeTrack Pro Feedback'),
    );
  }

  Future<void> _copyText(String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _feedbackText() {
    return '''
TimeTrack Pro Feedback
Version: ${AppConstants.version}
Build: ${AppConstants.buildNumber}

สิ่งที่พบ:

สิ่งที่คาดหวัง:

ขั้นตอนที่ทำก่อนเกิดปัญหา:
''';
  }

  Widget _number(
    String key,
    String label, {
    bool integerOnly = false,
    ValueChanged<String>? onChanged,
  }) {
    return _NumberField(
      controller: _controller(key),
      label: label,
      integerOnly: integerOnly,
      onChanged: onChanged,
    );
  }

  Widget _text(String key, String label) {
    return _TextField(controller: _controller(key), label: label);
  }

  void _load(WorkSettings settings) {
    _loadedSettings = settings;
    _isInitialized = true;
    _controller('monthlySalary').text = _formatInitial(settings.monthlySalary);
    _workSchedule = settings.workSchedule;
    _normalWorkSchedule = settings.normalWorkSchedule;
    _payrollPolicyType = settings.payrollPolicyType;
    _controller('customScheduleStartMinutes').text = _formatMinutes(
      settings.customScheduleStartMinutes,
    );
    _controller('customScheduleEndMinutes').text = _formatMinutes(
      settings.customScheduleEndMinutes,
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
      dailyWage: _derivedDailyWagePreview(),
      workSchedule: _workSchedule,
      normalWorkSchedule: _normalWorkSchedule,
      customScheduleStartMinutes: _parseMinutes('customScheduleStartMinutes'),
      customScheduleEndMinutes: _parseMinutes('customScheduleEndMinutes'),
      payrollPolicyType: _payrollPolicyType,
      normalWorkHours: _currentNormalHoursPreview(),
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

  double _derivedDailyWagePreview() {
    final salary = double.tryParse(_controller('monthlySalary').text.trim());
    if (salary == null) {
      return 0;
    }

    return salary / _workSchedule.workingDaysPerMonth;
  }

  double _derivedHourlyWagePreview() {
    final hours = _currentNormalHoursPreview();
    if (hours <= 0) {
      return 0;
    }

    return _derivedDailyWagePreview() / hours;
  }

  double _currentNormalHoursPreview() {
    final start = _normalWorkSchedule == NormalWorkSchedule.custom
        ? _tryParseMinutes('customScheduleStartMinutes')
        : _normalWorkSchedule.startMinutes;
    final end = _normalWorkSchedule == NormalWorkSchedule.custom
        ? _tryParseMinutes('customScheduleEndMinutes')
        : _normalWorkSchedule.endMinutes;
    if (start == null || end == null) {
      return _normalWorkSchedule.normalHours;
    }

    var minutes = end - start;
    if (minutes < 0) {
      minutes += 24 * 60;
    }
    return minutes / 60;
  }

  int? _tryParseMinutes(String key) {
    final parts = _controller(key).text.trim().split(':');
    if (parts.length != 2) {
      return null;
    }
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    if (hours == null || minutes == null) {
      return null;
    }
    return (hours * 60) + minutes;
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

class _WorkScheduleSelector extends StatelessWidget {
  const _WorkScheduleSelector({required this.value, required this.onChanged});

  final WorkSchedule value;
  final ValueChanged<WorkSchedule> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<WorkSchedule>(
        initialValue: value,
        decoration: const InputDecoration(
          labelText: 'วันทำงานต่อเดือน',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_month),
        ),
        items: WorkSchedule.values.map((item) {
          return DropdownMenuItem(value: item, child: Text(item.label));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class _NormalWorkScheduleSelector extends StatelessWidget {
  const _NormalWorkScheduleSelector({
    required this.value,
    required this.onChanged,
  });

  final NormalWorkSchedule value;
  final ValueChanged<NormalWorkSchedule> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<NormalWorkSchedule>(
        initialValue: value,
        decoration: const InputDecoration(
          labelText: 'เวลาทำงานปกติ',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time),
        ),
        items: NormalWorkSchedule.values.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              '${item.label} (${item.normalHours.toStringAsFixed(0)} ชม.)',
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class _PayrollPolicySelector extends StatelessWidget {
  const _PayrollPolicySelector({required this.value, required this.onChanged});

  final PayrollPolicyType value;
  final ValueChanged<PayrollPolicyType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<PayrollPolicyType>(
        initialValue: value,
        decoration: const InputDecoration(
          labelText: 'นโยบายคำนวณค่าแรง',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.policy),
        ),
        items: PayrollPolicyType.values.map((item) {
          return DropdownMenuItem(value: item, child: Text(item.label));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class _DerivedDailyWage extends StatelessWidget {
  const _DerivedDailyWage({required this.dailyWage, required this.hourlyWage});

  final double dailyWage;
  final double hourlyWage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ค่าแรงรายวัน (คำนวณอัตโนมัติ)',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${dailyWage.toStringAsFixed(2)} บาท/วัน • '
            '${hourlyWage.toStringAsFixed(2)} บาท/ชั่วโมง',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
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
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final bool integerOnly;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
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
  const _TimeField({
    required this.controller,
    required this.label,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
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
