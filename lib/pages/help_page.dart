import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/services/language_service.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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

  @override
  Widget build(BuildContext context) {
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
                        _lang.get('help'),
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
              const SizedBox(height: 8),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColor.primaryRed, Color(0xFFFF6B81)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primaryRed.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.support_agent_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _lang.t(
                                'How can we help you?',
                                'เราจะช่วยคุณได้อย่างไร?',
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _lang.t(
                                'Find guides and tips to get the most\nout of the Shakey app',
                                'ค้นหาคู่มือและเคล็ดลับเพื่อให้คุณใช้งาน\nแอป Shakey ได้อย่างคุ้มค่าที่สุด',
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick Help Topics
                      Text(
                        _lang.t('Quick Help Topics', 'หัวข้อการช่วยเหลือด่วน'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildHelpTopic(
                        icon: Icons.person_add_outlined,
                        title: _lang.t('Getting Started', 'การเริ่มต้นใช้งาน'),
                        description: _lang.t(
                          'Learn how to create your account, set up your PIN, and start using the app.',
                          'เรียนรู้วิธีสร้างบัญชี ตั้งค่า PIN และเริ่มต้นใช้งานแอป',
                        ),
                        steps: [
                          _lang.t(
                            'Open the app and tap "Register"',
                            'เปิดแอปและแตะ "ลงทะเบียน"',
                          ),
                          _lang.t(
                            'Fill in your username, email, phone, and password',
                            'กรอกชื่อผู้ใช้ อีเมล โทรศัพท์ และรหัสผ่าน',
                          ),
                          _lang.t(
                            'Verify your account and set up a 6-digit PIN',
                            'ยืนยันบัญชีของคุณและตั้งค่า PIN 6 หลัก',
                          ),
                          _lang.t(
                            'Start browsing the menu and placing orders!',
                            'เริ่มดูเมนูและสั่งซื้อได้เลย!',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildHelpTopic(
                        icon: Icons.shopping_bag_outlined,
                        title: _lang.t('How to Order', 'วิธีสั่งสินค้า'),
                        description: _lang.t(
                          'Step-by-step guide to placing your first order through the app.',
                          'คู่มื่อแนะนำการสั่งสินค้าครั้งแรกของคุณผ่านแอป',
                        ),
                        steps: [
                          _lang.t(
                            'Browse the Menu page and select items',
                            'เลือดูหน้าเมนูและเลือกรายการ',
                          ),
                          _lang.t(
                            'Customize your order (size, sugar, toppings)',
                            'ปรับแต่งคำสั่งซื้อของคุณ (ขนาด, ความหวาน, ท็อปปิ้ง)',
                          ),
                          _lang.t(
                            'Add items to your cart',
                            'เพิ่มรายการลงในตะกร้า',
                          ),
                          _lang.t(
                            'Review your cart and tap "Checkout"',
                            'ตรวจสอบตะกร้าและแตะ "ชำระเงิน"',
                          ),
                          _lang.t(
                            'Choose payment method and confirm',
                            'เลือกวิธีการชำระเงินและยืนยัน',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildHelpTopic(
                        icon: Icons.stars_outlined,
                        title: _lang.t('Rewards & Points', 'รางวัลและคะแนน'),
                        description: _lang.t(
                          'Understand how to earn and redeem your reward points.',
                          'ทำความเข้าใจวิธีรับและแลกคะแนนรางวัลของคุณ',
                        ),
                        steps: [
                          _lang.t(
                            'Earn points automatically with every purchase',
                            'รับคะแนนโดยอัตโนมัติเมื่อสั่งซื้อสินค้าครบถ้วน',
                          ),
                          _lang.t(
                            'Check your points on the Home page',
                            'ตรวจสอบคะแนนของคุณที่หน้าหลัก',
                          ),
                          _lang.t(
                            'Go to Rewards page to browse available rewards',
                            'ไปที่หน้ารางวัลเพื่อดูรางวัลที่มี',
                          ),
                          _lang.t(
                            'Tap "Redeem" on any reward you want',
                            'แตะ "แลก" สำหรับรางวัลที่คุณต้องการ',
                          ),
                          _lang.t(
                            'Points expire after 12 months of inactivity',
                            'คะแนนจะหมดอายุหากไม่มีการใช้งานต่อเนื่อง 12 เดือน',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildHelpTopic(
                        icon: Icons.manage_accounts_outlined,
                        title: _lang.t('Account Management', 'การจัดการบัญชี'),
                        description: _lang.t(
                          'How to update your profile, change PIN, and reset your password.',
                          'วิธีอัปเดตโปรไฟล์ เปลี่ยน PIN และรีเซ็ตรหัสผ่าน',
                        ),
                        steps: [
                          _lang.t(
                            'Go to "More" page to access settings',
                            'ไปที่หน้า "เพิ่มเติม" เพื่อเข้าถึงการตั้งค่า',
                          ),
                          _lang.t(
                            'Tap "Edit Profile" to update your info',
                            'แตะ "แก้ไขโปรไฟล์" เพื่ออัปเดตข้อมูล',
                          ),
                          _lang.t(
                            'Use "Change PIN" for PIN updates',
                            'ใช้ "เปลี่ยน PIN" เพื่ออัปเดต PIN',
                          ),
                          _lang.t(
                            'Use "Change Password" to reset via email OTP',
                            'ใช้ "เปลี่ยนรหัสผ่าน" เพื่อรีเซ็ตผ่านอีเมล OTP',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildHelpTopic(
                        icon: Icons.credit_card_outlined,
                        title: _lang.t('Payment Methods', 'วิธีการชำระเงิน'),
                        description: _lang.t(
                          'Learn about the available payment options in the app.',
                          'เรียนรู้เกี่ยวกับตัวเลือกการชำระเงินที่มีในแอป',
                        ),
                        steps: [
                          _lang.t(
                            'Credit / Debit cards are accepted',
                            'รับชำระผ่านบัตรเครดิต / เดบิต',
                          ),
                          _lang.t(
                            'Mobile banking transfers are supported',
                            'รองรับการโอนผ่านโมบายแบงก์กิ้ง',
                          ),
                          _lang.t(
                            'Cash on delivery is available for some areas',
                            'มีบริการเก็บเงินปลายทางในบางพื้นที่',
                          ),
                          _lang.t(
                            'Payment is processed securely through our system',
                            'การชำระเงินจะถูกประมวลผลอย่างปลอดภัยผ่านระบบของเรา',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildHelpTopic(
                        icon: Icons.security_outlined,
                        title: _lang.t(
                          'Security & Privacy',
                          'ความปลอดภัยและความเป็นส่วนตัว',
                        ),
                        description: _lang.t(
                          'Keep your account safe and understand our data policies.',
                          'ดูแลบัญชีของคุณให้ปลอดภัยและทำความเข้าใจนโยบายข้อมูลของเรา',
                        ),
                        steps: [
                          _lang.t(
                            'Never share your PIN or password with others',
                            'ห้ามแบ่งปัน PIN หรือรหัสผ่านกับผู้อื่น',
                          ),
                          _lang.t(
                            'Use a strong password with letters and numbers',
                            'ใช้รหัสผ่านที่คาดเดายากซึ่งมีทั้งตัวอักษรและตัวเลข',
                          ),
                          _lang.t(
                            'Log out from shared devices',
                            'ออกจากระบบจากอุปกรณ์ที่ใช้งานร่วมกัน',
                          ),
                          _lang.t(
                            'Your data is encrypted and stored securely',
                            'ข้อมูลของคุณถูกเข้ารหัสและจัดเก็บอย่างปลอดภัย',
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Still need help?
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColor.primaryRed.withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.headset_mic_outlined,
                              size: 36,
                              color: AppColor.primaryRed,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _lang.t(
                                'Still need help?',
                                'ยังต้องการความช่วยเหลือ?',
                              ),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _lang.t(
                                'Contact our support team for further assistance',
                                'ติดต่อทีมสนับสนุนของเราเพื่อขอความช่วยเหลือเพิ่มเติม',
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.email_outlined,
                                  size: 18,
                                ),
                                label: Text(
                                  _lang.t(
                                    'Contact Support',
                                    'ติดต่อทีมสนับสนุน',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryRed,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpTopic({
    required IconData icon,
    required String title,
    required String description,
    required List<String> steps,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.primaryRed.withOpacity(0.1),
          width: 1,
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
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColor.primaryRed, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              height: 1.3,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9EF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: AppColor.primaryRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryRed,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
