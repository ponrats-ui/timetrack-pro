import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/data/settings_repository.dart';
import '../../settings/domain/work_settings.dart';
import '../../time_records/application/demo_data_service.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key, required this.settings});

  final WorkSettings settings;

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  var _isWorking = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  'ยินดีต้อนรับสู่ TimeTrack Pro',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'เริ่มเห็นภาพรายได้และ OT ได้ภายในไม่กี่นาที',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                const _ValueItem(
                  icon: Icons.edit_note,
                  title: 'บันทึกเวลา',
                  subtitle: 'เก็บเวลาเข้า ออก วันหยุด และหมายเหตุไว้ในเครื่อง',
                ),
                const _ValueItem(
                  icon: Icons.more_time,
                  title: 'คำนวณ OT',
                  subtitle: 'ใช้กฎเงินเดือนและตัวคูณที่คุณตั้งเอง',
                ),
                const _ValueItem(
                  icon: Icons.payments,
                  title: 'สรุปรายได้',
                  subtitle: 'ดูรายวัน รายเดือน ค่าใช้จ่าย และยอดสุทธิ',
                ),
                const _ValueItem(
                  icon: Icons.picture_as_pdf,
                  title: 'ส่งรายงาน HR',
                  subtitle: 'เตรียมข้อมูลสำหรับ PDF และ Excel รายเดือน',
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isWorking ? null : _startRealUse,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('เริ่มใช้งานจริง'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _isWorking ? null : _startDemo,
                  icon: _isWorking
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome_motion),
                  label: const Text('ทดลองด้วยข้อมูลตัวอย่าง'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startRealUse() async {
    await ref
        .read(settingsRepositoryProvider)
        .saveSettings(widget.settings.copyWith(onboardingCompleted: true));
  }

  Future<void> _startDemo() async {
    setState(() => _isWorking = true);
    try {
      await ref.read(demoDataServiceProvider).installDemoData(widget.settings);
      await ref
          .read(settingsRepositoryProvider)
          .saveSettings(widget.settings.copyWith(onboardingCompleted: true));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('สร้างข้อมูลตัวอย่างไม่สำเร็จ: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isWorking = false);
      }
    }
  }
}

class _ValueItem extends StatelessWidget {
  const _ValueItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, child: Icon(icon, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
