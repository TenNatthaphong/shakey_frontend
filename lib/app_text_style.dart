import 'package:flutter/material.dart';

/// Centralized text style helper using Kanit font with optimized weights.
class AppTextStyle {
  AppTextStyle._();

  // ── Font family helpers ──────────────────────────────────────────────

  /// Primary font family — Kanit for all languages.
  static String get fontFamily => 'Kanit';

  /// Fallback font family.
  static List<String> get fontFamilyFallback => const ['Nunito'];

  /// Returns the font size (pass-through, kept for API compatibility).
  static double fontSize(double size) => size;

  // ── Weight mapping (tuned for Kanit) ──────────────────────────────────

  /// Hero / display headings (e.g. page titles)
  static FontWeight get heroWeight => FontWeight.w600;

  /// Section titles / card headers
  static FontWeight get titleWeight => FontWeight.w500;

  /// Buttons and labels
  static FontWeight get labelWeight => FontWeight.w500;

  /// Bold body text (emphasis within paragraphs)
  static FontWeight get bodyBoldWeight => FontWeight.w500;

  /// Regular body text
  static FontWeight get bodyWeight => FontWeight.w400;

  /// Captions, subtitles, secondary info
  static FontWeight get captionWeight => FontWeight.w300;

  // ── Convenience TextStyle builders ───────────────────────────────────

  /// Creates a TextStyle with the correct font family for the current language.
  static TextStyle style({
    double? size,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: size != null ? fontSize(size) : null,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Hero heading style (page titles like "Sign In", "Order").
  static TextStyle hero({
    double fontSize = 28,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return style(
      size: fontSize,
      fontWeight: heroWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Section title style (e.g. "Recent Orders", "Rewards for you").
  static TextStyle title({
    double fontSize = 20,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return style(
      size: fontSize,
      fontWeight: titleWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Label / button text style.
  static TextStyle label({
    double fontSize = 16,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return style(
      size: fontSize,
      fontWeight: labelWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Body text style.
  static TextStyle body({
    double fontSize = 14,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return style(
      size: fontSize,
      fontWeight: bodyWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Caption / secondary text style.
  static TextStyle caption({
    double fontSize = 12,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return style(
      size: fontSize,
      fontWeight: captionWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ── Full TextTheme for ThemeData ─────────────────────────────────────

  static TextTheme get textTheme {
    final family = fontFamily;
    final fallback = fontFamilyFallback;

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: heroWeight,
      ),
      displayMedium: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: heroWeight,
      ),
      headlineLarge: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: titleWeight,
      ),
      headlineMedium: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: titleWeight,
      ),
      titleLarge: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: titleWeight,
      ),
      titleMedium: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: labelWeight,
      ),
      titleSmall: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: labelWeight,
      ),
      bodyLarge: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: bodyWeight,
      ),
      bodyMedium: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: bodyWeight,
      ),
      bodySmall: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: captionWeight,
      ),
      labelLarge: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: labelWeight,
      ),
      labelMedium: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: captionWeight,
      ),
      labelSmall: TextStyle(
        fontFamily: family,
        fontFamilyFallback: fallback,
        fontWeight: captionWeight,
      ),
    );
  }
}
