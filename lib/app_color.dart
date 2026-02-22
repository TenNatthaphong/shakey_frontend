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

  static const Gradient goldGradient = LinearGradient(
    begin: Alignment(0.7, -1.0),
    end: Alignment(-1.0, 0.7),
    colors: [
      Color(0xFFAA8515),
      Color(0xFFFFE678),
      Color(0xFFAC8615),
      Color(0xFFFFE678),
      Color(0xFFAA8515),
    ],
    stops: [0.0, 0.18, 0.45, 0.72, 1.0],
  );

  static const Gradient couponGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFE62553), Color(0xFFEE315E)],
  );
}
