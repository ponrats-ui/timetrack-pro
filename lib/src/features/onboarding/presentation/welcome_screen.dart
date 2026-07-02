import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../settings/data/settings_repository.dart';
import '../../settings/domain/work_settings.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key, required this.settings, this.replay = false});

  final WorkSettings settings;
  final bool replay;

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _controller = PageController();
  final _salaryController = TextEditingController();
  final _otController = TextEditingController();
  var _page = 0;
  var _showSetup = false;
  late var _workSchedule = widget.settings.workSchedule;
  late var _normalWorkSchedule = widget.settings.normalWorkSchedule;

  static const _pages = [
    _OnboardingPageData(
      icon: Icons.waving_hand,
      title: 'ยินดีต้อนรับสู่ TimeTrack Pro',
      body:
          'ผู้ช่วยบันทึกเวลาทำงาน\nคำนวณ OT\nและสรุปรายได้\nสำหรับคนทำงานและผู้ประกอบการไทย',
    ),
    _OnboardingPageData(
      icon: Icons.tune,
      title: 'ตั้งค่าข้อมูลครั้งแรก',
      body:
          'ใส่เงินเดือน\nวันทำงาน\nเวลาเข้างาน-ออกงานปกติ\nและค่า OT\n\nตั้งครั้งเดียวก็ใช้ต่อได้',
    ),
    _OnboardingPageData(
      icon: Icons.login,
      title: 'กดเข้างาน / ออกงาน',
      body:
          'ถ้ากำลังทำงานวันนี้\nกด "เข้างาน"\nแล้วกลับมากด "ออกงาน"\nตอนเลิกงาน',
    ),
    _OnboardingPageData(
      icon: Icons.edit_note,
      title: 'หรือเพิ่มรายการเอง',
      body:
          'ถ้าลืมกดเวลา\nให้เลือกวันที่\nเวลาเข้างาน\nเวลาออกงาน\nแล้วกดบันทึก',
    ),
    _OnboardingPageData(
      icon: Icons.celebration,
      title: 'พร้อมเริ่มใช้งาน',
      body: 'แอปจะช่วยสรุปเวลาทำงาน\nOT\nรายได้วันนี้\nและรายงานรายเดือนให้คุณ',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _salaryController.dispose();
    _otController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSetup) {
      return _SetupWizard(
        salaryController: _salaryController,
        otController: _otController,
        workSchedule: _workSchedule,
        normalWorkSchedule: _normalWorkSchedule,
        onWorkScheduleChanged: (value) {
          setState(() => _workSchedule = value);
        },
        onNormalWorkScheduleChanged: (value) {
          setState(() => _normalWorkSchedule = value);
        },
        onFinish: _completeSetup,
      );
    }

    final isLast = _page == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _finish,
                      child: Text(widget.replay ? 'ปิด' : 'ข้าม'),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (value) => setState(() => _page = value),
                      itemBuilder: (context, index) {
                        return _OnboardingPage(data: _pages[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PageDots(count: _pages.length, activeIndex: _page),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: isLast ? _finish : _next,
                      icon: Icon(
                        isLast ? Icons.check_circle : Icons.arrow_forward,
                      ),
                      label: Text(isLast ? 'เริ่มใช้งาน' : 'ถัดไป'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _next() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    if (widget.replay) {
      Navigator.of(context).maybePop();
      return;
    }

    _salaryController.text = _formatInitial(widget.settings.monthlySalary);
    _otController.text = _formatInitial(widget.settings.normalOtMultiplier);
    setState(() => _showSetup = true);
  }

  Future<void> _completeSetup() async {
    final salary =
        double.tryParse(_salaryController.text.trim()) ??
        widget.settings.monthlySalary;
    final otMultiplier =
        double.tryParse(_otController.text.trim()) ??
        widget.settings.normalOtMultiplier;
    await ref
        .read(settingsRepositoryProvider)
        .saveSettings(
          widget.settings.copyWith(
            monthlySalary: salary,
            dailyWage: salary / _workSchedule.workingDaysPerMonth,
            workSchedule: _workSchedule,
            normalWorkSchedule: _normalWorkSchedule,
            normalWorkHours: _normalWorkSchedule.normalHours,
            normalOtMultiplier: otMultiplier,
            onboardingCompleted: true,
          ),
        );
  }

  String _formatInitial(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }
}

class _SetupWizard extends StatelessWidget {
  const _SetupWizard({
    required this.salaryController,
    required this.otController,
    required this.workSchedule,
    required this.normalWorkSchedule,
    required this.onWorkScheduleChanged,
    required this.onNormalWorkScheduleChanged,
    required this.onFinish,
  });

  final TextEditingController salaryController;
  final TextEditingController otController;
  final WorkSchedule workSchedule;
  final NormalWorkSchedule normalWorkSchedule;
  final ValueChanged<WorkSchedule> onWorkScheduleChanged;
  final ValueChanged<NormalWorkSchedule> onNormalWorkScheduleChanged;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                Icon(
                  Icons.tune,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'First-time Setup',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ตั้งค่าพื้นฐานให้พร้อมคำนวณเงินเดือนและ OT',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: salaryController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Monthly Salary',
                    prefixIcon: Icon(Icons.payments),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<WorkSchedule>(
                  initialValue: workSchedule,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Working Days',
                    prefixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(),
                  ),
                  items: WorkSchedule.values.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item.label, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  selectedItemBuilder: (context) => WorkSchedule.values
                      .map(
                        (item) =>
                            Text(item.label, overflow: TextOverflow.ellipsis),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onWorkScheduleChanged(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<NormalWorkSchedule>(
                  initialValue: normalWorkSchedule,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Work Schedule',
                    prefixIcon: Icon(Icons.schedule),
                    border: OutlineInputBorder(),
                  ),
                  items: NormalWorkSchedule.values
                      .where((item) => item != NormalWorkSchedule.custom)
                      .map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      })
                      .toList(),
                  selectedItemBuilder: (context) => NormalWorkSchedule.values
                      .where((item) => item != NormalWorkSchedule.custom)
                      .map(
                        (item) =>
                            Text(item.label, overflow: TextOverflow.ellipsis),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onNormalWorkScheduleChanged(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: otController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'OT Policy',
                    helperText: 'เช่น 1.5 สำหรับ OT วันปกติ',
                    prefixIcon: Icon(Icons.more_time),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: onFinish,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Finish - Ready to use'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 48,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: active ? 22 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
