import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Color Palette
// ─────────────────────────────────────────────
abstract final class FlickColors {
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF1A1A1A);
  static const surfaceElevated = Color(0xFF222222);
  static const accent = Color(0xFFE50914); // Cinematic Red
  static const gold = Color(0xFFFFD700);
  static const goldDark = Color(0xFFB8860B);
  static const goldLight = Color(0xFFFFF1A0);
  static const silver = Color(0xFFC0C0C0);
  static const white = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8A8A8A);
  static const textMuted = Color(0xFF555555);
  static const borderSubtle = Color(0xFF2A2A2A);

  // Confetti palette
  static const confettiRed = Color(0xFFE50914);
  static const confettiGold = Color(0xFFFFD700);
  static const confettiWhite = Color(0xFFFFFFFF);
  static const confettiSilver = Color(0xFFC0C0C0);
  static const confettiRose = Color(0xFFFF6B6B);
}

// ─────────────────────────────────────────────
//  Spacing / Dimensions
// ─────────────────────────────────────────────
abstract final class FlickSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
  static const cardRadius = 20.0;
  static const buttonRadius = 16.0;
  static const badgeRadius = 14.0;
}

// ─────────────────────────────────────────────
//  Typography
// ─────────────────────────────────────────────
abstract final class FlickTypography {
  static const premiumTracking = 5.0;
  static const labelTracking = 2.0;

  static const TextStyle brandLabel = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w300,
    letterSpacing: labelTracking,
    color: FlickColors.silver,
  );

  static const TextStyle premiumTitle = TextStyle(
    fontSize: 42.0,
    fontWeight: FontWeight.w900,
    letterSpacing: premiumTracking,
    color: FlickColors.white,
    height: 1.0,
  );

  static const TextStyle cardHeadline = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: FlickColors.textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle cardBody = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: FlickColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: FlickColors.white,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: FlickColors.silver,
  );

  static const TextStyle badgeLabel = TextStyle(
    fontSize: 9.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.6,
    color: FlickColors.white,
  );
}
