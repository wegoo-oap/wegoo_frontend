import 'package:flutter/material.dart';

class AppTypography {
  // â€” update font family once you share your design â€”
  static const String fontFamily = 'Inter';

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      letterSpacing: -2,
    ),
    displayMedium: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
    ),
    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -1,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
    ),
  );
}
