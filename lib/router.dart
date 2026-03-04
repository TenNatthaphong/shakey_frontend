import 'package:flutter/material.dart';
import 'package:shakey/pages/menu_page.dart';
import 'package:shakey/pages/reward_page.dart';
import 'package:shakey/pages/more_page.dart';
import 'package:shakey/pages/login_page.dart';
import 'package:shakey/pages/register_page.dart';
import 'package:shakey/pages/menu_detail_page.dart';
import 'package:shakey/pages/cart_page.dart';
import 'package:shakey/pages/pin_page.dart';
import 'package:shakey/pages/forgot_password_page.dart';
import 'package:shakey/pages/otp_verification_page.dart';
import 'package:shakey/pages/reset_password_page.dart';
import 'package:shakey/pages/checkout_page.dart';
import 'package:shakey/pages/terms_and_conditions_page.dart';
import 'package:shakey/pages/faq_page.dart';
import 'package:shakey/pages/contact_page.dart';
import 'package:shakey/pages/help_page.dart';
import 'package:shakey/pages/setting_page.dart';
import 'package:shakey/models/menu.dart';

import 'package:shakey/layout/main_layout.dart';

class AppRoutes {
  static const homePage = '/';
  static const menuPage = '/menu';
  static const rewardPage = '/reward';
  static const morePage = '/more';
  static const loginPage = '/login';
  static const registerPage = '/register';
  static const menuDetailPage = '/menu-detail';
  static const cartPage = '/cart';
  static const pinPage = '/pin';
  static const forgotPasswordPage = '/forgot-password';
  static const otpVerificationPage = '/otp-verification';
  static const resetPasswordPage = '/reset-password';
  static const checkoutPage = '/checkout';
  static const termsAndConditionsPage = '/terms-and-conditions';
  static const faqPage = '/faq';
  static const contactPage = '/contact';
  static const helpPage = '/help';
  static const settingPage = '/setting';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homePage:
        return MaterialPageRoute(builder: (context) => const MainLayout());

      case AppRoutes.menuPage:
        return MaterialPageRoute(builder: (context) => const MenuPage());

      case AppRoutes.rewardPage:
        return MaterialPageRoute(builder: (context) => const RewardPage());

      case AppRoutes.morePage:
        return MaterialPageRoute(builder: (context) => const MorePage());

      case AppRoutes.loginPage:
        return MaterialPageRoute(builder: (context) => const LoginPage());

      case AppRoutes.registerPage:
        return MaterialPageRoute(builder: (context) => const RegisterPage());
      case AppRoutes.menuDetailPage:
        final menu = settings.arguments as Menu;
        return MaterialPageRoute(
          builder: (context) => MenuDetailPage(menu: menu),
        );

      case AppRoutes.cartPage:
        return MaterialPageRoute(builder: (context) => const CartPage());

      case AppRoutes.checkoutPage:
        return MaterialPageRoute(builder: (context) => const CheckoutPage());

      case AppRoutes.termsAndConditionsPage:
        return MaterialPageRoute(
          builder: (context) => const TermsAndConditionsPage(),
        );

      case AppRoutes.faqPage:
        return MaterialPageRoute(builder: (context) => const FaqPage());

      case AppRoutes.contactPage:
        return MaterialPageRoute(builder: (context) => const ContactPage());

      case AppRoutes.helpPage:
        return MaterialPageRoute(builder: (context) => const HelpPage());

      case AppRoutes.settingPage:
        return MaterialPageRoute(builder: (context) => const SettingPage());

      case AppRoutes.pinPage:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => PinPage(isSetting: args?['isSetting'] ?? false),
        );

      case AppRoutes.forgotPasswordPage:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordPage(),
        );

      case AppRoutes.otpVerificationPage:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => OtpVerificationPage(email: email),
        );

      case AppRoutes.resetPasswordPage:
        final resetToken = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ResetPasswordPage(resetToken: resetToken),
        );

      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
