import 'package:flutter/rendering.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  DotGridBackgroundPainter
//
//  Draws a fine, dim, geometric grid of microscopic dots on the upper-third of
//  the canvas.  Fully static – intended to sit inside a RepaintBoundary so it
//  is rasterised once and cached.
// ─────────────────────────────────────────────────────────────────────────────
class DotGridBackgroundPainter extends CustomPainter {
  const DotGridBackgroundPainter();

  static const double _dotRadius = 0.8;
  static const double _spacing = 22.0;
  static const double _dotOpacity = 0.12;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: _dotOpacity)
      ..style = PaintingStyle.fill;

    // Only fill the top 40% of the canvas with dots (upper-weighted texture)
    final maxY = size.height * 0.42;

    // Gradient fade: dots become progressively more transparent as they go down
    final cols = (size.width / _spacing).ceil() + 1;
    final rows = (maxY / _spacing).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final x = c * _spacing;
        final y = r * _spacing;
        // Fade dots out as they approach the bottom boundary
        final fadeFactor = 1.0 - (y / maxY);
        paint.color = const Color(0xFFFFFFFF)
            .withValues(alpha: _dotOpacity * fadeFactor.clamp(0.0, 1.0));
        canvas.drawCircle(Offset(x, y), _dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotGridBackgroundPainter oldDelegate) => false;
}
