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
  var _page = 0;

  static const _pages = [
    _OnboardingPageData(
      icon: Icons.waving_hand,
      title: 'ยินดีต้อนรับสู่ TimeTrack Pro',
      body:
          'ผู้ช่วยบันทึกเวลาทำงาน\nคำนวณ OT\nและสรุปรายได้\nสำหรับคนทำงานและผู้ประกอบการไทย',
    ),
    _OnboardingPageData(
      icon: Icons.tune,
      title: 'ตั้งค่าข้อมูลของคุณ',
      body:
          'เงินเดือน\nเวลาทำงาน\nวันทำงาน\nOT\n\nตั้งเพียงครั้งเดียว ระบบจะคำนวณให้อัตโนมัติ',
    ),
    _OnboardingPageData(
      icon: Icons.add_circle_outline,
      title: 'เพิ่มรายการทำงาน',
      body: 'กรอกวันที่\nเวลาเข้างาน\nเวลาออกงาน\n\nแล้วกดบันทึก',
    ),
    _OnboardingPageData(
      icon: Icons.bar_chart,
      title: 'ระบบจะคำนวณทันที',
      body: 'เวลาทำงาน\nเวลาล่วงเวลา (OT)\nรายได้วันนี้\nสรุปรายเดือน',
    ),
    _OnboardingPageData(
      icon: Icons.celebration,
      title: 'พร้อมเริ่มใช้งาน',
      body: 'กด "เริ่มใช้งาน"\nแล้วเริ่มบันทึกเวลาทำงานรายการแรกได้เลย',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    await ref
        .read(settingsRepositoryProvider)
        .saveSettings(widget.settings.copyWith(onboardingCompleted: true));
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
