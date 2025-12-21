/// OPTION 3: "LIQUID CHIBI-BOT" V2 - Redesigned (Đơn giản & Tech hơn)
/// 
/// Giọt nước với viền holographic và lõi phát sáng đơn giản

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'puru_3d_engine.dart';

class PuruChibiBotV2Painter extends CustomPainter {
  final double animationValue;
  final double hueShift;
  final JellyPhysics physics;
  final double hydrationPercent;

  PuruChibiBotV2Painter({
    required this.animationValue,
    required this.hueShift,
    required this.physics,
    required this.hydrationPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.34;
    
    // Breathing
    final breathScale = 1.0 + math.sin(animationValue * math.pi * 2) * 0.03;
    final radius = baseRadius * breathScale;

    // 1. Shadow
    _drawShadow(canvas, center, radius);

    // 2. Energy core (lõi phát sáng)
    _drawSimpleCore(canvas, center, radius);

    // 3. Main body - Glass-like
    _drawGlassBody(canvas, center, radius);

    // 4. Iridescent rim (viền cầu vồng)
    _drawIridescentRim(canvas, center, radius);

    // 5. Simple face
    _drawSimpleFace(canvas, center, radius);

    // 6. Holographic glow
    _drawHolographicGlow(canvas, center, radius);
  }

  void _drawShadow(Canvas canvas, Offset center, double radius) {
    final shadowCenter = Offset(center.dx, center.dy + radius * 1.4);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: radius * 1.5,
        height: radius * 0.35,
      ),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.black.withOpacity(0.25),
            Colors.black.withOpacity(0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: shadowCenter, radius: radius * 0.75),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  void _drawSimpleCore(Canvas canvas, Offset center, double radius) {
    final coreRadius = radius * 0.25;
    final pulseScale = 1.0 + math.sin(animationValue * math.pi * 2) * 0.12;

    // Outer glow pulse
    canvas.drawCircle(
      center,
      coreRadius * pulseScale * 1.8,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _getCoreColor().withOpacity(0.4),
            _getCoreColor().withOpacity(0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: coreRadius * pulseScale * 1.8),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Core circle
    canvas.drawCircle(
      center,
      coreRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            _getCoreColor(),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: coreRadius),
        ),
    );
  }

  void _drawGlassBody(Canvas canvas, Offset center, double radius) {
    // Rounded rectangle shape
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: radius * 2.1,
        height: radius * 2.3,
      ),
      Radius.circular(radius * 0.55),
    );

    // Glass body
    canvas.drawRRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.08),
          ],
        ).createShader(rect.outerRect),
    );

    // Glass reflection
    final reflectionRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.25, center.dy - radius * 0.4),
        width: radius * 1.0,
        height: radius * 1.5,
      ),
      Radius.circular(radius * 0.3),
    );

    canvas.drawRRect(
      reflectionRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.05),
          ],
        ).createShader(reflectionRect.outerRect),
    );
  }

  void _drawIridescentRim(Canvas canvas, Offset center, double radius) {
    // Viền cầu vồng đơn giản
    final hue = hueShift % 360;
    
    for (int i = 0; i < 4; i++) {
      final angle = (i / 4) * math.pi * 2 + hue * math.pi / 180;
      final streakColor = HSVColor.fromAHSV(1.0, (hue + i * 90) % 360, 0.7, 1.0).toColor();
      
      final start = Offset(
        center.dx + math.cos(angle) * radius * 0.7,
        center.dy + math.sin(angle) * radius * 0.7,
      );
      
      final end = Offset(
        center.dx + math.cos(angle) * radius * 1.05,
        center.dy + math.sin(angle) * radius * 1.05,
      );

      canvas.drawLine(
        start,
        end,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              streakColor.withOpacity(0.0),
              streakColor.withOpacity(0.5),
              streakColor.withOpacity(0.0),
            ],
          ).createShader(Rect.fromPoints(start, end))
          ..strokeWidth = radius * 0.06
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  void _drawSimpleFace(Canvas canvas, Offset center, double radius) {
    // Simple eyes - 2 dots
    final eyeRadius = radius * 0.08;
    final eyeSpacing = radius * 0.4;

    for (final side in [-1, 1]) {
      final eyeCenter = Offset(
        center.dx + eyeSpacing * side,
        center.dy - radius * 0.15,
      );

      // Eye glow
      canvas.drawCircle(
        eyeCenter,
        eyeRadius * 1.5,
        Paint()
          ..color = _getLEDColor().withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Eye core
      canvas.drawCircle(
        eyeCenter,
        eyeRadius,
        Paint()..color = _getLEDColor(),
      );
    }

    // Simple mouth - line
    final mouthWidth = radius * 0.25;
    final mouthCenter = Offset(center.dx, center.dy + radius * 0.2);

    canvas.drawLine(
      Offset(mouthCenter.dx - mouthWidth / 2, mouthCenter.dy),
      Offset(mouthCenter.dx + mouthWidth / 2, mouthCenter.dy),
      Paint()
        ..color = _getLEDColor().withOpacity(0.7)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawHolographicGlow(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius * 1.25,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            _getLEDColor().withOpacity(0.08),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius * 1.25),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
  }

  Color _getCoreColor() {
    return hydrationPercent > 0.5
        ? const Color(0xFF00D4FF)
        : const Color(0xFF7B9FFF);
  }

  Color _getLEDColor() {
    if (hydrationPercent > 0.75) {
      return const Color(0xFF00FFAA);
    } else if (hydrationPercent > 0.5) {
      return const Color(0xFF00D4FF);
    } else if (hydrationPercent > 0.25) {
      return const Color(0xFFFFAA00);
    } else {
      return const Color(0xFFFF3D00);
    }
  }

  @override
  bool shouldRepaint(PuruChibiBotV2Painter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.hueShift != hueShift ||
        oldDelegate.hydrationPercent != hydrationPercent;
  }
}

