import 'package:flutter/material.dart';
import '../core/design_system.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ValueFeatureCard
//
//  A single premium value-proposition row.  Entirely const-safe; the parent
//  controls opacity/translation via AnimatedBuilder above this widget in the
//  tree so RepaintBoundary correctly isolates it from the animation layer.
// ─────────────────────────────────────────────────────────────────────────────

class ValueFeatureCard extends StatelessWidget {
  const ValueFeatureCard({
    super.key,
    required this.icon,
    required this.badgeLabel,
    required this.headline,
    required this.description,
    this.badgeColor = FlickColors.accent,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final String badgeLabel;
  final String headline;
  final String description;
  final Color badgeColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FlickSpacing.md,
        vertical: FlickSpacing.md,
      ),
      decoration: BoxDecoration(
        color: FlickColors.surface,
        borderRadius: BorderRadius.circular(FlickSpacing.cardRadius),
        border: Border.all(
          color: FlickColors.borderSubtle,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // ── Badge (left element) ────────────────────────────────────────
          _BadgeWidget(
            icon: icon,
            label: badgeLabel,
            badgeColor: badgeColor,
            iconColor: iconColor,
          ),
          const SizedBox(width: FlickSpacing.md),
          // ── Text block (right element) ──────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(headline, style: FlickTypography.cardHeadline),
                const SizedBox(height: 4),
                Text(description, style: FlickTypography.cardBody),
              ],
            ),
          ),
          // ── Trailing chevron indicator ──────────────────────────────────
          const Icon(
            Icons.chevron_right_rounded,
            color: FlickColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _BadgeWidget  – the rounded left icon badge
// ─────────────────────────────────────────────────────────────────────────────
class _BadgeWidget extends StatelessWidget {
  const _BadgeWidget({
    required this.icon,
    required this.label,
    required this.badgeColor,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color badgeColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                badgeColor.withValues(alpha: 0.25),
                badgeColor.withValues(alpha: 0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(FlickSpacing.badgeRadius),
            border: Border.all(
              color: badgeColor.withValues(alpha: 0.40),
              width: 1.0,
            ),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: 5),
        Text(label, style: FlickTypography.badgeLabel),
      ],
    );
  }
}
