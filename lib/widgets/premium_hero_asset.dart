import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/design_system.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  PremiumHeroAsset
//
//  The 3D-styled golden FlickTV Premium VIP Emblem.  Built entirely from
//  native Flutter painting primitives — no assets required.  The widget is
//  intentionally stateless; animation transforms are applied by the parent.
// ─────────────────────────────────────────────────────────────────────────────
class PremiumHeroAsset extends StatelessWidget {
  const PremiumHeroAsset({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -6.0 * (math.pi / 180), // −6° tilt
      child: SizedBox(
        width: 260,
        height: 160,
        child: CustomPaint(
          painter: const _TicketPainter(),
          child: _buildOverlayContent(),
        ),
      ),
    );
  }

  Widget _buildOverlayContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: logo mark + VIP pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FlickTV icon mark
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: FlickColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'F',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              // VIP pill badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [FlickColors.goldDark, FlickColors.gold, FlickColors.goldLight],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'V I P',
                  style: TextStyle(
                    color: Color(0xFF3A2800),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Main label
          const Text(
            'PREMIUM',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: FlickColors.gold,
              letterSpacing: 4.0,
              shadows: [
                Shadow(color: FlickColors.goldDark, offset: Offset(0, 2), blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'MEMBERSHIP PASS',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: FlickColors.silver,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _TicketPainter
//
//  Draws the layered 3D "ticket" card with a punch-hole divider, gold border,
//  gradient fill, and a subtle shadow stack to simulate depth.
// ─────────────────────────────────────────────────────────────────────────────
class _TicketPainter extends CustomPainter {
  const _TicketPainter();

  static const double _radius = 16.0;
  static const double _notchRadius = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Layer 3 shadow (deepest) ──────────────────────────────────────────
    _drawCardLayer(canvas, w, h, offset: 8, opacity: 0.45, scale: 0.96,
        color1: const Color(0xFF6B4A00), color2: const Color(0xFF2A1800));

    // ── Layer 2 shadow (mid) ──────────────────────────────────────────────
    _drawCardLayer(canvas, w, h, offset: 4, opacity: 0.65, scale: 0.98,
        color1: const Color(0xFF8B6100), color2: const Color(0xFF3D2400));

    // ── Layer 1 (main card) ───────────────────────────────────────────────
    _drawMainCard(canvas, w, h);

    // ── Gold shimmer border ───────────────────────────────────────────────
    _drawGoldBorder(canvas, w, h);

    // ── Punch-hole divider ────────────────────────────────────────────────
    _drawPunchHoles(canvas, w, h);

    // ── Dashed separator line ─────────────────────────────────────────────
    _drawDashedLine(canvas, w, h);
  }

  void _drawCardLayer(
    Canvas canvas,
    double w,
    double h, {
    required double offset,
    required double opacity,
    required double scale,
    required Color color1,
    required Color color2,
  }) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color1.withValues(alpha: opacity), color2.withValues(alpha: opacity)],
      ).createShader(Rect.fromLTWH(0, offset, w * scale, h * scale));

    final path = _buildTicketPath(w * scale, h * scale);
    canvas.save();
    canvas.translate((w * (1 - scale)) / 2, offset);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _drawMainCard(Canvas canvas, double w, double h) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2A1F00),
          Color(0xFF1A1200),
          Color(0xFF0F0A00),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.drawPath(_buildTicketPath(w, h), paint);

    // Subtle inner highlight
    final highlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
        colors: [
          FlickColors.gold.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.drawPath(_buildTicketPath(w, h), highlight);
  }

  void _drawGoldBorder(Canvas canvas, double w, double h) {
    final borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          FlickColors.goldDark,
          FlickColors.gold,
          FlickColors.goldLight,
          FlickColors.gold,
          FlickColors.goldDark,
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(_buildTicketPath(w, h), borderPaint);
  }

  void _drawPunchHoles(Canvas canvas, double w, double h) {
    final holePaint = Paint()
      ..color = const Color(0xFF0A0A0A)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Left notch
    canvas.drawCircle(Offset(-1, h * 0.72), _notchRadius, shadowPaint);
    canvas.drawCircle(Offset(-1, h * 0.72), _notchRadius, holePaint);

    // Right notch
    canvas.drawCircle(Offset(w + 1, h * 0.72), _notchRadius, shadowPaint);
    canvas.drawCircle(Offset(w + 1, h * 0.72), _notchRadius, holePaint);
  }

  void _drawDashedLine(Canvas canvas, double w, double h) {
    final dashY = h * 0.72;
    final dashPaint = Paint()
      ..color = FlickColors.gold.withValues(alpha: 0.25)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashGap = 5.0;
    double x = _notchRadius;
    while (x < w - _notchRadius) {
      canvas.drawLine(Offset(x, dashY), Offset(x + dashWidth, dashY), dashPaint);
      x += dashWidth + dashGap;
    }
  }

  Path _buildTicketPath(double w, double h) {
    const r = _radius;
    const nr = _notchRadius;
    final notchY = h * 0.72;

    return Path()
      ..moveTo(r, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: const Radius.circular(r))
      ..lineTo(w, notchY - nr)
      ..arcToPoint(Offset(w - nr, notchY), radius: Radius.circular(nr), clockwise: false)
      ..arcToPoint(Offset(w, notchY + nr), radius: Radius.circular(nr), clockwise: false)
      ..lineTo(w, h - r)
      ..arcToPoint(Offset(w - r, h), radius: const Radius.circular(r))
      ..lineTo(r, h)
      ..arcToPoint(Offset(0, h - r), radius: const Radius.circular(r))
      ..lineTo(0, notchY + nr)
      ..arcToPoint(Offset(nr, notchY), radius: Radius.circular(nr), clockwise: false)
      ..arcToPoint(Offset(0, notchY - nr), radius: Radius.circular(nr), clockwise: false)
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: const Radius.circular(r))
      ..close();
  }

  @override
  bool shouldRepaint(_TicketPainter old) => false;
}
