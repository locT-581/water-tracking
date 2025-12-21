/// OPTION 3: "THE LIQUID CHIBI-BOT" - Phong cách Hiện đại & Tech-Premium
/// 
/// Một khối nước bọc trong màng Liquid Nanotech,
/// khuôn mặt là màn hình LED, có hiệu ứng iridescent cầu vồng.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'puru_3d_engine.dart';

class PuruChibiBotPainter extends CustomPainter {
  final double animationValue;
  final double hueShift; // 0-360 cho iridescent effect
  final JellyPhysics physics;
  final double hydrationPercent;

  PuruChibiBotPainter({
    required this.animationValue,
    required this.hueShift,
    required this.physics,
    required this.hydrationPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.33;

    // 1. Shadow
    _drawShadow(canvas, center, baseRadius);

    // 2. Core (Lõi năng lượng bên trong)
    _drawEnergyCore(canvas, center, baseRadius);

    // 3. Main body - Liquid Nanotech membrane
    _drawNanoMembrane(canvas, center, baseRadius);

    // 4. Iridescent coating (Lớp phủ cầu vồng)
    _drawIridescentCoating(canvas, center, baseRadius);

    // 5. LED Face Display
    _drawLEDFace(canvas, center, baseRadius);

    // 6. Tech details (Circuit patterns)
    _drawCircuitPatterns(canvas, center, baseRadius);

    // 7. Puru-minis (3 giọt nhỏ bay xung quanh)
    _drawPuruMinis(canvas, center, baseRadius);

    // 8. Holographic glow
    _drawHolographicGlow(canvas, center, baseRadius);
  }

  void _drawShadow(Canvas canvas, Offset center, double radius) {
    final shadowCenter = Offset(center.dx, center.dy + radius * 1.5);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: radius * 1.6,
        height: radius * 0.4,
      ),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: shadowCenter, radius: radius * 0.8),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
  }

  void _drawEnergyCore(Canvas canvas, Offset center, double radius) {
    final coreRadius = radius * 0.3;
    final pulseScale = 1.0 + math.sin(animationValue * math.pi * 2) * 0.15;

    // Outer glow pulse
    canvas.drawCircle(
      center,
      coreRadius * pulseScale * 2,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _getCoreColor().withOpacity(0.3),
            _getCoreColor().withOpacity(0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: coreRadius * pulseScale * 2),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Core body - Giọt nước lõi
    final corePath = Path();
    final coreTop = Offset(center.dx, center.dy - coreRadius * 1.2);
    
    corePath.moveTo(coreTop.dx, coreTop.dy);
    
    // Right curve
    corePath.quadraticBezierTo(
      center.dx + coreRadius,
      center.dy - coreRadius * 0.3,
      center.dx + coreRadius * 0.5,
      center.dy + coreRadius * 0.5,
    );
    
    // Bottom
    corePath.quadraticBezierTo(
      center.dx,
      center.dy + coreRadius * 0.8,
      center.dx - coreRadius * 0.5,
      center.dy + coreRadius * 0.5,
    );
    
    // Left curve
    corePath.quadraticBezierTo(
      center.dx - coreRadius,
      center.dy - coreRadius * 0.3,
      coreTop.dx,
      coreTop.dy,
    );
    
    corePath.close();

    canvas.drawPath(
      corePath,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.3),
          colors: [
            Colors.white.withOpacity(0.9),
            _getCoreColor(),
            _getCoreColor().withBlue(200),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(corePath.getBounds()),
    );

    // Core particles
    _drawCoreParticles(canvas, center, coreRadius);
  }

  void _drawCoreParticles(Canvas canvas, Offset center, double radius) {
    final particleCount = 8;
    
    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * math.pi * 2 + animationValue * math.pi;
      final distance = radius * 0.5 * (0.7 + math.sin(animationValue * math.pi * 2 + i) * 0.3);
      
      final particlePos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      canvas.drawCircle(
        particlePos,
        2.5,
        Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  void _drawNanoMembrane(Canvas canvas, Offset center, double radius) {
    final breathScale = 1.0 + math.sin(animationValue * math.pi * 2) * 0.04;
    final actualRadius = radius * breathScale;

    // Shape: Hơi giống tai nghe / candy premium
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: actualRadius * 2.3,
        height: actualRadius * 2.5,
      ),
      Radius.circular(actualRadius * 0.6),
    );

    // Layer 1: Glass membrane base
    canvas.drawRRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.1),
          ],
        ).createShader(rect.outerRect),
    );

    // Layer 2: Membrane thickness (3D depth)
    canvas.drawRRect(
      rect,
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 2),
    );

    // Layer 3: Glass reflection
    final reflectionRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - actualRadius * 0.3, center.dy - actualRadius * 0.5),
        width: actualRadius * 1.2,
        height: actualRadius * 1.8,
      ),
      Radius.circular(actualRadius * 0.4),
    );

    canvas.drawRRect(
      reflectionRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ).createShader(reflectionRect.outerRect),
    );
  }

  void _drawIridescentCoating(Canvas canvas, Offset center, double radius) {
    // Hiệu ứng cầu vồng đổi màu theo góc nhìn
    // Create irregular coating streaks
    final streakCount = 6;
    
    for (int i = 0; i < streakCount; i++) {
      final angle = (i / streakCount) * math.pi * 2 + hueShift * math.pi / 180;
      final startRadius = radius * 0.6;
      final endRadius = radius * 1.1;
      
      final start = Offset(
        center.dx + math.cos(angle) * startRadius,
        center.dy + math.sin(angle) * startRadius,
      );
      
      final end = Offset(
        center.dx + math.cos(angle) * endRadius,
        center.dy + math.sin(angle) * endRadius,
      );

      // Calculate iridescent color for this angle
      final hue = ((hueShift + i * 60) % 360);
      final streakColor = HSVColor.fromAHSV(1.0, hue, 0.8, 1.0).toColor();

      canvas.drawLine(
        start,
        end,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              streakColor.withOpacity(0.0),
              streakColor.withOpacity(0.4),
              streakColor.withOpacity(0.0),
            ],
          ).createShader(Rect.fromPoints(start, end))
          ..strokeWidth = radius * 0.08
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Iridescent shimmer overlay
    final shimmerRect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 2,
    );

    final shimmerGradient = SweepGradient(
      center: Alignment.center,
      startAngle: hueShift * math.pi / 180,
      endAngle: hueShift * math.pi / 180 + math.pi * 2,
      colors: [
        Colors.pink.withOpacity(0.2),
        Colors.purple.withOpacity(0.2),
        Colors.blue.withOpacity(0.2),
        Colors.cyan.withOpacity(0.2),
        Colors.green.withOpacity(0.2),
        Colors.yellow.withOpacity(0.2),
        Colors.pink.withOpacity(0.2),
      ],
    );

    canvas.drawCircle(
      center,
      radius * 1.05,
      Paint()
        ..shader = shimmerGradient.createShader(shimmerRect)
        ..blendMode = BlendMode.screen,
    );
  }

  void _drawLEDFace(Canvas canvas, Offset center, double radius) {
    final faceWidth = radius * 1.2;
    final faceHeight = radius * 0.6;
    final faceCenter = Offset(center.dx, center.dy - radius * 0.1);

    // LED screen background
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: faceCenter,
        width: faceWidth,
        height: faceHeight,
      ),
      Radius.circular(radius * 0.15),
    );

    canvas.drawRRect(
      screenRect,
      Paint()
        ..color = const Color(0xFF0A0A1A).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Pixel LED eyes
    _drawPixelEyes(canvas, faceCenter, radius);

    // Pixel LED mouth
    _drawPixelMouth(canvas, faceCenter, radius);
  }

  void _drawPixelEyes(Canvas canvas, Offset faceCenter, double radius) {
    final eyeSpacing = radius * 0.5;
    final pixelSize = radius * 0.08;

    for (final side in [-1, 1]) {
      final eyeCenter = Offset(
        faceCenter.dx + eyeSpacing * side,
        faceCenter.dy - radius * 0.1,
      );

      // Eye pattern (8x8 pixels style)
      final eyePixels = [
        [0, 1, 1, 1, 0],
        [1, 1, 1, 1, 1],
        [1, 1, 0, 1, 1],
        [1, 1, 1, 1, 1],
        [0, 1, 1, 1, 0],
      ];

      for (int row = 0; row < eyePixels.length; row++) {
        for (int col = 0; col < eyePixels[row].length; col++) {
          if (eyePixels[row][col] == 1) {
            final pixelPos = Offset(
              eyeCenter.dx + (col - 2) * pixelSize,
              eyeCenter.dy + (row - 2) * pixelSize,
            );

            // LED pixel
            canvas.drawRect(
              Rect.fromCenter(
                center: pixelPos,
                width: pixelSize * 0.8,
                height: pixelSize * 0.8,
              ),
              Paint()..color = _getLEDColor().withOpacity(0.95),
            );

            // LED glow
            canvas.drawRect(
              Rect.fromCenter(
                center: pixelPos,
                width: pixelSize,
                height: pixelSize,
              ),
              Paint()
                ..color = _getLEDColor().withOpacity(0.3)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
            );
          }
        }
      }
    }
  }

  void _drawPixelMouth(Canvas canvas, Offset faceCenter, double radius) {
    final pixelSize = radius * 0.08;
    final mouthCenter = Offset(faceCenter.dx, faceCenter.dy + radius * 0.25);

    // Smile pattern (pixel art)
    final mouthPixels = [
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
    ];

    for (int row = 0; row < mouthPixels.length; row++) {
      for (int col = 0; col < mouthPixels[row].length; col++) {
        if (mouthPixels[row][col] == 1) {
          final pixelPos = Offset(
            mouthCenter.dx + (col - 2) * pixelSize,
            mouthCenter.dy + row * pixelSize,
          );

          canvas.drawRect(
            Rect.fromCenter(
              center: pixelPos,
              width: pixelSize * 0.8,
              height: pixelSize * 0.8,
            ),
            Paint()..color = _getLEDColor().withOpacity(0.8),
          );
        }
      }
    }
  }

  void _drawCircuitPatterns(Canvas canvas, Offset center, double radius) {
    // Vẽ các đường mạch điện tử nhỏ trên màng
    final circuitPaint = Paint()
      ..color = _getLEDColor().withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Horizontal circuits
    for (int i = 0; i < 3; i++) {
      final y = center.dy - radius * 0.8 + i * radius * 0.8;
      
      canvas.drawLine(
        Offset(center.dx - radius * 0.9, y),
        Offset(center.dx + radius * 0.9, y),
        circuitPaint,
      );

      // Circuit nodes
      for (int j = 0; j < 4; j++) {
        final x = center.dx - radius * 0.6 + j * radius * 0.4;
        canvas.drawCircle(
          Offset(x, y),
          2,
          Paint()..color = _getLEDColor().withOpacity(0.5),
        );
      }
    }
  }

  void _drawPuruMinis(Canvas canvas, Offset center, double radius) {
    // 3 giọt nước nhỏ bay xung quanh
    final miniCount = 3;
    
    for (int i = 0; i < miniCount; i++) {
      final angle = (i / miniCount) * math.pi * 2 + animationValue * math.pi * 0.5;
      final orbitRadius = radius * 1.5;
      final bobbing = math.sin(animationValue * math.pi * 2 + i * math.pi / 3) * radius * 0.1;
      
      final miniCenter = Offset(
        center.dx + math.cos(angle) * orbitRadius,
        center.dy + math.sin(angle) * orbitRadius + bobbing,
      );

      final miniRadius = radius * 0.18;

      // Mini droplet
      canvas.drawCircle(
        miniCenter,
        miniRadius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              _getLEDColor().withOpacity(0.7),
              _getLEDColor().withOpacity(0.3),
            ],
          ).createShader(
            Rect.fromCircle(center: miniCenter, radius: miniRadius),
          ),
      );

      // Mini glow
      canvas.drawCircle(
        miniCenter,
        miniRadius,
        Paint()
          ..color = _getLEDColor().withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
  }

  void _drawHolographicGlow(Canvas canvas, Offset center, double radius) {
    // Outer holographic aura
    canvas.drawCircle(
      center,
      radius * 1.3,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            _getLEDColor().withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius * 1.3),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
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
  bool shouldRepaint(PuruChibiBotPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.hueShift != hueShift ||
        oldDelegate.hydrationPercent != hydrationPercent;
  }
}

