import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF080E14);
  static const Color backgroundCard = Color(0xFF0D1A10);
  static const Color surfaceCard = Color(0xFF0F2318);
  static const Color surfaceElevated = Color(0xFF132B1A);

  // ── Primary Greens ────────────────────────────────────────────────────────
  static const Color primaryGreen = Color(0xFF00C853);
  static const Color primaryGreenDark = Color(0xFF00A040);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color emeraldGreen = Color(0xFF00695C);
  static const Color glowGreen = Color(0xFF00FF6A);

  // ── Accent Gold ───────────────────────────────────────────────────────────
  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentGoldDark = Color(0xFFFFA000);

  // ── Danger Red ────────────────────────────────────────────────────────────
  static const Color dangerRed = Color(0xFFFF1744);
  static const Color dangerRedDark = Color(0xFFB71C1C);
  static const Color imposterBackground = Color(0xFF120008);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textMuted = Color(0xFF546E7A);
  static const Color textGold = accentGold;

  // ── Glass / Border ────────────────────────────────────────────────────────
  static const Color glassBorder = Color(0x2200C853);
  static const Color glassBackground = Color(0x1200C853);
  static const Color cardBorder = Color(0x3300C853);

  // ── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B5E20), Color(0xFF080E14)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1A0F), Color(0xFF080E14)],
  );

  static const LinearGradient imposterGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A0008), Color(0xFF080008), Color(0xFF000000)],
  );

  static const LinearGradient normalRevealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A2E10), Color(0xFF051A08)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
  );

  static const LinearGradient resultCaughtGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A2E10), Color(0xFF051208)],
  );

  static const LinearGradient resultWinGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A0008), Color(0xFF080004)],
  );

  // ── Shadows / Glows ───────────────────────────────────────────────────────
  static List<BoxShadow> greenGlow = [
    BoxShadow(
      color: primaryGreen.withValues(alpha: 0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> goldGlow = [
    BoxShadow(
      color: accentGold.withValues(alpha: 0.4),
      blurRadius: 24,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> redGlow = [
    BoxShadow(
      color: dangerRed.withValues(alpha: 0.5),
      blurRadius: 30,
      spreadRadius: 4,
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
