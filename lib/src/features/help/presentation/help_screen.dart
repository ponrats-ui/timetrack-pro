import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('วิธีใช้งาน')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: const [
              _HelpSection(
                icon: Icons.flag,
                title: 'เริ่มต้นใช้งาน',
                body:
                    'เริ่มจากตั้งค่าเงินเดือน วันทำงาน และเวลาทำงานปกติ จากนั้นกลับมาที่หน้าบันทึกเวลาเพื่อเพิ่มรายการแรก',
              ),
              _HelpSection(
                icon: Icons.settings,
                title: 'การตั้งค่า',
                body:
                    'กรอกข้อมูลที่ใช้คำนวณรายได้ เช่น เงินเดือน วันทำงานต่อเดือน เวลาเข้างาน-ออกงานปกติ และอัตราค่าแรง OT',
              ),
              _HelpSection(
                icon: Icons.more_time,
                title: 'การคำนวณ OT',
                body:
                    'เวลาที่อยู่ในตารางทำงานจะเป็นเวลาปกติ เวลาหลังจากนั้นจะเป็นเวลาล่วงเวลา (OT) ระบบจะแสดงผลให้ดูทันที',
              ),
              _HelpSection(
                icon: Icons.picture_as_pdf,
                title: 'การส่งออก PDF',
                body:
                    'ไปที่หน้าสรุปรายได้ เลือกส่งออก PDF เพื่อทำรายงานรายเดือนที่เปิดอ่านหรือส่งต่อได้ง่าย',
              ),
              _HelpSection(
                icon: Icons.table_chart,
                title: 'การส่งออก Excel',
                body:
                    'ใช้ Excel เมื่อต้องการนำข้อมูลไปตรวจต่อหรือส่งให้ฝ่ายบัญชีและ HR',
              ),
              _HelpSection(
                icon: Icons.quiz,
                title: 'คำถามที่พบบ่อย',
                body:
                    'ถ้ารายได้ไม่ตรง ให้ตรวจเงินเดือน วันทำงานต่อเดือน เวลาเข้างาน-ออกงาน และอัตรา OT ในหน้าตั้งค่าก่อน',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculationHelpScreen extends StatelessWidget {
  const CalculationHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('วิธีคำนวณ')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: const [
              _HelpSection(
                icon: Icons.schedule,
                title: 'เวลาทำงาน',
                body:
                    'ระบบนับเวลาจากเวลาเข้า ถึงเวลาออก ถ้าออกงานหลังเที่ยงคืน ระบบจะนับข้ามวันให้อัตโนมัติ',
              ),
              _HelpSection(
                icon: Icons.access_time,
                title: 'เวลาทำงานปกติ',
                body:
                    'เวลาที่อยู่ในช่วงเวลาทำงานที่ตั้งไว้ เช่น 08:00-17:00 จะถูกนับเป็นเวลาทำงานปกติ',
              ),
              _HelpSection(
                icon: Icons.more_time,
                title: 'เวลาล่วงเวลา (OT)',
                body:
                    'เวลาที่อยู่นอกช่วงเวลาทำงานปกติจะถูกนับเป็น OT และใช้ค่าแรง OT ตามที่ตั้งไว้',
              ),
              _HelpSection(
                icon: Icons.payments,
                title: 'รายได้วันนี้',
                body:
                    'รายได้วันนี้มาจากค่าแรงเวลาปกติ รวมกับค่าแรง OT และเบี้ยเลี้ยง ถ้ามีค่าใช้จ่าย ระบบจะแสดงยอดสุทธิให้ดูด้วย',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(child: Icon(icon)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(body, style: const TextStyle(height: 1.45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
