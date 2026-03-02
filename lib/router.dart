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
