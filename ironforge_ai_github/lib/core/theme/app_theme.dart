// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color primary = Color(0xFF00E5A8);
  static const Color secondary = Color(0xFF00BFFF);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color card = Color(0xFF161616);
  static const Color border = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF707070);
  static const Color error = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFD93D);
  static const Color success = Color(0xFF6BCB77);
  static const Color info = Color(0xFF00BFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E5A8), Color(0xFF00BFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0A0A), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF161616)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Muscle group colors
  static const Color chest = Color(0xFFFF6B6B);
  static const Color back = Color(0xFF4ECDC4);
  static const Color shoulders = Color(0xFF45B7D1);
  static const Color biceps = Color(0xFF96CEB4);
  static const Color triceps = Color(0xFFFFEAA7);
  static const Color forearms = Color(0xFFDDA0DD);
  static const Color abs = Color(0xFFFF9FF3);
  static const Color legs = Color(0xFF6C5CE7);
  static const Color calves = Color(0xFF00B894);
  static const Color glutes = Color(0xFFE17055);
  static const Color fullBody = Color(0xFF00E5A8);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
        surfaceVariant: AppColors.surfaceVariant,
        outline: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary.withOpacity(0.2),
        side: const BorderSide(color: AppColors.border, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 0.5, space: 1),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 24),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary, linearTrackColor: AppColors.border,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.border,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
        trackHeight: 4,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return AppColors.primary;
          return AppColors.textTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return AppColors.primary.withOpacity(0.4);
          return AppColors.surfaceVariant;
        }),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        indicatorColor: AppColors.primary,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.8),
        unselectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceVariant,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.5),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.5),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.5),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.5),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.15),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary, letterSpacing: 0.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, letterSpacing: 0.25),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary, letterSpacing: 0.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.1),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 0.5),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary, letterSpacing: 0.5),
    );
  }
}
