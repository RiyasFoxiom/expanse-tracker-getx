import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F6FA),
    cardColor: Colors.white,
    primaryColor: Colors.deepPurple,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
      surface: const Color(0xFFF5F6FA),
      primaryContainer: Colors.deepPurple.shade50,
      secondaryContainer: Colors.grey.shade100,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        disabledBackgroundColor: Colors.deepPurple.shade200,
        disabledForegroundColor: Colors.white70,
        elevation: 6,
        shadowColor: Colors.deepPurple.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        side: const BorderSide(color: Colors.deepPurple, width: 2.5),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        overlayColor: Colors.deepPurple.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
      ),
    ),
  );

  /// Dark Theme
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    cardColor: const Color(0xFF1E293B),
    primaryColor: Colors.deepPurpleAccent.shade100,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
      surface: const Color(0xFF0F172A),
      primaryContainer: Color.fromARGB(255, 47, 67, 112),
      secondaryContainer: Colors.grey.shade800,
      onSurface: Colors.white70,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo.shade900,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple.shade300,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple.shade300,
        elevation: 6,
        shadowColor: Colors.deepPurple.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.deepPurple.shade200,
        side: BorderSide(color: Colors.deepPurple.shade200, width: 2.5),
        backgroundColor: Colors.transparent,
        overlayColor: Colors.deepPurple.shade200.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
      ),
    ),
  );
  // Optional: Define custom text themes if AppText uses Theme.textTheme
  static TextTheme get lightTextTheme => const TextTheme();
  static TextTheme get darkTextTheme => const TextTheme();
}
