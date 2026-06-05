import 'package:flutter/material.dart';
import '../theme/neurocosmos_theme.dart';

class NeuroCosmosPanel extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool withGlow;
  final bool withNeuralLines;
  final double borderRadius;

  const NeuroCosmosPanel({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.withGlow = true,
    this.withNeuralLines = true,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NeuroCosmosTheme.primaryDark.withValues(alpha: 0.6),
            NeuroCosmosTheme.deepBlueCosmos.withValues(alpha: 0.4),
          ],
        ),
        border: Border.all(
          color: NeuroCosmosTheme.electricTurquoise.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: withGlow
            ? [
                BoxShadow(
                  color: NeuroCosmosTheme.electricTurquoise.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: NeuroCosmosTheme.neonPink.withValues(alpha: 0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Neural lines background
            if (withNeuralLines)
              Positioned.fill(
                child: CustomPaint(
                  painter: NeuralLinesPainter(),
                ),
              ),
            // Glass effect overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class NeuralLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NeuroCosmosTheme.electricTurquoise.withValues(alpha: 0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw neural network-like lines
    final random = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 5; i++) {
      final startX = (random * (i + 1) % size.width).toDouble();
      final startY = (random * (i + 2) % size.height).toDouble();
      final endX = (random * (i + 3) % size.width).toDouble();
      final endY = (random * (i + 4) % size.height).toDouble();

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );

      // Draw small nodes
      canvas.drawCircle(
        Offset(startX, startY),
        2,
        paint..color = NeuroCosmosTheme.neonPink.withValues(alpha: 0.3),
      );
      canvas.drawCircle(
        Offset(endX, endY),
        2,
        paint..color = NeuroCosmosTheme.electricTurquoise.withValues(alpha: 0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
