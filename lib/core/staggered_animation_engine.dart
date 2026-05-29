import 'package:flutter/animation.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  StaggeredAnimationEngine
//
//  Wraps a single master AnimationController and exposes typed Animation<T>
//  values for every phase / element.  All intervals are defined in one place
//  so timing adjustments are trivially audited.
// ─────────────────────────────────────────────────────────────────────────────
class StaggeredAnimationEngine {
  StaggeredAnimationEngine({required AnimationController controller})
      : _ctrl = controller {
    _build();
  }

  final AnimationController _ctrl;

  // ── Phase 1: Hero ticket  [0.00 → 0.35] ──────────────────────────────────
  late final Animation<double> heroScale;
  late final Animation<double> heroOpacity;
  late final Animation<Offset> heroSlide;

  // ── Phase 2a: Brand text  [0.25 → 0.55] ─────────────────────────────────
  late final Animation<double> textOpacity;
  late final Animation<Offset> textSlide;

  // ── Phase 2b: Confetti   [0.25 → 0.70] ──────────────────────────────────
  late final Animation<double> confettiOpacity;

  // ── Phase 3: Value cards  [0.45 → 0.85] ─────────────────────────────────
  late final Animation<double> card1Opacity;
  late final Animation<Offset> card1Slide;
  late final Animation<double> card2Opacity;
  late final Animation<Offset> card2Slide;
  late final Animation<double> card3Opacity;
  late final Animation<Offset> card3Slide;

  // ── Phase 4: Footer + settings icon  [0.70 → 1.00] ──────────────────────
  late final Animation<double> footerOpacity;
  late final Animation<Offset> footerSlide;
  late final Animation<double> settingsOpacity;
  late final Animation<Offset> settingsSlide;

  void _build() {
    // ── Hero asset ────────────────────────────────────────────────────────
    final heroInterval = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.35, curve: Curves.elasticOut),
    );
    heroScale = Tween<double>(begin: 0.0, end: 1.0).animate(heroInterval);
    heroOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOut),
      ),
    );
    heroSlide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.35, curve: Curves.elasticOut),
      ),
    );

    // ── Brand text ────────────────────────────────────────────────────────
    textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
      ),
    );
    textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.25, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    // ── Confetti ──────────────────────────────────────────────────────────
    confettiOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.25, 0.45, curve: Curves.easeIn),
      ),
    );

    // ── Card 1 ────────────────────────────────────────────────────────────
    card1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.45, 0.65, curve: Curves.fastOutSlowIn),
      ),
    );
    card1Slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.45, 0.65, curve: Curves.fastOutSlowIn),
      ),
    );

    // ── Card 2 (120 ms stagger ≈ 0.06 on 2 s controller) ─────────────────
    card2Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.51, 0.71, curve: Curves.fastOutSlowIn),
      ),
    );
    card2Slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.51, 0.71, curve: Curves.fastOutSlowIn),
      ),
    );

    // ── Card 3 (240 ms stagger ≈ 0.12) ───────────────────────────────────
    card3Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.57, 0.85, curve: Curves.fastOutSlowIn),
      ),
    );
    card3Slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.57, 0.85, curve: Curves.fastOutSlowIn),
      ),
    );

    // ── Footer / buttons ──────────────────────────────────────────────────
    footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.70, 1.00, curve: Curves.easeOut),
      ),
    );
    footerSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.70, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    // ── Settings icon ─────────────────────────────────────────────────────
    settingsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.75, 1.00, curve: Curves.easeOut),
      ),
    );
    settingsSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.75, 1.00, curve: Curves.easeOutCubic),
      ),
    );
  }
}
