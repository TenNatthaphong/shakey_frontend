import 'package:flutter/material.dart';
import 'package:shakey/pages/menu_page.dart';
import 'package:shakey/pages/reward_page.dart';
import 'package:shakey/pages/more_page.dart';
import 'package:shakey/pages/login_page.dart';
import 'package:shakey/pages/register_page.dart';

import 'package:shakey/layout/main_layout.dart';

class AppRoutes {
  static const homePage = '/';
  static const menuPage = '/menu';
  static const rewardPage = '/reward';
  static const morePage = '/more';
  static const loginPage = '/login';
  static const registerPage = '/register';
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

      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
