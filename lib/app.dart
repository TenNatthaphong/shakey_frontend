import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'router.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class ShakeyApp extends StatelessWidget {
  const ShakeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shakey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFE72A53),
      ),
      scrollBehavior: AppScrollBehavior(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.homePage,
    );
  }
}
