import 'package:flutter/material.dart';
import 'package:shakey/app.dart';
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/banner_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  await BannerService.instance.init();
  runApp(const ShakeyApp());
  //as
}
