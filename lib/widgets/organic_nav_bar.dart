import 'dart:math' as math;
import 'package:flutter/material.dart';

class OrganicNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Color activeColor;

  const OrganicNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.activeColor = const Color(0xFFFF5722),
  });

  final List<IconData> _icons = const [
    Icons.home_rounded,
    Icons.map_outlined,
    Icons.favorite_border_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 44.0;
    const double lobeRadius = 27.0;
    const double waistRadius = 20.0;
    const double spacing = 62.0;
    const int count = 4;
    const double totalWidth = (count - 1) * spacing + lobeRadius * 2 + 10.0;
    const double totalHeight = lobeRadius * 2 + 16.0;

    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, top: 4),
        width: totalWidth,
        height: totalHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Smooth Organic Wavy Painter
            CustomPaint(
              size: const Size(totalWidth, totalHeight),
              painter: _SmoothWavyNavBarPainter(
                count: count,
                spacing: spacing,
                lobeRadius: lobeRadius,
                waistRadius: waistRadius,
                color: const Color(0xFF141414),
              ),
            ),

            // 4 Circular Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(count, (index) {
                final isSelected = selectedIndex == index;
                return Container(
                  width: spacing,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => onItemSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? activeColor : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _icons[index],
                        size: 22,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmoothWavyNavBarPainter extends CustomPainter {
  final int count;
  final double spacing;
  final double lobeRadius;
  final double waistRadius;
  final Color color;

  _SmoothWavyNavBarPainter({
    required this.count,
    required this.spacing,
    required this.lobeRadius,
    required this.waistRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final cy = size.height / 2;
    final startX = (size.width - ((count - 1) * spacing)) / 2;
    final centers = List.generate(count, (i) => Offset(startX + i * spacing, cy));

    final path = Path();
    const double theta = 0.55; // Angle in radians defining where the waist connects to the circles

    // Start on the leftmost circle at angle (-pi/2 - theta)
    final p0 = Offset(
      centers[0].dx + lobeRadius * math.cos(-math.pi / 2 - theta),
      cy + lobeRadius * math.sin(-math.pi / 2 - theta),
    );
    path.moveTo(p0.dx, p0.dy);

    // 1. TOP CONTOUR
    for (int i = 0; i < count; i++) {
      // Arc over circle i from (-pi/2 - theta) to (-pi/2 + theta)
      if (i > 0) {
        path.arcTo(
          Rect.fromCircle(center: centers[i], radius: lobeRadius),
          -math.pi / 2 - theta,
          2 * theta,
          false,
        );
      } else {
        path.arcTo(
          Rect.fromCircle(center: centers[0], radius: lobeRadius),
          -math.pi / 2 - theta,
          2 * theta,
          false,
        );
      }

      // If not the last circle, draw top dip to the next circle
      if (i < count - 1) {
        final c1 = centers[i];
        final c2 = centers[i + 1];
        final midX = (c1.dx + c2.dx) / 2;
        final target = Offset(
          c2.dx + lobeRadius * math.cos(-math.pi / 2 - theta),
          cy + lobeRadius * math.sin(-math.pi / 2 - theta),
        );

        path.cubicTo(
          c1.dx + spacing * 0.25, cy - waistRadius,
          midX - spacing * 0.1, cy - waistRadius,
          midX, cy - waistRadius,
        );
        path.cubicTo(
          midX + spacing * 0.1, cy - waistRadius,
          c2.dx - spacing * 0.25, cy - waistRadius,
          target.dx, target.dy,
        );
      }
    }

    // 2. RIGHT CAP (around circle count - 1)
    path.arcTo(
      Rect.fromCircle(center: centers.last, radius: lobeRadius),
      -math.pi / 2 + theta,
      math.pi - 2 * theta,
      false,
    );

    // 3. BOTTOM CONTOUR (going backwards from right to left)
    for (int i = count - 1; i >= 0; i--) {
      // Arc over circle i from (pi/2 - theta) to (pi/2 + theta)
      if (i < count - 1) {
        path.arcTo(
          Rect.fromCircle(center: centers[i], radius: lobeRadius),
          math.pi / 2 - theta,
          2 * theta,
          false,
        );
      }

      // If not the first circle, draw bottom dip to previous circle
      if (i > 0) {
        final c2 = centers[i];
        final c1 = centers[i - 1];
        final midX = (c1.dx + c2.dx) / 2;
        final target = Offset(
          c1.dx + lobeRadius * math.cos(math.pi / 2 - theta),
          cy + lobeRadius * math.sin(math.pi / 2 - theta),
        );

        path.cubicTo(
          c2.dx - spacing * 0.25, cy + waistRadius,
          midX + spacing * 0.1, cy + waistRadius,
          midX, cy + waistRadius,
        );
        path.cubicTo(
          midX - spacing * 0.1, cy + waistRadius,
          c1.dx + spacing * 0.25, cy + waistRadius,
          target.dx, target.dy,
        );
      }
    }

    // 4. LEFT CAP (around circle 0 back to start)
    path.arcTo(
      Rect.fromCircle(center: centers.first, radius: lobeRadius),
      math.pi / 2 + theta,
      math.pi - 2 * theta,
      false,
    );

    path.close();

    // Draw shadow
    canvas.save();
    canvas.translate(0, 4);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw main black wavy body
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SmoothWavyNavBarPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.count != count ||
        oldDelegate.spacing != spacing;
  }
}
