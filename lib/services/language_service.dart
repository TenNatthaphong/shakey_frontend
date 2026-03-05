import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService instance = LanguageService._internal();
  LanguageService._internal();

  String _currentLanguage = 'English';
  String get currentLanguage => _currentLanguage;

  bool get isThai => _currentLanguage == 'ภาษาไทย';

  void setLanguage(String language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  // Quick helper for translations
  String t(String english, String thai) {
    return isThai ? thai : english;
  }

  String get(String key) {
    if (!_translations.containsKey(key)) return key;
    return _translations[key]![currentLanguage] ?? key;
  }

  // Predefined common strings
  Map<String, Map<String, String>> get _translations => {
    // Navigation / General
    'home': {'English': 'Home', 'ภาษาไทย': 'หน้าแรก'},
    'menu': {'English': 'Menu', 'ภาษาไทย': 'เมนู'},
    'rewards': {'English': 'Rewards', 'ภาษาไทย': 'รางวัล'},
    'more': {'English': 'More', 'ภาษาไทย': 'เพิ่มเติม'},
    'settings': {'English': 'Settings', 'ภาษาไทย': 'การตั้งค่า'},
    'notifications': {'English': 'Notifications', 'ภาษาไทย': 'การแจ้งเตือน'},
    'language': {'English': 'Language', 'ภาษาไทย': 'ภาษา'},
    'select_language': {'English': 'Select Language', 'ภาษาไทย': 'เลือกภาษา'},
    'about': {'English': 'About', 'ภาษาไทย': 'เกี่ยวกับ'},
    'help': {'English': 'Help', 'ภาษาไทย': 'ช่วยเหลือ'},
    'faq': {'English': 'FAQ', 'ภาษาไทย': 'คำถามที่พบบ่อย'},
    'contact': {'English': 'Contact', 'ภาษาไทย': 'ติดต่อเรา'},
    'terms': {
      'English': 'Terms and Conditions',
      'ภาษาไทย': 'ข้อกำหนดและเงื่อนไข',
    },
    'order': {'English': 'Order', 'ภาษาไทย': 'สั่งอาหาร'},
    'deliver_now': {'English': 'Deliver Now', 'ภาษาไทย': 'จัดส่งทันที'},
    'pick_up': {'English': 'Pick Up', 'ภาษาไทย': 'รับที่ร้าน'},
    'add_new_address': {
      'English': 'Add New Address',
      'ภาษาไทย': 'เพิ่มที่อยู่ใหม่',
    },
    'add_address_title': {'English': 'Add Address', 'ภาษาไทย': 'เพิ่มที่อยู่'},
    'edit_address_title': {
      'English': 'Edit Address',
      'ภาษาไทย': 'แก้ไขที่อยู่',
    },
    'address_name': {
      'English': 'Address Name (e.g., Home, Work)',
      'ภาษาไทย': 'ชื่อที่อยู่ (เช่น บ้าน, ที่ทำงาน)',
    },
    'detail_address': {
      'English': 'Detailed Address',
      'ภาษาไทย': 'รายละเอียดที่อยู่',
    },
    'select_address': {'English': 'Select Address', 'ภาษาไทย': 'เลือกที่อยู่'},
    'select_branch': {'English': 'Select Branch', 'ภาษาไทย': 'เลือกสาขา'},
    'search_hint': {
      'English': 'Search for drinks...',
      'ภาษาไทย': 'ค้นหาเครื่องดื่ม...',
    },
    // Home / Dashboard
    'recent_orders': {
      'English': 'Recent Orders',
      'ภาษาไทย': 'คำสั่งซื้อล่าสุด',
    },
    'view_all': {'English': 'View All', 'ภาษาไทย': 'ดูทั้งหมด'},
    'special_offers': {'English': 'Special Offers', 'ภาษาไทย': 'ข้อเสนอพิเศษ'},
    'earn_point': {'English': 'Earn Points', 'ภาษาไทย': 'รับคะแนน'},
    'mock_qr_scanner': {
      'English': 'Simulate QR Scan',
      'ภาษาไทย': 'จำลองการสแกน QR',
    },
    'scan_success': {'English': 'Scan Success', 'ภาษาไทย': 'สแกนสำเร็จ'},
    'status': {'English': 'Status', 'ภาษาไทย': 'สถานะ'},
    'no_recent_orders': {
      'English': 'No recent orders yet',
      'ภาษาไทย': 'ไม่มีรายการสั่งซื้อล่าสุด',
    },
    'items_more': {
      'English': '+{n} more items',
      'ภาษาไทย': '+{n} รายการเพิ่มเติม',
    },
    'one_item': {'English': '1 item', 'ภาษาไทย': '1 รายการ'},
    'total_price': {'English': 'Total Price', 'ภาษาไทย': 'ราคารวม'},
    'delivery': {'English': 'Delivery', 'ภาษาไทย': 'บริการส่ง'},
    'pickup': {'English': 'Pickup', 'ภาษาไทย': 'รับที่ร้าน'},
    'rewards_for_you': {
      'English': 'Rewards for you',
      'ภาษาไทย': 'รางวัลสำหรับคุณ',
    },
    'recent_order_header': {
      'English': 'Recent Order',
      'ภาษาไทย': 'รายการสั่งซื้อล่าสุด',
    },
    'no_rewards_available_home': {
      'English': 'No rewards available',
      'ภาษาไทย': 'ไม่มีของรางวัลในขณะนี้',
    },
    'see_all': {'English': 'See all', 'ภาษาไทย': 'ดูทั้งหมด'},
    'redeem_now': {'English': 'Redeem Now', 'ภาษาไทย': 'แลกรางวัลตอนนี้'},
    'pts_unit': {'English': 'Pts', 'ภาษาไทย': 'คะแนน'},
    'no_expiry_text': {'English': 'No Expiry', 'ภาษาไทย': 'ไม่มีวันหมดอายุ'},
    'valid_until_text': {'English': 'Valid until', 'ภาษาไทย': 'ใช้ได้ถึง'},

    // Auth
    'login': {'English': 'Login', 'ภาษาไทย': 'เข้าสู่ระบบ'},
    'register': {'English': 'Register', 'ภาษาไทย': 'ลงทะเบียน'},
    'logout': {'English': 'Log out', 'ภาษาไทย': 'ออกจากระบบ'},
    'email': {'English': 'Email', 'ภาษาไทย': 'อีเมล'},
    'password': {'English': 'Password', 'ภาษาไทย': 'รหัสผ่าน'},
    'confirm_password': {
      'English': 'Confirm Password',
      'ภาษาไทย': 'ยืนยันรหัสผ่าน',
    },
    'forgot_password': {
      'English': 'Forgot Password?',
      'ภาษาไทย': 'ลืมรหัสผ่าน?',
    },
    'username': {'English': 'Username', 'ภาษาไทย': 'ชื่อผู้ใช้'},
    'phone': {'English': 'Phone Number', 'ภาษาไทย': 'เบอร์โทรศัพท์'},
    'sign_in': {'English': 'Sign In', 'ภาษาไทย': 'เข้าสู่ระบบ'},
    'or_login_with': {
      'English': 'or login with',
      'ภาษาไทย': 'หรือเข้าสู่ระบบด้วย',
    },
    'no_account_yet': {
      'English': 'No account yet? ',
      'ภาษาไทย': 'ยังไม่มีบัญชี? ',
    },
    'already_have_account': {
      'English': 'Already have an account? ',
      'ภาษาไทย': 'มีบัญชีอยู่แล้ว? ',
    },
    'registration_success': {
      'English': 'Registration successful!',
      'ภาษาไทย': 'ลงทะเบียนสำเร็จ!',
    },
    'passwords_not_match': {
      'English': 'Passwords do not match',
      'ภาษาไทย': 'รหัสผ่านไม่ตรงกัน',
    },
    'accept_terms': {
      'English': 'I accept terms of the agreement',
      'ภาษาไทย': 'ฉันยอมรับข้อกำหนดและเงื่อนไข',
    },
    'logout_confirm_msg': {
      'English': 'Are you sure you want to log out?',
      'ภาษาไทย': 'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?',
    },

    // PIN / Security
    'change_pin': {'English': 'Change PIN', 'ภาษาไทย': 'เปลี่ยน PIN'},
    'change_password': {
      'English': 'Change Password',
      'ภาษาไทย': 'เปลี่ยนรหัสผ่าน',
    },
    'enter_your_pin': {'English': 'Enter your PIN', 'ภาษาไทย': 'กรุณาใส่ PIN'},
    'set_new_pin': {'English': 'Set new PIN', 'ภาษาไทย': 'ตั้งค่า PIN ใหม่'},
    'confirm_new_pin': {
      'English': 'Confirm new PIN',
      'ภาษาไทย': 'ยืนยัน PIN ใหม่',
    },
    'enter_old_pin': {'English': 'Enter old PIN', 'ภาษาไทย': 'ใส่ PIN เดิม'},
    'incorrect_pin': {'English': 'Incorrect PIN', 'ภาษาไทย': 'PIN ไม่ถูกต้อง'},
    'incorrect_old_pin': {
      'English': 'Incorrect old PIN',
      'ภาษาไทย': 'PIN เดิมไม่ถูกต้อง',
    },
    'pins_not_match': {
      'English': 'PINs do not match',
      'ภาษาไทย': 'PIN ไม่ตรงกัน',
    },
    'new_password': {'English': 'New Password', 'ภาษาไทย': 'รหัสผ่านใหม่'},
    'enter_full_otp': {
      'English': 'Please enter the full 6-digit OTP',
      'ภาษาไทย': 'กรุณากรอกรหัส OTP ให้ครบ 6 หลัก',
    },
    'please_enter_new_password': {
      'English': 'Please enter your new password',
      'ภาษาไทย': 'กรุณากรอกรหัสผ่านใหม่ของคุณ',
    },

    // Auth Messages
    'enter_email_password': {
      'English': 'Please enter your email and password',
      'ภาษาไทย': 'กรุณากรอกอีเมลและรหัสผ่าน',
    },
    'accept_terms_error': {
      'English': 'Please accept the terms and conditions',
      'ภาษาไทย': 'กรุณายอมรับข้อกำหนดและเงื่อนไข',
    },
    'please_enter_email': {
      'English': 'Please enter your email',
      'ภาษาไทย': 'กรุณากรอกอีเมลของคุณ',
    },
    'enter_email_otp_msg': {
      'English':
          "Enter your email address and we'll send you an OTP code to reset your password.",
      'ภาษาไทย': 'กรอกอีเมลของคุณเพื่อรับรหัส OTP สำหรับการรีเซ็ตรหัสผ่าน',
    },
    'otp_verification': {
      'English': 'OTP Verification',
      'ภาษาไทย': 'การยืนยัน OTP',
    },
    'enter_otp_sent_to': {
      'English': 'Please enter the 6-digit code sent to',
      'ภาษาไทย': 'กรุณากรอกรหัส 6 หลักที่ส่งไปยัง',
    },
    'didnt_receive_otp': {
      'English': "Didn't receive the code? ",
      'ภาษาไทย': 'ไม่ได้รับรหัสใช่หรือไม่? ',
    },
    'resend_otp': {'English': 'Resend OTP', 'ภาษาไทย': 'ส่งรหัสใหม่'},
    'send_otp': {'English': 'Send OTP', 'ภาษาไทย': 'ส่งรหัส OTP'},
    'verify': {'English': 'Verify', 'ภาษาไทย': 'ยืนยัน'},
    'otp_sent_success': {
      'English': 'OTP sent successfully!',
      'ภาษาไทย': 'ส่งรหัส OTP เรียบร้อยแล้ว!',
    },
    'reset_password': {
      'English': 'Reset Password',
      'ภาษาไทย': 'รีเซ็ตรหัสผ่าน',
    },
    'enter_new_password_msg': {
      'English': 'Please enter your new password below.',
      'ภาษาไทย': 'กรุณากรอกรหัสผ่านใหม่ของคุณด้านล่าง',
    },
    'update_password': {
      'English': 'Update Password',
      'ภาษาไทย': 'อัปเดตรหัสผ่าน',
    },
    'password_reset_success': {
      'English': 'Password reset successfully!',
      'ภาษาไทย': 'รีเซ็ตรหัสผ่านเรียบร้อยแล้ว!',
    },

    // User / Profile
    'edit_profile': {'English': 'Edit Profile', 'ภาษาไทย': 'แก้ไขโปรไฟล์'},
    'guest': {'English': 'Guest', 'ภาษาไทย': 'ผู้เยี่ยมชม'},
    'first_name': {'English': 'First Name', 'ภาษาไทย': 'ชื่อจริง'},
    'last_name': {'English': 'Last Name', 'ภาษาไทย': 'นามสกุล'},
    'surname': {'English': 'Surname', 'ภาษาไทย': 'นามสกุล'},
    'birthday': {'English': 'Birthday', 'ภาษาไทย': 'วันเกิด'},
    'points': {'English': 'Points', 'ภาษาไทย': 'คะแนน'},
    'pts': {'English': 'pts', 'ภาษาไทย': 'คะแนน'},
    'phone_number': {'English': 'Phone Number', 'ภาษาไทย': 'เบอร์โทรศัพท์'},
    'select_birthday': {
      'English': 'Select Birthday',
      'ภาษาไทย': 'เลือกวันเกิด',
    },
    'profile_updated': {
      'English': 'Profile updated successfully!',
      'ภาษาไทย': 'อัปเดตโปรไฟล์เรียบร้อยแล้ว!',
    },
    'profile_update_failed': {
      'English': 'Failed to update profile',
      'ภาษาไทย': 'อัปเดตโปรไฟล์ไม่สำเร็จ',
    },
    'redeemed_success': {
      'English': 'Redeemed successfully!',
      'ภาษาไทย': 'แลกรางวัลสำเร็จ!',
    },
    'redeem_success_title': {
      'English': 'Redeem Success',
      'ภาษาไทย': 'แลกรางวัลสำเร็จ',
    },
    'redeem_success_msg': {
      'English': 'Your reward has been added to My Rewards.',
      'ภาษาไทย': 'รางวัลของคุณถูกเพิ่มไปยัง "ของรางวัลของฉัน" เรียบร้อยแล้ว',
    },
    'reward_used_title': {
      'English': 'Reward Used',
      'ภาษาไทย': 'ใช้รางวัลสำเร็จ',
    },
    'reward_used_msg': {
      'English': 'Your reward has been successfully applied.',
      'ภาษาไทย': 'รางวัลของคุณถูกใช้งานเรียบร้อยแล้ว',
    },
    'not_enough_points_msg': {
      'English': 'Not enough points. You need',
      'ภาษาไทย': 'คะแนนไม่พอ คุณต้องมี',
    },
    'reward_detail': {
      'English': 'Reward Detail',
      'ภาษาไทย': 'รายละเอียดรางวัล',
    },
    'no_owned_rewards': {
      'English': 'No rewards owned yet',
      'ภาษาไทย': 'คุณยังไม่มีของรางวัล',
    },
    'voucher_detail': {
      'English': 'Voucher Detail',
      'ภาษาไทย': 'รายละเอียดเวาเชอร์',
    },
    'points_required': {
      'English': ' Points required',
      'ภาษาไทย': ' คะแนนที่ต้องใช้',
    },
    'conditions': {'English': 'Conditions', 'ภาษาไทย': 'เงื่อนไข'},
    'no_conditions': {'English': 'No conditions', 'ภาษาไทย': 'ไม่มีเงื่อนไข'},
    'use_reward_now': {
      'English': 'Use Reward Now',
      'ภาษาไทย': 'ใช้รางวัลทันที',
    },
    'points_deducted_msg': {
      'English': 'Points will be deducted upon redemption',
      'ภาษาไทย': 'คะแนนจะถูกหักเมื่อกดแลกรางวัล',
    },
    'show_to_staff_msg': {
      'English': 'Please show this screen to the restaurant staff',
      'ภาษาไทย': 'กรุณาแสดงหน้านี้ให้พนักงานที่ร้านดู',
    },
    'scanned_qr_msg': {'English': 'Scanned QR: ', 'ภาษาไทย': 'สแกน QR: '},
    'enter_username': {
      'English': 'Enter your username',
      'ภาษาไทย': 'กรอกชื่อผู้ใช้',
    },
    'enter_first_name': {
      'English': 'Enter your first name',
      'ภาษาไทย': 'กรอกชื่อจริง',
    },
    'enter_last_name': {
      'English': 'Enter your last name',
      'ภาษาไทย': 'กรอกนามสกุล',
    },
    'enter_phone_number': {
      'English': 'Enter your phone number',
      'ภาษาไทย': 'กรอกเบอร์โทรศัพท์',
    },
    'please_enter_username': {
      'English': 'Please enter your username',
      'ภาษาไทย': 'กรุณากรอกชื่อผู้ใช้',
    },
    'please_enter_first_name': {
      'English': 'Please enter your first name',
      'ภาษาไทย': 'กรุณากรอกชื่อจริง',
    },
    'please_enter_last_name': {
      'English': 'Please enter your last name',
      'ภาษาไทย': 'กรุณากรอกนามสกุล',
    },
    'please_enter_phone_number': {
      'English': 'Please enter your phone number',
      'ภาษาไทย': 'กรุณากรอกเบอร์โทรศัพท์',
    },

    // Shop / Cart
    'cat_today_offer': {
      'English': 'Today\'s Offer',
      'ภาษาไทย': 'ข้อเสนอวันนี้',
    },
    'cat_for_you': {'English': 'For You', 'ภาษาไทย': 'สำหรับคุณ'},
    'cat_favorites': {'English': 'Favorites', 'ภาษาไทย': 'รายการโปรด'},
    'cat_popular': {'English': 'Popular', 'ภาษาไทย': 'ยอดนิยม'},
    'cat_milk_tea': {'English': 'Milk Tea', 'ภาษาไทย': 'ชานม'},
    'cat_fruit_tea': {'English': 'Fruit Tea', 'ภาษาไทย': 'ชาผลไม้'},
    'cat_vegetarian': {'English': 'Vegetarian', 'ภาษาไทย': 'มังสวิรัติ'},
    'add_to_cart': {'English': 'Add to Cart', 'ภาษาไทย': 'เพิ่มลงตะกร้า'},
    'my_cart': {'English': 'My Cart', 'ภาษาไทย': 'ตะกร้าของฉัน'},
    'my_basket': {'English': 'My Basket', 'ภาษาไทย': 'ตะกร้าของฉัน'},
    'total_amount': {'English': 'Total Amount', 'ภาษาไทย': 'จำนวนเงินทั้งหมด'},
    'cart_empty': {
      'English': 'Your cart is empty',
      'ภาษาไทย': 'ตะกร้าของคุณยังว่างอยู่',
    },
    'delivery_fee': {'English': 'Delivery Fee', 'ภาษาไทย': 'ค่าจัดส่ง'},
    'size': {'English': 'Size', 'ภาษาไทย': 'ขนาด'},
    'sweetness': {'English': 'Sweetness', 'ภาษาไทย': 'ความหวาน'},
    'toppings': {'English': 'Toppings', 'ภาษาไทย': 'ท็อปปิ้ง'},
    'note': {'English': 'Note', 'ภาษาไทย': 'หมายเหตุ'},
    'sweet_100': {'English': '100% Sweet', 'ภาษาไทย': 'หวาน 100%'},
    'sweet_75': {'English': '75% Sweet', 'ภาษาไทย': 'หวาน 75%'},
    'sweet_50': {'English': '50% Sweet', 'ภาษาไทย': 'หวาน 50%'},
    'sweet_25': {'English': '25% Sweet', 'ภาษาไทย': 'หวาน 25%'},
    'sweet_0': {'English': '0% Sweet', 'ภาษาไทย': 'หวาน 0%'},

    // Menu Detail
    'pick_1': {'English': 'Pick 1', 'ภาษาไทย': 'เลือก 1 อย่าง'},
    'sweetness_level': {
      'English': 'Sweetness Level',
      'ภาษาไทย': 'ระดับความหวาน',
    },
    'add_toppings': {'English': 'Add Toppings', 'ภาษาไทย': 'เพิ่มท็อปปิ้ง'},
    'no_size': {
      'English': 'No size options available',
      'ภาษาไทย': 'ไม่มีตัวเลือกขนาด',
    },
    'no_topping': {
      'English': 'No toppings available',
      'ภาษาไทย': 'ไม่มีท็อปปิ้ง',
    },
    'note_to_restaurant': {
      'English': 'Note to Restaurant',
      'ภาษาไทย': 'ระบุรายละเอียดถึงร้าน',
    },
    'optional': {'English': '(Optional)', 'ภาษาไทย': '(ไม่บังคับ)'},
    'note_hint': {
      'English': 'e.g. less ice, no straw...',
      'ภาษาไทย': 'เช่น รับน้ำแข็งน้อย, ไม่รับหลอด...',
    },
    'add_to_basket': {'English': 'Add to Basket', 'ภาษาไทย': 'ใส่ตะกร้า'},
    'base_price': {'English': 'Base price', 'ภาษาไทย': 'ราคาเริ่มต้น'},
    'failed': {'English': 'Failed', 'ภาษาไทย': 'ผิดพลาด'},

    // Rewards
    'member': {'English': 'Member', 'ภาษาไทย': 'สมาชิก'},
    'privilege': {'English': 'Privilege', 'ภาษาไทย': 'สิทธิพิเศษ'},
    'member_privileges': {
      'English': ' Member Privileges',
      'ภาษาไทย': ' สิทธิพิเศษสมาชิก',
    },
    'available': {'English': 'Available', 'ภาษาไทย': 'ที่ใช้ได้'},
    'my_rewards': {'English': 'My Rewards', 'ภาษาไทย': 'ของรางวัลของฉัน'},
    'no_rewards_available': {
      'English': 'No rewards available',
      'ภาษาไทย': 'ไม่มีของรางวัลในขณะนี้',
    },
    'redeem': {'English': 'Redeem', 'ภาษาไทย': 'แลกรางวัล'},
    'redeem_rewards': {'English': 'Redeem Rewards', 'ภาษาไทย': 'แลกของรางวัล'},
    'no_expiry': {'English': 'No expiry', 'ภาษาไทย': 'ไม่มีวันหมดอายุ'},
    'valid_until': {'English': 'Valid until', 'ภาษาไทย': 'ใช้ได้ถึง'},
    'max_level': {
      'English': 'Max level reached!',
      'ภาษาไทย': 'ระดับสูงสุดแล้ว!',
    },
    'another': {'English': 'Another', 'ภาษาไทย': 'อีก'},
    'cups_to': {'English': 'cups to', 'ภาษาไทย': 'แก้วเพื่อเป็น'},
    'reach_silver': {
      'English': 'reach Silver member',
      'ภาษาไทย': 'ระดับ Silver',
    },
    'reach_gold': {'English': 'reach Gold member', 'ภาษาไทย': 'ระดับ Gold'},
    'join_member_earn': {
      'English': 'Join member to earn points',
      'ภาษาไทย': 'สมัครสมาชิกเพื่อสะสมคะแนน',
    },
    'bronze_member': {'English': 'Bronze Member', 'ภาษาไทย': 'ระดับ Bronze'},
    'silver_member': {'English': 'Silver Member', 'ภาษาไทย': 'ระดับ Silver'},
    'gold_member': {'English': 'Gold Member', 'ภาษาไทย': 'ระดับ Gold'},

    // Privileges
    'privilege_discount': {
      'English': '• 10% discount on all drinks',
      'ภาษาไทย': '• ส่วนลด 10% สำหรับเครื่องดื่มทุกเมนู',
    },
    'privilege_birthday': {
      'English': '• Birthday special gift',
      'ภาษาไทย': '• ของขวัญพิเศษในวันเกิด',
    },
    'privilege_double_points': {
      'English': '• Double points on weekends',
      'ภาษาไทย': '• รับคะแนน 2 เท่าในวันเสาร์-อาทิตย์',
    },
    'privilege_early_access': {
      'English': '• Exclusive early access to new menus',
      'ภาษาไทย': '• สิทธิ์ในการสั่งเมนูใหม่ก่อนใคร',
    },

    // App Settings Details
    'push_notifications': {
      'English': 'Push Notifications',
      'ภาษาไทย': 'การแจ้งเตือนแบบพุช',
    },
    'order_updates': {
      'English': 'Order Updates',
      'ภาษาไทย': 'อัปเดตคำสั่งซื้อ',
    },
    'promotions': {'English': 'Promotions', 'ภาษาไทย': 'โปรโมชั่น'},
    'sound_haptics': {
      'English': 'Sound & Haptics',
      'ภาษาไทย': 'เสียงและการสั่น',
    },
    'sound': {'English': 'Sound', 'ภาษาไทย': 'เสียง'},
    'vibration': {'English': 'Vibration', 'ภาษาไทย': 'การสั่น'},
    'app_language': {'English': 'App Language', 'ภาษาไทย': 'ภาษาของแอป'},
    'clear_cache': {'English': 'Clear Cache', 'ภาษาไทย': 'ล้างแคช'},
    'version': {'English': 'App Version', 'ภาษาไทย': 'เวอร์ชันแอป'},
    'build': {'English': 'Build Number', 'ภาษาไทย': 'หมายเลขบิลด์'},
    'framework': {'English': 'Framework', 'ภาษาไทย': 'เฟรมเวิร์ก'},

    // Settings Messages
    'order_updates_msg': {
      'English': 'Get notified about your order status',
      'ภาษาไทย': 'รับการแจ้งเตือนเกี่ยวกับสถานะคำสั่งซื้อของคุณ',
    },
    'promotions_msg': {
      'English': 'Receive updates on new deals and offers',
      'ภาษาไทย': 'รับข้อมูลอัปเดตเกี่ยวกับดีลและข้อเสนอใหม่ๆ',
    },
    'sound_msg': {
      'English': 'Enable sound effects in the app',
      'ภาษาไทย': 'เปิดใช้งานเสียงเอฟเฟกต์ในแอป',
    },
    'vibration_msg': {
      'English': 'Enable haptic feedback',
      'ภาษาไทย': 'เปิดใช้งานการสั่นต้อบสนอง',
    },
    'clear_cache_msg': {
      'English': 'Free up space by clearing temporary data',
      'ภาษาไทย': 'เพิ่มพื้นที่ว่างโดยการล้างข้อมูลชั่วคราว',
    },
    'cache_cleared_msg': {
      'English': 'Cache cleared successfully',
      'ภาษาไทย': 'ล้างแคชเรียบร้อยแล้ว',
    },

    // Dialogs / Actions
    'ok': {'English': 'OK', 'ภาษาไทย': 'ตกลง'},
    'cancel': {'English': 'Cancel', 'ภาษาไทย': 'ยกเลิก'},
    'confirm': {'English': 'Confirm', 'ภาษาไทย': 'ยืนยัน'},
    'save': {'English': 'Save', 'ภาษาไทย': 'บันทึก'},
    'save_changes': {
      'English': 'Save Changes',
      'ภาษาไทย': 'บันทึกการเปลี่ยนแปลง',
    },
    'delete': {'English': 'Delete', 'ภาษาไทย': 'ลบ'},
    'edit': {'English': 'Edit', 'ภาษาไทย': 'แก้ไข'},
    'success': {'English': 'Success', 'ภาษาไทย': 'สำเร็จ'},
    'error': {'English': 'Error', 'ภาษาไทย': 'เกิดข้อผิดพลาด'},
    'close': {'English': 'Close', 'ภาษาไทย': 'ปิด'},
    'continue_txt': {'English': 'Continue', 'ภาษาไทย': 'ดำเนินการต่อ'},

    // Messages / Errors
    'email_not_found': {
      'English': 'User email not found',
      'ภาษาไทย': 'ไม่พบอีเมลของผู้ใช้',
    },
    'fill_all_fields': {
      'English': 'Please fill in all fields',
      'ภาษาไทย': 'กรุณากรอกข้อมูลให้ครบทุกช่อง',
    },
    'login_redeem_error': {
      'English': 'Please login to redeem rewards',
      'ภาษาไทย': 'กรุณาเข้าสู่ระบบเพื่อแลกของรางวัล',
    },
    'login_fav_error': {
      'English': 'Please login to add favorites',
      'ภาษาไทย': 'กรุณาเข้าสู่ระบบเพื่อเพิ่มรายการโปรด',
    },
    'demo_mode_msg': {
      'English': 'Demo mode: tap "Scan Success" to simulate QR result',
      'ภาษาไทย': 'โหมดสาธิต: แตะ "สแกนสำเร็จ" เพื่อจำลองผลลัพธ์ QR',
    },

    // Checkout & Orders
    'payment_method': {
      'English': 'Payment Method',
      'ภาษาไทย': 'วิธีการชำระเงิน',
    },
    'qr_payment': {'English': 'QR Payment', 'ภาษาไทย': 'ชำระผ่าน QR'},
    'pay_now': {'English': 'Pay Now', 'ภาษาไทย': 'ชำระเงินตอนนี้'},
    'order_placed': {'English': 'Order Placed!', 'ภาษาไทย': 'สั่งซื้อสำเร็จ!'},
    'order_success_msg': {
      'English':
          'Your order has been placed successfully. We are preparing it for you!',
      'ภาษาไทย':
          'คำสั่งซื้อของคุณได้รับการยืนยันแล้ว เรากำลังเตรียมสินค้าให้คุณ!',
    },
    'failed_order': {
      'English': 'Failed to place order. Please try again.',
      'ภาษาไทย': 'สั่งซื้อไม่สำเร็จ กรุณาลองใหม่อีกครั้ง',
    },
    'back_to_home': {'English': 'Back to Home', 'ภาษาไทย': 'กลับสู่หน้าหลัก'},
    'summary': {'English': 'Order Summary', 'ภาษาไทย': 'สรุปคำสั่งซื้อ'},
    'variant_normal': {'English': 'Regular', 'ภาษาไทย': 'ปกติ'},
  };
}
