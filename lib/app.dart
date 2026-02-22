import 'package:flutter/material.dart';
import 'router.dart';

class ShakeyApp extends StatelessWidget {
  const ShakeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shakey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: Color(0xFFE72A53)),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.HomePage,
    );
  }
}
