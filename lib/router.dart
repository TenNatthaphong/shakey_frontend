import 'package:flutter/material.dart';
import 'package:shakey/pages/menu_page.dart';
import 'package:shakey/pages/reward_page.dart';
import 'package:shakey/pages/more_page.dart';

import 'package:shakey/layout/main_layout.dart';

class AppRoutes {
  static const homePage = '/';
  static const menuPage = '/menu';
  static const rewardPage = '/reward';
  static const morePage = '/more';
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

      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
