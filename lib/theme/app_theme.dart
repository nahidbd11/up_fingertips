import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF1565C0);
  static const primaryLight = Color(0xFF42A5F5);
  static const primaryDark = Color(0xFF0D47A1);
  static const secondary = Color(0xFF42A5F5);
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const success = Color(0xFF2E7D32);
  static const successLight = Color(0xFFE8F5E9);
  static const warning = Color(0xFFE65100);
  static const warningLight = Color(0xFFFFF3E0);
  static const error = Color(0xFFC62828);
  static const errorLight = Color(0xFFFFEBEE);
  static const purple = Color(0xFF6A1B9A);
  static const purpleLight = Color(0xFFF3E5F5);
  static const grey = Color(0xFF607D8B);
  static const greyLight = Color(0xFFECEFF1);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF4A5568);
  static const textHint = Color(0xFF9E9E9E);
  static const divider = Color(0xFFE2E8F0);
  static const cardShadow = Color(0x0A000000);

  static const statusUpcoming = Color(0xFF1565C0);
  static const statusUpcomingBg = Color(0xFFE3F2FD);
  static const statusOngoing = Color(0xFFE65100);
  static const statusOngoingBg = Color(0xFFFFF3E0);
  static const statusAwaiting = Color(0xFFF57F17);
  static const statusAwaitingBg = Color(0xFFFFFDE7);
  static const statusCompleted = Color(0xFF2E7D32);
  static const statusCompletedBg = Color(0xFFE8F5E9);
  static const statusRevision = Color(0xFF6A1B9A);
  static const statusRevisionBg = Color(0xFFF3E5F5);
  static const statusDraft = Color(0xFF607D8B);
  static const statusDraftBg = Color(0xFFECEFF1);
}

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: _appBarTheme(),
      cardTheme: _cardTheme(),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      chipTheme: _chipTheme(),
      bottomNavigationBarTheme: _bottomNavTheme(),
      drawerTheme: _drawerTheme(),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),
    );
  }

  static TextTheme _buildTextTheme() {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
      displayMedium: base.displayMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
      headlineLarge: base.headlineLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
      headlineMedium: base.headlineMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      headlineSmall: base.headlineSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      titleLarge: base.titleLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 18),
      titleMedium: base.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall: base.titleSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge: base.bodyLarge?.copyWith(color: AppColors.textPrimary, fontSize: 16),
      bodyMedium: base.bodyMedium?.copyWith(color: AppColors.textSecondary, fontSize: 14),
      bodySmall: base.bodySmall?.copyWith(color: AppColors.textHint, fontSize: 12),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
      labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
    );
  }

  static AppBarTheme _appBarTheme() => const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 24),
      );

  static CardThemeData _cardTheme() => CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  static InputDecorationTheme _inputDecorationTheme() => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      );

  static ChipThemeData _chipTheme() => ChipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );

  static BottomNavigationBarThemeData _bottomNavTheme() => const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      );

  static DrawerThemeData _drawerTheme() => const DrawerThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
      );
}
