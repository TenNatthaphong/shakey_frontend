import 'package:flutter/material.dart';

class AppColor {
  const AppColor._();
  static const Color primaryRed = Color(0xFFE62553);
  static const Color cream = Color(0xFFFDF7E6);
  static const Color softGold = Color(0xFFF6E6B8);
  static const Color placeholder = Color(0xFFB7B7B7);

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF7E6), Color(0xFFFFE7B3)],
  );
}
