import 'package:flutter/material.dart';

class AppTheme {
  // Brand & Age Colors
  static const Color primaryAmber = Color(0xFFF59E0B);
  static const Color primaryEmerald = Color(0xFF10B981);
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);

  // 3-5 Age Group Gradient (Warm Sunrise)
  static const LinearGradient age3To5Gradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 6-8 Age Group Gradient (Emerald Island)
  static const LinearGradient age6To8Gradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 9-12 Age Group Gradient (Cyber Space)
  static const LinearGradient age9To12Gradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryAmber,
      surface: surfaceWhite,
      onSurface: textDark,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(color: textDark),
    ),
  );
}
