import 'package:flutter/material.dart';
import 'package:shakey/pages/home_page.dart';
import 'package:shakey/pages/menu_page.dart';
import 'package:shakey/pages/reward_page.dart';
import 'package:shakey/pages/more_page.dart';

class AppRoutes {
  static const HomePage = '/';
  static const MenuPage = '/menu';
  static const RewardPage = '/reward';
  static const MorePage = '/more';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.HomePage:
        return MaterialPageRoute(builder: (context) => const HomePage());

      case AppRoutes.MenuPage:
        return MaterialPageRoute(builder: (context) => const MenuPage());

      case AppRoutes.RewardPage:
        return MaterialPageRoute(builder: (context) => const RewardPage());

      case AppRoutes.MorePage:
        return MaterialPageRoute(builder: (context) => const MorePage());

      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
