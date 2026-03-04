import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/services/language_service.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
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
                        _lang.get('terms'),
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

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Last updated
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.update,
                              size: 16,
                              color: AppColor.primaryRed,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${_lang.t('Last updated', 'แก้ไขล่าสุดเมื่อ')}: ${_lang.t('March 1, 2026', '1 มีนาคม 2026')}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColor.primaryRed,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildSection(
                        _lang.t(
                          '1. Acceptance of Terms',
                          '1. การยอมรับข้อกำหนด',
                        ),
                        _lang.t(
                          'By accessing and using the Shakey mobile application ("App"), '
                              'you agree to be bound by these Terms and Conditions. '
                              'If you do not agree to these terms, please do not use the App. '
                              'These terms apply to all users of the App, including customers, '
                              'visitors, and any other persons who access or use the App.',
                          'การเข้าถึงและใช้งานแอปพลิเคชันมือถือ Shakey ("แอป") '
                              'คุณตกลงที่จะผูกพันตามข้อกำหนดและเงื่อนไขเหล่านี้ '
                              'หากคุณไม่ตกลงตามข้อกำหนดเหล่านี้ โปรดอย่าใช้แอป '
                              'ข้อกำหนดเหล่านี้ใช้กับผู้ใช้แอปทุกคน รวมถึงลูกค้า '
                              'ผู้เยี่ยมชม และบุคคลอื่นใดที่เข้าถึงหรือใช้งานแอป',
                        ),
                      ),
                      _buildSection(
                        _lang.t(
                          '2. Account Registration',
                          '2. การลงทะเบียนบัญชี',
                        ),
                        _lang.t(
                          'To use certain features of the App, you must register for an account. '
                              'You agree to provide accurate, current, and complete information during '
                              'registration. You are responsible for safeguarding your password and '
                              'PIN, and you agree not to disclose your credentials to any third party. '
                              'You must notify us immediately of any unauthorized use of your account.',
                          'ในการใช้งานบางฟีเจอร์ของแอป คุณต้องลงทะเบียนเพื่อสร้างบัญชี '
                              'คุณตกลงที่จะให้ข้อมูลที่ถูกต้อง เป็นปัจจุบัน และครบถ้วนในระหว่างการลงทะเบียน '
                              'คุณมีหน้าที่รับผิดชอบในการปกป้องรหัสผ่านและ PIN ของคุณ และคุณตกลงที่จะไม่เปิดเผยรหัสผ่าน '
                              'ให้กับบุคคลที่สาม คุณต้องแจ้งให้เราทราบทันทีหากมีการใช้งานบัญชีของคุณโดยไม่ได้รับอนุญาต',
                        ),
                      ),
                      _buildSection(
                        _lang.t(
                          '3. Orders and Payments',
                          '3. คำสั่งซื้อและการชำระเงิน',
                        ),
                        _lang.t(
                          'All orders placed through the App are subject to acceptance and availability. '
                              'We reserve the right to refuse or cancel any order at any time for reasons '
                              'including but not limited to product availability, errors in pricing, or '
                              'problems identified by our fraud detection system. Payment must be made at '
                              'the time of order through the payment methods available in the App.',
                          'คำสั่งซื้อทั้งหมดที่ทำผ่านแอปขึ้นอยู่กับการตอบรับและความพร้อมของสินค้า '
                              'เราขอสงวนสิทธิ์ในการปฏิเสธหรือยกเลิกคำสั่งซื้อใดๆ ได้ทุกเมื่อด้วยเหตุผล '
                              'รวมถึงแต่ไม่จำกัดเพียง ความพร้อมของสินค้า ความผิดพลาดในราคา หรือปัญหา '
                              'ที่ระบุโดยระบบตรวจจับการฉ้อโกงของเรา การชำระเงินต้องทำในเวลาที่สั่งซื้อ '
                              'ผ่านวิธีการชำระเงินที่มีในแอป',
                        ),
                      ),
                      _buildSection(
                        _lang.t('4. Rewards Program', '4. โปรแกรมรางวัล'),
                        _lang.t(
                          'Our rewards program allows you to earn points on eligible purchases. '
                              'Points have no cash value and cannot be transferred, sold, or exchanged '
                              'for cash. We reserve the right to modify, suspend, or terminate the rewards '
                              'program at any time without prior notice. Points may expire if your account '
                              'is inactive for a period of 12 months.',
                          'โปรแกรมรางวัลของเราช่วยให้คุณได้รับคะแนนจากการซื้อที่มีสิทธิ์ '
                              'คะแนนไม่มีมูลค่าเป็นเงินสดและไม่สามารถโอน ขาย หรือแลกเปลี่ยนเป็นเงินสดได้ '
                              'เราขอสงวนสิทธิ์ในการแก้ไข ระงับ หรือยกเลิกโปรแกรมรางวัล '
                              'ได้ทุกเมื่อโดยไม่ต้องแจ้งให้ทราบล่วงหน้า คะแนนอาจหมดอายุหากบัญชีของคุณ '
                              'ไม่มีความเคลื่อนไหวเป็นเวลา 12 เดือน',
                        ),
                      ),
                      _buildSection(
                        _lang.t(
                          '5. Privacy Policy',
                          '5. นโยบายความเป็นส่วนตัว',
                        ),
                        _lang.t(
                          'Your use of the App is also governed by our Privacy Policy. '
                              'We collect and process your personal data in accordance with applicable '
                              'data protection laws. By using the App, you consent to the collection, '
                              'use, and sharing of your information as described in our Privacy Policy. '
                              'We implement appropriate security measures to protect your personal data.',
                          'การใช้งานแอปของคุณยังอยู่ภายใต้นโยบายความเป็นส่วนตัวของเราด้วย '
                              'เรารวบรวมและประมวลผลข้อมูลส่วนบุคคลของคุณตามกฎหมายคุ้มครองข้อมูลส่วนบุคคล '
                              'โดยการใช้งานแอป คุณยินยอมให้เราเก็บรวบรวม ใช้งาน และแบ่งปันข้อมูลของคุณ '
                              'ตามที่อธิบายไว้ในนโยบายความเป็นส่วนตัว เราใช้มาตรการรักษาความปลอดภัย '
                              'ที่เหมาะสมเพื่อปกป้องข้อมูลส่วนบุคคลของคุณ',
                        ),
                      ),
                      _buildSection(
                        _lang.t(
                          '6. Intellectual Property',
                          '6. ทรัพย์สินทางปัญญา',
                        ),
                        _lang.t(
                          'All content, trademarks, logos, and intellectual property displayed on the App '
                              'are the property of Shakey or its licensors. You may not reproduce, distribute, '
                              'modify, or create derivative works from any content without our prior written '
                              'consent. Any unauthorized use may violate copyright, trademark, and other laws.',
                          'เนื้อหา เครื่องหมายการค้า โลโก้ และทรัพย์สินทางปัญญาทั้งหมดที่แสดงบนแอป '
                              'เป็นทรัพย์สินของ Shakey หรือผู้อนุญาตให้ใช้สิทธิ์ คุณต้องไม่ทำซ้ำ แจกจ่าย '
                              'แก้ไข หรือสร้างผลงานต่อเนื่องจากเนื้อหาใดๆ โดยไม่ได้รับความยินยอมเป็นลายลักษณ์อักษร '
                              'การใช้งานโดยไม่ได้รับอนุญาตอาจละเมิดกฎหมายลิขสิทธิ์ เครื่องหมายการค้า และกฎหมายอื่นๆ',
                        ),
                      ),
                      _buildSection(
                        _lang.t(
                          '7. Limitation of Liability',
                          '7. ข้อจำกัดความรับผิดชอบ',
                        ),
                        _lang.t(
                          'To the fullest extent permitted by law, Shakey shall not be liable for any '
                              'indirect, incidental, special, consequential, or punitive damages arising '
                              'out of or related to your use of the App. Our total liability for any claims '
                              'shall not exceed the amount paid by you for the specific product or service '
                              'giving rise to the claim.',
                          'ในขอบเขตสูงสุดที่กฎหมายอนุญาต Shakey จะไม่รับผิดชอบต่อความเสียหาย '
                              'ทางอ้อม ความเสียหายที่เกิดขึ้นโดยไม่ได้ตั้งใจ ความเสียหายพิเศษ หรือความเสียหายที่เกิดขึ้นตามมา '
                              'ที่เกิดจากการใช้งานแอป ความรับผิดทั้งหมดของเราต่อข้อเรียกร้องใดๆ '
                              'จะไม่เกินจำนวนเงินที่คุณชำระสำหรับสินค้าหรือบริการนั้นๆ',
                        ),
                      ),
                      _buildSection(
                        _lang.t('8. Modifications', '8. การแก้ไขเปลี่ยนแปลง'),
                        _lang.t(
                          'We reserve the right to modify these Terms and Conditions at any time. '
                              'Changes will be effective immediately upon posting in the App. '
                              'Your continued use of the App following any changes constitutes your '
                              'acceptance of the revised terms. We encourage you to review these terms '
                              'periodically for any updates.',
                          'เราขอสงวนสิทธิ์ในการแก้ไขข้อกำหนดและเงื่อนไขเหล่านี้ได้ทุกเมื่อ '
                              'การเปลี่ยนแปลงจะมีผลทันทีเมื่อมีการโพสต์ในแอป การที่คุณใช้งานแอปต่อไป '
                              'หลังจากการเปลี่ยนแปลงจะถือว่าคุณยอมรับข้อกำหนดที่แก้ไขแล้ว '
                              'เราขอแนะนำให้คุณตรวจสอบข้อกำหนดเหล่านี้เป็นระยะๆ เพื่อดูการอัปเดต',
                        ),
                      ),
                      _buildSection(
                        _lang.t('9. Contact Us', '9. ติดต่อเรา'),
                        _lang.t(
                          'If you have any questions about these Terms and Conditions, '
                              'please contact us at:\n\n'
                              '📧 Email: support@shakey.com\n'
                              '📞 Phone: +66 2-XXX-XXXX\n'
                              '🏢 Address: Bangkok, Thailand',
                          'หากคุณมีคำถามใดๆ เกี่ยวกับข้อกำหนดและเงื่อนไขเหล่านี้ '
                              'กรุณาติดต่อเราที่:\n\n'
                              '📧 อีเมล: support@shakey.com\n'
                              '📞 โทรศัพท์: +66 2-XXX-XXXX\n'
                              '🏢 ที่อยู่: กรุงเทพมหานคร, ประเทศไทย',
                        ),
                      ),

                      const SizedBox(height: 30),
                      // Footer
                      Center(
                        child: Text(
                          '© 2026 Shakey. ${_lang.t('All rights reserved.', 'สงวนลิขสิทธิ์ทั้งหมด')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
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

  Widget _buildSection(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.primaryRed.withOpacity(0.12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryRed,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
