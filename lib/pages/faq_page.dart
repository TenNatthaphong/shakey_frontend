import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/services/language_service.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final _lang = LanguageService.instance;

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _lang.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  List<_FaqItem> get _faqItems => [
    _FaqItem(
      question: _lang.t(
        'How do I create an account?',
        'ฉันจะสร้างบัญชีได้อย่างไร?',
      ),
      answer: _lang.t(
        'To create an account, tap the "Register" button on the login screen. '
            'Fill in your details including username, email, phone number, and password. '
            'After registration, you will need to set up a 6-digit PIN for secure access.',
        'ในการสร้างบัญชี ให้แตะปุ่ม "ลงทะเบียน" บนหน้าจอเข้าสู่ระบบ '
            'กรอกรายละเอียดของคุณรวมถึงชื่อผู้ใช้ อีเมล เบอร์โทรศัพท์ และรหัสผ่าน '
            'หลังจากการลงทะเบียน คุณจะต้องตั้งค่า PIN 6 หลักเพื่อการเข้าถึงที่ปลอดภัย',
      ),
    ),
    _FaqItem(
      question: _lang.t(
        'How do I earn reward points?',
        'ฉันจะสะสมคะแนนรางวัลได้อย่างไร?',
      ),
      answer: _lang.t(
        'You earn points with every purchase made through the app. '
            'Points are automatically added to your account after your order is completed. '
            'The number of points earned depends on your purchase amount and current membership level.',
        'คุณจะได้รับคะแนนทุกครั้งที่ซื้อผ่านแอป '
            'คะแนนจะถูกเพิ่มเข้าบัญชีของคุณโดยอัตโนมัติหลังจากคำสั่งซื้อเสร็จสมบูรณ์ '
            'จำนวนคะแนนที่ได้รับขึ้นอยู่กับยอดซื้อและระดับสมาชิกปัจจุบันของคุณ',
      ),
    ),
    _FaqItem(
      question: _lang.t(
        'What are the membership levels?',
        'ระดับสมาชิกมีอะไรบ้าง?',
      ),
      answer: _lang.t(
        'There are three membership levels:\n\n'
            '🥉 Bronze — Starting level for all new members\n'
            '🥈 Silver — Unlocked after accumulating enough points\n'
            '🥇 Gold — Our premium tier with the best rewards and benefits\n\n'
            'Higher levels unlock better rewards and exclusive offers.',
        'ระดับสมาชิกมี 3 ระดับ:\n\n'
            '🥉 Bronze — ระดับเริ่มต้นสำหรับสมาชิกใหม่ทุกคน\n'
            '🥈 Silver — ปลดล็อกหลังจากสะสมคะแนนได้ครบ\n'
            '🥇 Gold — ระดับพรีเมียมพร้อมรางวัลและสิทธิประโยชน์ที่ดีที่สุด\n\n'
            'ระดับที่สูงขึ้นจะปลดล็อกรางวัลที่ดียิ่งขึ้นและข้อเสนอสุดพิเศษ',
      ),
    ),
    _FaqItem(
      question: _lang.t(
        'How do I redeem my points?',
        'ฉันจะแลกคะแนนได้อย่างไร?',
      ),
      answer: _lang.t(
        'Go to the Rewards page from the bottom navigation bar. '
            'Browse available rewards and select one you would like to redeem. '
            'If you have enough points, tap "Redeem" to exchange your points for the reward. '
            'Redeemed rewards will appear in your account.',
        'ไปที่หน้ารางวัลจากแถบนำทางด้านล่าง '
            'ดูรางวัลที่มีและเลือกรางวัลที่คุณต้องการแลก '
            'หากคุณมีคะแนนเพียงพอ ให้แตะ "แลก" เพื่อเปลี่ยนคะแนนเป็นรางวัล '
            'รางวัลที่แลกแล้วจะปรากฏในบัญชีของคุณ',
      ),
    ),
    _FaqItem(
      question: _lang.t(
        'How can I change my PIN?',
        'ฉันจะเปลี่ยน PIN ได้อย่างไร?',
      ),
      answer: _lang.t(
        'Go to the "More" page, then tap "Change PIN". '
            'You will be asked to enter your current PIN for verification, '
            'then you can set a new 6-digit PIN. Make sure to remember your new PIN.',
        'ไปที่หน้า "เพิ่มเติม" จากนั้นแตะ "เปลี่ยน PIN" '
            'คุณจะถูกขอให้กรอก PIN ปัจจุบันเพื่อยืนยัน '
            'จากนั้นคุณสามารถตั้งค่า PIN 6 หลักใหม่ได้ อย่าลืมจดจำ PIN ใหม่ของคุณ',
      ),
    ),
    _FaqItem(
      question: _lang.t(
        'How do I reset my password?',
        'ฉันจะรีเซ็ตรหัสผ่านได้อย่างไร?',
      ),
      answer: _lang.t(
        'If you forgot your password, tap "Forgot Password" on the login screen. '
            'Enter your registered email address and we will send you an OTP code. '
            'Verify the OTP, then you can create a new password.',
        'หากคุณลืมรหัสผ่าน ให้แตะ "ลืมรหัสผ่าน" บนหน้าจอเข้าสู่ระบบ '
            'กรอกอีเมลที่คุณลงทะเบียนไว้ แล้วเราจะส่งรหัส OTP ให้คุณ '
            'ยืนยัน OTP จากนั้นคุณจะสามารถสร้างรหัสผ่านใหม่ได้',
      ),
    ),
    _FaqItem(
      question: _lang.t(
        'Can I cancel my order?',
        'ฉันสามารถยกเลิกคำสั่งซื้อได้หรือไม่?',
      ),
      answer: _lang.t(
        'Orders can be cancelled before they are confirmed by the store. '
            'Once the order is being prepared, cancellation may not be possible. '
            'Please contact our support team if you need assistance with order cancellation.',
        'คำสั่งซื้อสามารถยกเลิกได้ก่อนที่จะได้รับการยืนยันจากทางร้าน '
            'เมื่อคำสั่งซื้อเริ่มเตรียมการแล้ว อาจไม่สามารถยกเลิกได้ '
            'กรุณาติดต่อทีมสนับสนุนของเราหากคุณต้องการความช่วยเหลือในการยกเลิกคำสั่งซื้อ',
      ),
    ),
    _FaqItem(
      question: _lang.t(
        'What payment methods are accepted?',
        'รับชำระเงินผ่านช่องทางใดบ้าง?',
      ),
      answer: _lang.t(
        'We currently accept the following payment methods:\n\n'
            '💳 Credit / Debit cards\n'
            '📱 Mobile banking\n'
            '💵 Cash on delivery\n\n'
            'More payment options may be added in future updates.',
        'ปัจจุบันเรารับชำระเงินผ่านช่องทางต่อไปนี้:\n\n'
            '💳 บัตรเครดิต / เดบิต\n'
            '📱 โมบายแบงก์กิ้ง\n'
            '💵 เก็บเงินปลายทาง\n\n'
            'อาจมีการเพิ่มตัวเลือกการชำระเงินเพิ่มเติมในอนาคต',
      ),
    ),
    _FaqItem(
      question: _lang.t(
        'How do I contact customer support?',
        'ฉันจะติดต่อทีมสนับสนุนลูกค้าได้อย่างไร?',
      ),
      answer: _lang.t(
        'You can reach our support team through:\n\n'
            '📧 Email: support@shakey.com\n'
            '📞 Phone: +66 2-XXX-XXXX\n'
            '⏰ Support hours: Mon-Fri, 9:00 AM - 6:00 PM\n\n'
            'We typically respond within 24 hours.',
        'ท่านสามารถติดต่อทีมสนับสนุนของเราผ่าน:\n\n'
            '📧 อีเมล: support@shakey.com\n'
            '📞 โทรศัพท์: +66 2-XXX-XXXX\n'
            '⏰ เวลาทำการ: จันทร์-ศุกร์, 9:00 - 18:00 น.\n\n'
            'ปกติเราจะตอบกลับภายใน 24 ชั่วโมง',
      ),
    ),
  ];

  final Map<int, bool> _expandedStates = {};

  @override
  Widget build(BuildContext context) {
    final items = _faqItems;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColor.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _lang.get('faq'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: AppColor.primaryRed,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _lang.t(
                            'Tap a question to see the answer',
                            'แตะคำถามเพื่อดูคำตอบ',
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // FAQ List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final isExpanded = _expandedStates[index] ?? false;
                    return _buildFaqCard(
                      items[index],
                      index + 1,
                      index,
                      isExpanded,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(_FaqItem item, int number, int index, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded
              ? AppColor.primaryRed.withOpacity(0.3)
              : AppColor.primaryRed.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isExpanded
                  ? AppColor.primaryRed
                  : AppColor.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isExpanded ? Colors.white : AppColor.primaryRed,
                ),
              ),
            ),
          ),
          trailing: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.expand_circle_down_outlined,
              color: isExpanded ? AppColor.primaryRed : Colors.grey.shade400,
            ),
          ),
          title: Text(
            item.question,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isExpanded ? AppColor.primaryRed : Colors.black87,
            ),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedStates[index] = expanded;
            });
          },
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9EF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.answer,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  _FaqItem({required this.question, required this.answer});
}
