/// OPTION 1: "THE CELESTIAL DROP" - Phong cách Kỳ ảo & Lung linh
/// 
/// Một giọt nước ma thuật với các hạt lấp lánh bên trong,
/// quầng nước (halo) trên đầu, và đôi mắt chứa cả bầu trời sao.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'puru_3d_engine.dart';

class PuruCelestialPainter extends CustomPainter {
  final double animationValue; // 0-1 cho breathing animation
  final double rotationY; // Góc xoay theo trục Y (độ)
  final JellyPhysics physics;
  final double hydrationPercent; // 0-1

  PuruCelestialPainter({
    required this.animationValue,
    required this.rotationY,
    required this.physics,
    required this.hydrationPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.35;

    // Setup lighting
    final light = Light3D(
      position: vm.Vector3(-2, 3, 5),
      color: Colors.white,
      intensity: 1.2,
    );

    // Material cho giọt nước ma thuật
    final material = Material3D(
      baseColor: _getColorForHydration(hydrationPercent),
      shininess: 80.0,
      transparency: 0.75,
      subsurfaceScattering: 0.4,
    );

    // 1. Vẽ Halo (Quầng nước lơ lửng trên đầu)
    _drawHalo(canvas, center, baseRadius);

    // 2. Vẽ Shadow (Bóng đổ xuống đất)
    _drawShadow(canvas, center, baseRadius);

    // 3. Vẽ thân chính (Main body) - Hình giọt nước 3D
    _drawMainBody(canvas, center, baseRadius, material, light);

    // 4. Vẽ các hạt lấp lánh bên trong (Glitter particles)
    _drawGlitterParticles(canvas, center, baseRadius);

    // 5. Vẽ vệt sáng (Light trail) khi di chuyển
    _drawLightTrail(canvas, center, baseRadius);

    // 6. Vẽ đôi mắt (Eyes) - Chứa vũ trụ sao
    _drawCosmicEyes(canvas, center, baseRadius);

    // 7. Vẽ miệng
    _drawMouth(canvas, center, baseRadius);

    // 8. Highlight và Specular
    _drawSpecularHighlights(canvas, center, baseRadius);
  }

  void _drawHalo(Canvas canvas, Offset center, double radius) {
    final haloCenter = Offset(center.dx, center.dy - radius * 1.5);
    final haloRadius = radius * 0.3;

    // Màu halo thay đổi theo hydration
    final haloColor = hydrationPercent > 0.7
        ? Colors.yellow
        : hydrationPercent > 0.3
            ? Colors.orange
            : Colors.red;

    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          haloColor.withOpacity(0.6),
          haloColor.withOpacity(0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: haloCenter, radius: haloRadius * 2),
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(haloCenter, haloRadius * 2, glowPaint);

    // Inner halo ring
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          haloColor.withOpacity(0.0),
          haloColor.withOpacity(0.8),
          haloColor.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromCircle(center: haloCenter, radius: haloRadius),
      );

    canvas.drawCircle(haloCenter, haloRadius, haloPaint);
  }

