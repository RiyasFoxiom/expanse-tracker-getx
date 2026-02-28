import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // ── Color Palette ────────────────────────────────────────────────────
  // Light
  static const _lightBg = Color(0xFFF8F9FD);
  static const _lightCard = Colors.white;
  static const _lightSurface = Color(0xFFF1F3F8);

  // Dark – rich navy slate
  static const _darkBg = Color(0xFF0F172A);
  static const _darkCard = Color(0xFF1E293B);
  static const _darkSurface = Color(0xFF1A2332);

  // Primary – refined deep purple
  static const _primaryLight = Color(0xFF6C3FEE);
  static const _primaryDark = Color(0xFF9B7BFF);

  // ─── Light Theme ────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBg,
    cardColor: _lightCard,
    primaryColor: _primaryLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryLight,
      brightness: Brightness.light,
      surface: _lightSurface,
      primary: _primaryLight,
      primaryContainer: const Color(0xFFEDE7FE),
      secondaryContainer: const Color(0xFFF0F1F5),
      onSurface: const Color(0xFF1A1C2E),
    ),
    fontFamily: 'SF Pro Display',
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightCard,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1C2E),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Color(0xFF1A1C2E)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF1A1C2E),
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF1A1C2E),
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF1A1C2E),
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF1A1C2E),
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Color(0xFF2D3142)),
      bodyMedium: TextStyle(color: Color(0xFF4A4E69)),
      bodySmall: TextStyle(color: Color(0xFF9A9CB8)),
    ),
    dividerColor: const Color(0xFFE8EAF0),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryLight,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _primaryLight,
        disabledBackgroundColor: _primaryLight.withValues(alpha: 0.4),
        disabledForegroundColor: Colors.white70,
        elevation: 0,
        shadowColor: _primaryLight.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryLight,
        side: BorderSide(
          color: _primaryLight.withValues(alpha: 0.3),
          width: 1.5,
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurface,
      hintStyle: TextStyle(
        color: const Color(0xFF9A9CB8).withValues(alpha: 0.7),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _primaryLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1A1C2E),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
  );

  // ─── Dark Theme ─────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBg,
    cardColor: _darkCard,
    primaryColor: _primaryDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryDark,
      brightness: Brightness.dark,
      surface: _darkSurface,
      primary: _primaryDark,
      primaryContainer: const Color(0xFF2D2157),
      secondaryContainer: const Color(0xFF283040),
      onSurface: const Color(0xFFE2E8F0),
    ),
    fontFamily: 'SF Pro Display',
    appBarTheme: AppBarTheme(
      backgroundColor: _darkCard,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: const TextStyle(
        color: Color(0xFFE2E8F0),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: const IconThemeData(color: Color(0xFFE2E8F0)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFFE2E8F0),
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFE2E8F0),
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: Color(0xFFE2E8F0),
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: Color(0xFFE2E8F0),
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Color(0xFFCBD5E1)),
      bodyMedium: TextStyle(color: Color(0xFF94A3B8)),
      bodySmall: TextStyle(color: Color(0xFF64748B)),
    ),
    dividerColor: const Color(0xFF334155),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryDark,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _primaryDark,
        disabledBackgroundColor: _primaryDark.withValues(alpha: 0.3),
        disabledForegroundColor: Colors.white38,
        elevation: 0,
        shadowColor: _primaryDark.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryDark,
        side: BorderSide(
          color: _primaryDark.withValues(alpha: 0.3),
          width: 1.5,
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      hintStyle: TextStyle(
        color: const Color(0xFF64748B).withValues(alpha: 0.7),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _primaryDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF334155),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
  );
}
