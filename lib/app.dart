import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'router.dart';
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/language_service.dart';
import 'package:shakey/app_text_style.dart';

const Size _fixedAppSize = Size(390, 844);

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class ShakeyApp extends StatefulWidget {
  const ShakeyApp({super.key});

  @override
  State<ShakeyApp> createState() => _ShakeyAppState();
}

class _ShakeyAppState extends State<ShakeyApp> {
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
    return MaterialApp(
      title: 'Shakey',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        return ColoredBox(
          color: const Color(0xFF101418),
          child: Center(
            child: SizedBox(
              width: _fixedAppSize.width,
              height: _fixedAppSize.height,
              child: ClipRect(
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(size: _fixedAppSize),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFE72A53),
        fontFamily: AppTextStyle.fontFamily,
        fontFamilyFallback: AppTextStyle.fontFamilyFallback,
        textTheme: AppTextStyle.textTheme,
      ),
      scrollBehavior: AppScrollBehavior(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AuthService.instance.isAuthenticated
          ? (AuthService.instance.hasPin
                ? AppRoutes.pinPage
                : AppRoutes.homePage)
          : AppRoutes.loginPage,
    );
  }
}
