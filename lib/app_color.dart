import 'package:flutter/material.dart';

class AppColor {
  const AppColor._();
  static const Color primaryRed = Color(0xFFE62553);
  static const Color cream = Color(0xFFFDF7E6);
  static const Color softGold = Color(0xFFF6E6B8);
  static const Color placeholder = Color(0xFFB7B7B7);

  static const Color bronzeColor = Color(0xFFAA5415);
  static const Color silverColor = Color(0xFF6F6B67);
  static const Color goldColor = Color(0xFFAA8515);

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF7E6), Color(0xFFFFE7B3)],
  );

  static const Gradient bronzeGradient = LinearGradient(
    begin: Alignment(-2.0, -1.0),
    end: Alignment(2.0, 1.0),
    colors: [
      Color(0xFFAA5415),
      Color(0xFFFFA578),
      Color(0xFFAA5415),
      Color(0xFFFFA578),
      Color(0xFFAA5415),
    ],
    stops: [0.0, 0.15, 0.4, 0.65, 0.9],
  );

  static const Gradient silverGradient = LinearGradient(
    begin: Alignment(-2.0, -1.0),
    end: Alignment(2.0, 1.0),
    colors: [
      Color(0xFF6F6B67),
      Color(0xFFD3CAC5),
      Color(0xFF6F6B67),
      Color(0xFFD3CAC5),
      Color(0xFF6F6B67),
    ],
    stops: [0.0, 0.15, 0.4, 0.65, 0.9],
  );

  static const Gradient goldGradient = LinearGradient(
    begin: Alignment(-2.0, -1.0),
    end: Alignment(2.0, 1.0),
    colors: [
      Color(0xFFAA8515),
      Color(0xFFFFE678),
      Color(0xFFAA8515),
      Color(0xFFFFE678),
      Color(0xFFAA8515),
    ],
    stops: [0.0, 0.15, 0.4, 0.65, 0.9],
  );

  static const Gradient couponGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFE62553), Color(0xFFEE315E)],
  );
}
