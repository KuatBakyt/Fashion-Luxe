import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: const Color(0xFFFCFCFC),

      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFA8715A),
        brightness: Brightness.light,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFCFCFC),
        foregroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.2,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.4,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(),
          minimumSize: const Size.fromHeight(52),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E5E5),
        thickness: 1,
      ),
    );
  }
}