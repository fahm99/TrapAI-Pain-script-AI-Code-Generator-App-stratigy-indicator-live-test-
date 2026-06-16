import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get _interBase => GoogleFonts.inter(color: AppColors.textMain);

  // Headlines
  static TextStyle get headlineLg => _interBase.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: -0.02,
      );

  static TextStyle get headlineMd => _interBase.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: -0.01,
      );

  static TextStyle get headlineSm => _interBase.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  // Body
  static TextStyle get bodyLg => _interBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );

  static TextStyle get bodyMd => _interBase.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySm => _interBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // Code
  static TextStyle get codeBlock => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 20 / 13,
        color: AppColors.textMain,
      );

  // Labels
  static TextStyle get labelCaps => _interBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.05,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSm => _interBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelText => _interBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.textSecondary,
      );

  // Button
  static TextStyle get buttonLg => _interBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      );

  static TextStyle get buttonMd => _interBase.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      );

  static ThemeData get textTheme {
    final baseTheme = GoogleFonts.interTextTheme();
    return baseTheme.copyWith(
      headlineLarge: headlineLg,
      headlineMedium: headlineMd,
      headlineSmall: headlineSm,
      bodyLarge: bodyLg,
      bodyMedium: bodyMd,
      bodySmall: bodySm,
      labelLarge: labelCaps,
      labelMedium: labelSm,
      labelSmall: labelText,
    );
  }
}
