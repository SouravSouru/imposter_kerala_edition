import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display / Hero ────────────────────────────────────────────────────────
  static TextStyle get heroTitle => GoogleFonts.exo2(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 6,
        shadows: [
          Shadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.6),
            blurRadius: 20,
          ),
        ],
      );

  static TextStyle get displayLarge => GoogleFonts.exo2(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      );

  static TextStyle get displayMedium => GoogleFonts.exo2(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 1.5,
      );

  // ── Headlines ─────────────────────────────────────────────────────────────
  static TextStyle get headlineLarge => GoogleFonts.exo2(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 1,
      );

  static TextStyle get headlineMedium => GoogleFonts.exo2(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get headlineSmall => GoogleFonts.exo2(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // ── Body ──────────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.exo2(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyMedium => GoogleFonts.exo2(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.exo2(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  // ── Labels ────────────────────────────────────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.exo2(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 1.2,
      );

  static TextStyle get labelMedium => GoogleFonts.exo2(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      );

  // ── Specialised ───────────────────────────────────────────────────────────
  static TextStyle get goldLabel => GoogleFonts.exo2(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.accentGold,
        letterSpacing: 2,
      );

  static TextStyle get categoryTag => GoogleFonts.exo2(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryGreen,
        letterSpacing: 1.5,
      );

  static TextStyle get secretWord => GoogleFonts.exo2(
        fontSize: 38,
        fontWeight: FontWeight.w800,
        color: AppColors.accentGold,
        letterSpacing: 2,
        shadows: [
          Shadow(
            color: AppColors.accentGold.withValues(alpha: 0.5),
            blurRadius: 16,
          ),
        ],
      );

  static TextStyle get imposterTitle => GoogleFonts.exo2(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.dangerRed,
        letterSpacing: 3,
        shadows: [
          Shadow(
            color: AppColors.dangerRed.withValues(alpha: 0.7),
            blurRadius: 24,
          ),
        ],
      );

  static TextStyle get timer => GoogleFonts.exo2(
        fontSize: 72,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 4,
      );

  static TextStyle get playerName => GoogleFonts.exo2(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 1,
      );

  // ── Malayalam subtitle (uses google_fonts noto sans)  ────────────────────
  static TextStyle get malayalamSubtitle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle get malayalamHeadline => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get malayalamFunny => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );
}
