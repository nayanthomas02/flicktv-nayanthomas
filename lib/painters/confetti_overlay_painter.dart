import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import '../core/design_system.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ConfettiOverlayPainter
//
//  High-performance math-driven confetti.  Each particle is described by a
//  pure value struct; no heap allocations happen during paint().
//  The `progress` field (0.0 → 1.0) is driven by the master animation
//  controller so the whole particle system stays in lock-step with the
//  staggered engine.
// ─────────────────────────────────────────────────────────────────────────────

class _Particle {
  const _Particle({
    required this.x,       // normalised 0..1 horizontal start
    required this.speed,   // normalised fall speed
    required this.size,    // pixel side length
    required this.angle,   // initial rotation in radians
    required this.spin,    // radians added per progress unit
    required this.colorIdx,
    required this.shape,   // 0=rect, 1=circle, 2=ribbon
    required this.wobble,  // horizontal oscillation amplitude (normalised)
    required this.phase,   // oscillation phase offset
    required this.startAt, // progress value at which this particle spawns
  });

  final double x;
  final double speed;
  final double size;
  final double angle;
  final double spin;
  final int colorIdx;
  final int shape;
  final double wobble;
  final double phase;
  final double startAt;
}

const _colors = [
  FlickColors.confettiRed,
  FlickColors.confettiGold,
  FlickColors.confettiWhite,
  FlickColors.confettiSilver,
  FlickColors.confettiRose,
];

List<_Particle> _buildParticles(int count, math.Random rng) {
  return List.generate(count, (i) {
    return _Particle(
      x: rng.nextDouble(),
      speed: 0.25 + rng.nextDouble() * 0.55,
      size: 4.0 + rng.nextDouble() * 8.0,
      angle: rng.nextDouble() * math.pi * 2,
      spin: (rng.nextDouble() - 0.5) * math.pi * 4,
      colorIdx: rng.nextInt(_colors.length),
      shape: rng.nextInt(3),
      wobble: 0.02 + rng.nextDouble() * 0.04,
      phase: rng.nextDouble() * math.pi * 2,
      startAt: rng.nextDouble() * 0.35, // stagger spawning
    );
  });
}

class ConfettiOverlayPainter extends CustomPainter {
  ConfettiOverlayPainter({
    required this.progress,
    required this.opacity,
  });

  final double progress; // 0.0 → 1.0 driven by master controller
  final double opacity;  // fade governed by confettiOpacity animation

  static final _particles = _buildParticles(80, math.Random(42));

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0.0) return;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in _particles) {
      // Each particle only exists after its own startAt threshold
      if (progress < p.startAt) continue;
      final localT = ((progress - p.startAt) / (1.0 - p.startAt)).clamp(0.0, 1.0);
      final y = localT * p.speed * (size.height * 1.15);
      if (y > size.height + p.size) continue;

      final wobbleX = math.sin(localT * math.pi * 4 + p.phase) * p.wobble * size.width;
      final x = p.x * size.width + wobbleX;
      final rotation = p.angle + localT * p.spin;

      // Fade out near bottom
      final bottomFade = (1.0 - (y / (size.height * 1.1)).clamp(0.0, 1.0));
      final alpha = (opacity * bottomFade).clamp(0.0, 1.0);
      paint.color = _colors[p.colorIdx].withValues(alpha: alpha);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      switch (p.shape) {
        case 0: // rectangle
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
            paint,
          );
        case 1: // circle
          canvas.drawCircle(Offset.zero, p.size * 0.4, paint);
        case _: // ribbon / thin strip
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: p.size * 1.4, height: p.size * 0.25),
            paint,
          );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiOverlayPainter old) =>
      old.progress != progress || old.opacity != opacity;
}
