import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/design_system.dart';
import '../core/staggered_animation_engine.dart';
import '../painters/dot_grid_background_painter.dart';
import '../painters/confetti_overlay_painter.dart';
import '../widgets/premium_hero_asset.dart';
import '../widgets/value_feature_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  OnboardingScreen
//
//  Single-screen premium OTT onboarding experience.
//  Orchestrates a StaggeredAnimationEngine driven by a single 2-second
//  AnimationController.  Each phase is isolated behind a RepaintBoundary so
//  static portions of the tree are never re-rasterised.
// ─────────────────────────────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _masterCtrl;
  late final StaggeredAnimationEngine _engine;

  // Primary button press state
  bool _primaryButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _engine = StaggeredAnimationEngine(controller: _masterCtrl);

    // Auto-start after a short boot-delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _masterCtrl.forward();
    });
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    super.dispose();
  }

  // ── Button touch feedback ─────────────────────────────────────────────────
  void _onPrimaryTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    setState(() => _primaryButtonPressed = true);
  }

  void _onPrimaryTapUp(TapUpDetails _) {
    setState(() => _primaryButtonPressed = false);
  }

  void _onPrimaryTapCancel() {
    setState(() => _primaryButtonPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final safeTop = mq.padding.top;
    final safeBottom = mq.padding.bottom;

    return Scaffold(
      backgroundColor: FlickColors.background,
      body: AnimatedBuilder(
        animation: _masterCtrl,
        builder: (context, _) {
          return Stack(
            children: [
              // ── Static background layer (rasterised once) ─────────────
              RepaintBoundary(child: _buildBackground()),

              // ── Confetti overlay ──────────────────────────────────────
              RepaintBoundary(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: ConfettiOverlayPainter(
                      progress: _masterCtrl.value,
                      opacity: _engine.confettiOpacity.value,
                    ),
                    size: Size(mq.size.width, mq.size.height),
                  ),
                ),
              ),

              // ── Main content column ───────────────────────────────────
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: FlickSpacing.lg,
                            ),
                            child: Column(
                              children: [
                                // ── Settings icon (top-right) ─────────────
                                _buildSettingsRow(safeTop),
                                const SizedBox(height: FlickSpacing.xl),

                                // ── Hero asset (Phase 1) ──────────────────
                                RepaintBoundary(child: _buildHeroPhase()),

                                const SizedBox(height: FlickSpacing.xl),

                                // ── Brand text (Phase 2a) ─────────────────
                                RepaintBoundary(child: _buildBrandText()),

                                const SizedBox(height: FlickSpacing.xl),

                                // ── Value cards (Phase 3) ─────────────────
                                RepaintBoundary(child: _buildValueCards()),

                                const Spacer(),

                                // ── Footer buttons (Phase 4) ──────────────
                                RepaintBoundary(
                                  child: _buildFooter(safeBottom),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Background ────────────────────────────────────────────────────────────
  Widget _buildBackground() {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF130F00), Color(0xFF0D0D0D), Color(0xFF0A0A0A)],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
        ),
        // Dot grid texture (top-weighted)
        const Positioned.fill(
          child: CustomPaint(painter: DotGridBackgroundPainter()),
        ),
        // Subtle radial glow centre
        Positioned(
          top: -60,
          left: 0,
          right: 0,
          child: Container(
            height: 360,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 0.8,
                colors: [Color(0x18B8860B), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Settings row ──────────────────────────────────────────────────────────
  Widget _buildSettingsRow(double safeTop) {
    return FadeTransition(
      opacity: _engine.settingsOpacity,
      child: SlideTransition(
        position: _engine.settingsSlide,
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => HapticFeedback.selectionClick(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: FlickColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: FlickColors.borderSubtle),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: FlickColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Phase 1: Hero asset ───────────────────────────────────────────────────
  Widget _buildHeroPhase() {
    return FadeTransition(
      opacity: _engine.heroOpacity,
      child: SlideTransition(
        position: _engine.heroSlide,
        child: ScaleTransition(
          scale: _engine.heroScale,
          child: const PremiumHeroAsset(),
        ),
      ),
    );
  }

  // ── Phase 2a: Brand text ──────────────────────────────────────────────────
  Widget _buildBrandText() {
    return FadeTransition(
      opacity: _engine.textOpacity,
      child: SlideTransition(
        position: _engine.textSlide,
        child: Column(
          children: [
            // "flicktv" label
            Text('flicktv', style: FlickTypography.brandLabel),
            const SizedBox(height: 6),
            // "PREMIUM" massive title
            Text('PREMIUM', style: FlickTypography.premiumTitle),
          ],
        ),
      ),
    );
  }

  // ── Phase 3: Value cards ──────────────────────────────────────────────────
  Widget _buildValueCards() {
    return Column(
      children: [
        // Card 1 — Ultra HD Streaming
        FadeTransition(
          opacity: _engine.card1Opacity,
          child: SlideTransition(
            position: _engine.card1Slide,
            child: const ValueFeatureCard(
              icon: Icons.hd_rounded,
              badgeLabel: '4K UHD',
              headline: 'Crystal Clear 4K Ultra HD',
              description: 'Dolby Vision & Atmos across all your devices.',
              badgeColor: FlickColors.accent,
              iconColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: FlickSpacing.sm),

        // Card 2 — Offline Downloads
        FadeTransition(
          opacity: _engine.card2Opacity,
          child: SlideTransition(
            position: _engine.card2Slide,
            child: const ValueFeatureCard(
              icon: Icons.download_done_rounded,
              badgeLabel: 'OFFLINE',
              headline: 'Download & Watch Anywhere',
              description: 'Save titles offline, no Wi-Fi needed.',
              badgeColor: Color(0xFF00C896),
              iconColor: Color(0xFF00C896),
            ),
          ),
        ),
        const SizedBox(height: FlickSpacing.sm),

        // Card 3 — Simultaneous Screens
        FadeTransition(
          opacity: _engine.card3Opacity,
          child: SlideTransition(
            position: _engine.card3Slide,
            child: const ValueFeatureCard(
              icon: Icons.devices_rounded,
              badgeLabel: 'SCREENS',
              headline: 'Up to 4 Screens Simultaneously',
              description: 'Share the experience with everyone at home.',
              badgeColor: FlickColors.gold,
              iconColor: FlickColors.gold,
            ),
          ),
        ),
        const SizedBox(height: FlickSpacing.sm),
      ],
    );
  }

  // ── Phase 4: Footer ───────────────────────────────────────────────────────
  Widget _buildFooter(double safeBottom) {
    return FadeTransition(
      opacity: _engine.footerOpacity,
      child: SlideTransition(
        position: _engine.footerSlide,
        child: Padding(
          padding: EdgeInsets.only(bottom: safeBottom + FlickSpacing.md),
          child: Column(
            children: [
              // Primary CTA button
              _buildPrimaryButton(),
              const SizedBox(height: FlickSpacing.md),
              // Fine print
              Text(
                'Cancel anytime • Secure payment',
                style: FlickTypography.cardBody.copyWith(
                  fontSize: 11.5,
                  color: FlickColors.textMuted,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Primary button with Matrix4 press feedback ────────────────────────────
  Widget _buildPrimaryButton() {
    return GestureDetector(
      onTapDown: _onPrimaryTapDown,
      onTapUp: _onPrimaryTapUp,
      onTapCancel: _onPrimaryTapCancel,
      onTap: () => HapticFeedback.mediumImpact(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        transform: _primaryButtonPressed
            ? (Matrix4.identity()..scaleByDouble(0.96, 0.96, 1.0, 1.0))
            : Matrix4.identity(),
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _primaryButtonPressed
                ? [const Color(0xFFC00810), const Color(0xFF8B0000)]
                : [const Color(0xFFE50914), const Color(0xFFC2000E)],
          ),
          borderRadius: BorderRadius.circular(FlickSpacing.buttonRadius),
          boxShadow: _primaryButtonPressed
              ? []
              : [
                  BoxShadow(
                    color: FlickColors.accent.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: const Center(
          child: Text(
            'Explore Premium Content',
            style: FlickTypography.buttonPrimary,
          ),
        ),
      ),
    );
  }

  // ── Secondary "Redeem Promo Code" button ──────────────────────────────────
  Widget _buildSecondaryButton() {
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: FlickColors.surface,
          borderRadius: BorderRadius.circular(FlickSpacing.buttonRadius),
          border: Border.all(color: FlickColors.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: FlickSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Redeem Promo Code', style: FlickTypography.buttonSecondary),
              const Icon(
                Icons.chevron_right_rounded,
                color: FlickColors.silver,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
