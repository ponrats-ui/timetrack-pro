import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เริ่มต้นใช้งาน')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: const [
              _IntroCard(),
              _HelpSection(
                icon: Icons.tune,
                title: 'ตั้งค่าครั้งแรก',
                body:
                    'เริ่มจากใส่เงินเดือน วันทำงาน และเวลาเข้างาน-ออกงานปกติ แค่นี้พอ ระบบจะใช้ข้อมูลนี้ช่วยคำนวณรายได้ให้ทุกวัน',
              ),
              _HelpSection(
                icon: Icons.login,
                title: 'เข้างาน / ออกงาน',
                body:
                    'ถ้าวันนี้เริ่มงานแล้ว กด "เข้างาน" ได้เลย ตอนเลิกงานค่อยกด "ออกงาน" แอปจะเก็บเวลาจริงของวันนั้นให้',
              ),
              _HelpSection(
                icon: Icons.edit_note,
                title: 'เพิ่มรายการเอง',
                body:
                    'ถ้าลืมกดเข้างาน หรืออยากบันทึกย้อนหลัง ให้กด "เพิ่มรายการ" แล้วเลือกวันที่ เวลาเข้า และเวลาออก จากนั้นกดบันทึก',
              ),
              _HelpSection(
                icon: Icons.payments,
                title: 'การคำนวณเงิน',
                body:
                    'แอปดูเวลาทำงานจริง เทียบกับเวลาทำงานปกติของคุณ ส่วนที่เกินจะเป็น OT แล้วคำนวณรายได้ตามค่าที่ตั้งไว้',
              ),
              _HelpSection(
                icon: Icons.picture_as_pdf,
                title: 'ส่งออก PDF',
                body:
                    'ไปที่หน้าสรุปรายได้ แล้วกด "ส่งออก PDF" เหมาะสำหรับส่งรายงานที่อ่านง่ายหรือเก็บไว้เป็นหลักฐาน',
              ),
              _HelpSection(
                icon: Icons.table_chart,
                title: 'ส่งออก Excel',
                body:
                    'ใช้ Excel เมื่อต้องเอาข้อมูลไปตรวจต่อ ส่งให้บัญชี หรือเปิดดูรายละเอียดเป็นตาราง',
              ),
              _HelpSection(
                icon: Icons.quiz,
                title: 'คำถามที่พบบ่อย',
                body:
                    'ถ้ารายได้ดูไม่ตรง ให้เช็กเงินเดือน ตารางเวลาทำงาน และค่า OT ในหน้าตั้งค่าก่อน ถ้ายังไม่แน่ใจ ให้คัดลอกข้อมูลในเมนูส่งความคิดเห็นแล้วส่งให้ทีมดูได้',
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
                    'ระบบนับจากเวลาเข้า ถึงเวลาออก ถ้าออกงานหลังเที่ยงคืน ระบบจะนับข้ามวันให้อัตโนมัติ',
              ),
              _HelpSection(
                icon: Icons.access_time,
                title: 'เวลาปกติ',
                body:
                    'ช่วงเวลาที่อยู่ในตารางทำงาน เช่น 08:00-17:00 จะถือเป็นเวลาทำงานปกติ',
              ),
              _HelpSection(
                icon: Icons.more_time,
                title: 'OT',
                body:
                    'เวลาที่เกินจากตารางทำงานปกติจะนับเป็น OT และใช้ค่าแรง OT ตามที่ตั้งไว้',
              ),
              _HelpSection(
                icon: Icons.payments,
                title: 'รายได้',
                body:
                    'รายได้วันนี้มาจากค่าแรงเวลาปกติ บวกค่าแรง OT และเบี้ยเลี้ยง ถ้ามีค่าใช้จ่าย ระบบจะแสดงยอดสุทธิให้ด้วย',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContextHelpButton extends StatelessWidget {
  const ContextHelpButton({
    super.key,
    required this.title,
    required this.message,
    this.tooltip = 'ช่วยอธิบาย',
  });

  final String title;
  final String message;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: const Icon(Icons.help_outline),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(message, style: const TextStyle(height: 1.45)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('เข้าใจแล้ว'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ทำตามนี้ก็เริ่มใช้ได้เลย',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'ตั้งค่าข้อมูลพื้นฐานหนึ่งครั้ง แล้วเลือกวิธีบันทึกเวลาที่เหมาะกับวันทำงานของคุณ',
              style: TextStyle(height: 1.45),
            ),
          ],
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
