import 'package:flutter/material.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';

/// Modern design system themes for CalcPro.
class AppTheme {
  AppTheme._();

  /// Dark Theme (Default)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryAccent,
        secondary: AppColors.darkEqualsButton,
        surface: AppColors.darkDisplaySurface,
        error: AppColors.darkError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: AppColors.darkTextSecondary),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkDisplaySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.roundedMedium,
          side: const BorderSide(color: AppColors.darkCardBorder, width: 1),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.darkDisplaySurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.roundedMedium,
          side: const BorderSide(color: AppColors.darkCardBorder, width: 1),
        ),
      ),
      dividerColor: AppColors.darkCardBorder,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkDisplaySurface,
        contentTextStyle: const TextStyle(color: AppColors.darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.roundedSmall,
          side: const BorderSide(color: AppColors.darkCardBorder),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimaryAccent,
        secondary: AppColors.lightEqualsButton,
        surface: AppColors.lightDisplaySurface,
        error: AppColors.lightError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: AppColors.lightTextSecondary),
      ),
      cardTheme: CardTheme(
        color: AppColors.lightDisplaySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.roundedMedium,
          side: const BorderSide(color: AppColors.lightCardBorder, width: 1),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.lightDisplaySurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.roundedMedium,
          side: const BorderSide(color: AppColors.lightCardBorder, width: 1),
        ),
      ),
      dividerColor: AppColors.lightCardBorder,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightDisplaySurface,
        contentTextStyle: const TextStyle(color: AppColors.lightTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.roundedSmall,
          side: const BorderSide(color: AppColors.lightCardBorder),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
