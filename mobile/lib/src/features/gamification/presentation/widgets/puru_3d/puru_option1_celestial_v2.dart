/// OPTION 1: "CELESTIAL DROP" V2 - Redesigned (Đơn giản & Đẹp hơn)
/// 
/// Giọt nước với ánh sáng mềm mại và hạt lấp lánh tinh tế

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'puru_3d_engine.dart';

class PuruCelestialV2Painter extends CustomPainter {
  final double animationValue;
  final JellyPhysics physics;
  final double hydrationPercent;

  PuruCelestialV2Painter({
    required this.animationValue,
    required this.physics,
    required this.hydrationPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.35;
    
    // Breathing animation
    final breathScale = 1.0 + math.sin(animationValue * math.pi * 2) * 0.04;
    final radius = baseRadius * breathScale;

    // 1. Shadow
    _drawSoftShadow(canvas, center, radius);

    // 2. Outer glow (soft aura)
    _drawSoftGlow(canvas, center, radius);

    // 3. Main body - Simple water drop shape
    _drawMainBody(canvas, center, radius);

    // 4. Subtle glitter particles (ít hơn, nhỏ hơn)
    _drawSubtleGlitter(canvas, center, radius);

    // 5. Eyes - Simple and cute
    _drawSimpleEyes(canvas, center, radius);

    // 6. Mouth
    _drawMouth(canvas, center, radius);

    // 7. Soft highlight
    _drawSoftHighlight(canvas, center, radius);
  }

  void _drawSoftShadow(Canvas canvas, Offset center, double radius) {
    final shadowCenter = Offset(center.dx, center.dy + radius * 1.2);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: radius * 1.4,
        height: radius * 0.3,
      ),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.black.withOpacity(0.15),
            Colors.black.withOpacity(0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: shadowCenter, radius: radius * 0.7),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
  }

  void _drawSoftGlow(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius * 1.15,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _getColorForHydration().withOpacity(0.2),
            _getColorForHydration().withOpacity(0.05),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius * 1.15),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );
  }

  void _drawMainBody(Canvas canvas, Offset center, double radius) {
    // Simple oval shape
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 2.2,
      ),
      Radius.circular(radius),
    );

    // Gradient fill
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getColorForHydration().withOpacity(0.85),
            _getColorForHydration(),
            _getColorForHydration().withBlue(200),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(bodyRect.outerRect),
    );

    // Subtle outer ring
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawSubtleGlitter(Canvas canvas, Offset center, double radius) {
    // Chỉ 8 hạt nhỏ, tinh tế
    final random = math.Random(42);
    
    for (int i = 0; i < 8; i++) {
      final angle = random.nextDouble() * math.pi * 2;
      final distance = random.nextDouble() * radius * 0.6;
      final timeOffset = (animationValue + i / 8) % 1.0;
      final yOffset = math.sin(timeOffset * math.pi * 2) * 10;

      final particlePos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance + yOffset,
      );

      final size = 1.5 + random.nextDouble() * 2;

      // Soft glow
      canvas.drawCircle(
        particlePos,
        size * 1.5,
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );

      // Core
      canvas.drawCircle(
        particlePos,
        size,
        Paint()..color = Colors.white.withOpacity(0.8),
      );
    }
  }

  void _drawSimpleEyes(Canvas canvas, Offset center, double radius) {
    final eyeRadius = radius * 0.12;
    final eyeSpacing = radius * 0.35;

    for (final side in [-1, 1]) {
      final eyeCenter = Offset(
        center.dx + eyeSpacing * side,
        center.dy - radius * 0.2,
      );

      // Eye background
      canvas.drawCircle(
        eyeCenter,
        eyeRadius,
        Paint()..color = const Color(0xFF1A1A2E),
      );

      // Single highlight (đơn giản)
      canvas.drawCircle(
        Offset(
          eyeCenter.dx - eyeRadius * 0.3,
          eyeCenter.dy - eyeRadius * 0.3,
        ),
        eyeRadius * 0.35,
        Paint()..color = Colors.white.withOpacity(0.7),
      );
    }
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthWidth = radius * 0.12;
    final mouthCenter = Offset(center.dx, center.dy + radius * 0.2);

    // Simple curve
    final path = Path();
    path.moveTo(mouthCenter.dx - mouthWidth, mouthCenter.dy);
    path.quadraticBezierTo(
      mouthCenter.dx,
      mouthCenter.dy + mouthWidth * 0.5,
      mouthCenter.dx + mouthWidth,
      mouthCenter.dy,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF051E3E).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawSoftHighlight(Canvas canvas, Offset center, double radius) {
    final highlightCenter = Offset(
      center.dx - radius * 0.3,
      center.dy - radius * 0.4,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: highlightCenter,
        width: radius * 0.5,
        height: radius * 0.7,
      ),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: highlightCenter, radius: radius * 0.35),
        ),
    );
  }

  Color _getColorForHydration() {
    if (hydrationPercent > 0.75) {
      return const Color(0xFF2AF598);
    } else if (hydrationPercent > 0.5) {
      return const Color(0xFF009EFD);
    } else if (hydrationPercent > 0.25) {
      return const Color(0xFF7B9FFF);
    } else {
      return const Color(0xFFC5C5C5);
    }
  }

  @override
  bool shouldRepaint(PuruCelestialV2Painter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.hydrationPercent != hydrationPercent;
  }
}