  void _drawShadow(Canvas canvas, Offset center, double radius) {
    final shadowCenter = Offset(center.dx, center.dy + radius * 1.3);
    
    final shadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.black.withOpacity(0.3),
          Colors.black.withOpacity(0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: shadowCenter, radius: radius * 0.8),
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: radius * 1.6,
        height: radius * 0.4,
      ),
      shadowPaint,
    );
  }

  void _drawMainBody(
    Canvas canvas,
    Offset center,
    double radius,
    Material3D material,
    Light3D light,
  ) {
    // Breathing animation
    final breathScale = 1.0 + math.sin(animationValue * math.pi * 2) * 0.05;
    final actualRadius = radius * breathScale;

    // Tạo path cho giọt nước với đỉnh nhọn
    final path = Path();
    
    // Đỉnh nhọn cong sang một bên (như mầm cây)
    final tipTop = Offset(
      center.dx + actualRadius * 0.1,
      center.dy - actualRadius * 1.2,
    );
    
    path.moveTo(tipTop.dx, tipTop.dy);

    // Vẽ đường cong bên phải
    path.quadraticBezierTo(
      center.dx + actualRadius * 0.8,
      center.dy - actualRadius * 0.4,
      center.dx + actualRadius * 0.7,
      center.dy + actualRadius * 0.2,
    );

    // Đáy tròn
    path.quadraticBezierTo(
      center.dx + actualRadius * 0.3,
      center.dy + actualRadius * 0.9,
      center.dx,
      center.dy + actualRadius,
    );

    path.quadraticBezierTo(
      center.dx - actualRadius * 0.3,
      center.dy + actualRadius * 0.9,
      center.dx - actualRadius * 0.7,
      center.dy + actualRadius * 0.2,
    );

    // Vẽ đường cong bên trái
    path.quadraticBezierTo(
      center.dx - actualRadius * 0.8,
      center.dy - actualRadius * 0.4,
      tipTop.dx,
      tipTop.dy,
    );

    path.close();

    // Layer 1: Subsurface Scattering (Ánh sáng từ phía sau)
    final sssGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        material.baseColor.withOpacity(0.3),
        material.baseColor.withOpacity(0.6),
        material.baseColor.withOpacity(0.8),
      ],
    ).createShader(path.getBounds());

    canvas.drawPath(
      path,
      Paint()..shader = sssGradient,
    );

    // Layer 2: Main body với Phong lighting
    final lightPos = Alignment(
      -0.3 + math.cos(rotationY * math.pi / 180) * 0.4,
      -0.5,
    );

    final bodyGradient = GradientUtils.createSphereGradient(
      baseColor: material.baseColor,
      lightPosition: lightPos,
      shininess: 0.6,
    ).createShader(path.getBounds());

    canvas.drawPath(
      path,
      Paint()
        ..shader = bodyGradient
        ..style = PaintingStyle.fill,
    );

    // Layer 3: Outer glow
    canvas.drawPath(
      path,
      Paint()
        ..color = material.baseColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );
  }

  void _drawGlitterParticles(Canvas canvas, Offset center, double radius) {
    final particleCount = 20;
    final random = math.Random(42); // Seed cố định để consistent

    for (int i = 0; i < particleCount; i++) {
      final angle = random.nextDouble() * math.pi * 2;
      final distance = random.nextDouble() * radius * 0.7;
      
      // Di chuyển theo thời gian
      final timeOffset = (animationValue + i / particleCount) % 1.0;
      final yOffset = math.sin(timeOffset * math.pi * 2) * radius * 0.3;

      final particlePos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance + yOffset,
      );

      final particleSize = (2 + random.nextDouble() * 4) *
          (0.5 + math.sin(timeOffset * math.pi * 2) * 0.5);

      // Glitter particle với glow
      canvas.drawCircle(
        particlePos,
        particleSize,
        Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      // Core
      canvas.drawCircle(
        particlePos,
        particleSize * 0.5,
        Paint()..color = Colors.yellow.withOpacity(0.9),
      );
    }
  }

  void _drawLightTrail(Canvas canvas, Offset center, double radius) {
    // Vệt sáng mờ ảo trailing behind
    final trailLength = 5;
    
    for (int i = 0; i < trailLength; i++) {
      final opacity = (trailLength - i) / trailLength * 0.1;
      final offset = Offset(
        center.dx - i * 3,
        center.dy + i * 2,
      );

      canvas.drawCircle(
        offset,
        radius * 0.8,
        Paint()
          ..color = _getColorForHydration(hydrationPercent).withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      );
    }
  }

  void _drawCosmicEyes(Canvas canvas, Offset center, double radius) {
    final eyeRadius = radius * 0.15;
    final eyeSpacing = radius * 0.4;

    for (final side in [-1, 1]) {
      final eyeCenter = Offset(
        center.dx + eyeSpacing * side,
        center.dy - radius * 0.15,
      );

      // Eye background - Deep space
      canvas.drawCircle(
        eyeCenter,
        eyeRadius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF0F0F1E),
            ],
          ).createShader(
            Rect.fromCircle(center: eyeCenter, radius: eyeRadius),
          ),
      );

      // Starfield inside eye
      final starRandom = math.Random(side);
      for (int i = 0; i < 8; i++) {
        final starAngle = starRandom.nextDouble() * math.pi * 2;
        final starDist = starRandom.nextDouble() * eyeRadius * 0.8;
        final starPos = Offset(
          eyeCenter.dx + math.cos(starAngle) * starDist,
          eyeCenter.dy + math.sin(starAngle) * starDist,
        );

        canvas.drawCircle(
          starPos,
          starRandom.nextDouble() * 1.5 + 0.5,
          Paint()
            ..color = Colors.white.withOpacity(0.6 + starRandom.nextDouble() * 0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
        );
      }

      // Star pupil (4-point star)
      _drawStarPupil(canvas, eyeCenter, eyeRadius * 0.4);

      // Eye shine/highlight (3 layers)
      // Large highlight
      canvas.drawCircle(
        Offset(eyeCenter.dx - eyeRadius * 0.3, eyeCenter.dy - eyeRadius * 0.3),
        eyeRadius * 0.35,
        Paint()..color = Colors.white.withOpacity(0.5),
      );

      // Medium highlight
      canvas.drawCircle(
        Offset(eyeCenter.dx - eyeRadius * 0.25, eyeCenter.dy - eyeRadius * 0.35),
        eyeRadius * 0.2,
        Paint()..color = Colors.white.withOpacity(0.7),
      );

      // Small sharp highlight
      canvas.drawCircle(
        Offset(eyeCenter.dx - eyeRadius * 0.35, eyeCenter.dy - eyeRadius * 0.25),
        eyeRadius * 0.12,
        Paint()..color = Colors.white,
      );
    }
  }

  void _drawStarPupil(Canvas canvas, Offset center, double size) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 - math.pi / 2;
      final radius = i.isEven ? outerRadius : innerRadius;
      
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.yellow.withOpacity(0.9),
            Colors.orange.withOpacity(0.6),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: size)),
    );

    // Glow
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.yellow.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthWidth = radius * 0.15;
    final mouthCenter = Offset(center.dx, center.dy + radius * 0.15);

    // Simple "ω" shape
    final path = Path();
    path.moveTo(mouthCenter.dx - mouthWidth, mouthCenter.dy);
    path.quadraticBezierTo(
      mouthCenter.dx - mouthWidth * 0.5,
      mouthCenter.dy + mouthWidth * 0.5,
      mouthCenter.dx,
      mouthCenter.dy,
    );
    path.quadraticBezierTo(
      mouthCenter.dx + mouthWidth * 0.5,
      mouthCenter.dy + mouthWidth * 0.5,
      mouthCenter.dx + mouthWidth,
      mouthCenter.dy,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF051E3E).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawSpecularHighlights(Canvas canvas, Offset center, double radius) {
    // Large specular highlight (wet surface look)
    final highlightCenter = Offset(
      center.dx - radius * 0.25,
      center.dy - radius * 0.4,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: highlightCenter,
        width: radius * 0.6,
        height: radius * 0.8,
      ),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.2),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: highlightCenter, radius: radius * 0.4),
        ),
    );
  }

  Color _getColorForHydration(double percent) {
    if (percent > 0.75) {
      return const Color(0xFF2AF598); // Bright cyan
    } else if (percent > 0.5) {
      return const Color(0xFF009EFD); // Blue
    } else if (percent > 0.25) {
      return const Color(0xFF7B9FFF); // Light blue
    } else {
      return const Color(0xFF9E9E9E); // Gray
    }
  }

  @override
  bool shouldRepaint(PuruCelestialPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.hydrationPercent != hydrationPercent;
  }
}

