/// OPTION 2: "THE AQUA-AXO" - Phong cách Sinh vật Hữu cơ
/// 
/// Lấy cảm hứng từ Axolotl với 3 cặp vây tai bằng nước,
/// mắt cách xa nhau tạo vẻ ngáo ngơ, và đuôi nước ngắn vẫy nhẹ.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'puru_3d_engine.dart';

class PuruAxoPainter extends CustomPainter {
  final double animationValue;
  final double tailWagAngle; // Góc vẫy đuôi (-pi/4 đến pi/4)
  final JellyPhysics physics;
  final double hydrationPercent;

  PuruAxoPainter({
    required this.animationValue,
    required this.tailWagAngle,
    required this.physics,
    required this.hydrationPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.32;

    final material = Material3D(
      baseColor: _getColorForHydration(hydrationPercent),
      shininess: 60.0,
      transparency: 0.8,
      subsurfaceScattering: 0.5,
    );

    // 1. Shadow
    _drawShadow(canvas, center, baseRadius);

    // 2. Đuôi (vẽ trước thân để nó ở phía sau)
    _drawTail(canvas, center, baseRadius);

    // 3. Thân chính - Tròn mập mạp, bụng phệ
    _drawMainBody(canvas, center, baseRadius, material);

    // 4. Vây tai (Gills) - 3 cặp ở hai bên
    _drawGills(canvas, center, baseRadius);

    // 5. Bọt khí bên trong
    _drawBubbles(canvas, center, baseRadius);

    // 6. Đôi mắt wide-set (cách xa nhau)
    _drawWideSetEyes(canvas, center, baseRadius);

    // 7. Miệng hình chữ "v" mỉm cười
    _drawSmileMouth(canvas, center, baseRadius);

    // 8. Má hồng
    _drawBlush(canvas, center, baseRadius);
  }

  void _drawShadow(Canvas canvas, Offset center, double radius) {
    final shadowCenter = Offset(center.dx + radius * 0.1, center.dy + radius * 1.4);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: radius * 1.8,
        height: radius * 0.5,
      ),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.black.withOpacity(0.25),
            Colors.black.withOpacity(0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: shadowCenter, radius: radius),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  void _drawTail(Canvas canvas, Offset center, double radius) {
    // Đuôi nước ngắn, dẹt, vẫy nhẹ
    final tailStart = Offset(center.dx, center.dy + radius * 0.7);
    final tailLength = radius * 0.6;
    
    // Đuôi bị uốn cong theo tailWagAngle
    final tailEnd = Offset(
      tailStart.dx + math.sin(tailWagAngle) * tailLength * 0.5,
      tailStart.dy + math.cos(tailWagAngle) * tailLength,
    );

    final path = Path();
    path.moveTo(tailStart.dx, tailStart.dy);

    // Curve control points
    final cp1 = Offset(
      tailStart.dx + math.sin(tailWagAngle * 0.5) * tailLength * 0.3,
      tailStart.dy + tailLength * 0.3,
    );
    final cp2 = Offset(
      tailEnd.dx - math.sin(tailWagAngle * 0.3) * tailLength * 0.2,
      tailEnd.dy - tailLength * 0.2,
    );

    path.cubicTo(
      cp1.dx, cp1.dy,
      cp2.dx, cp2.dy,
      tailEnd.dx, tailEnd.dy,
    );

    // Tail fin shape (dẹt)
    final finWidth = radius * 0.4;
    path.lineTo(
      tailEnd.dx + math.cos(tailWagAngle) * finWidth,
      tailEnd.dy + math.sin(tailWagAngle) * finWidth,
    );
    path.lineTo(
      tailEnd.dx - math.cos(tailWagAngle) * finWidth,
      tailEnd.dy - math.sin(tailWagAngle) * finWidth,
    );

    path.cubicTo(
      cp2.dx, cp2.dy,
      cp1.dx, cp1.dy,
      tailStart.dx, tailStart.dy,
    );
    path.close();

    // Gradient for tail
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getColorForHydration(hydrationPercent),
            _getColorForHydration(hydrationPercent).withOpacity(0.6),
            _getColorForHydration(hydrationPercent).withOpacity(0.3),
          ],
        ).createShader(path.getBounds()),
    );

    // Tail outline
    canvas.drawPath(
      path,
      Paint()
        ..color = _getColorForHydration(hydrationPercent).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawMainBody(Canvas canvas, Offset center, double radius, Material3D material) {
    // Breathing
    final breathScale = 1.0 + math.sin(animationValue * math.pi * 2) * 0.06;
    final actualRadius = radius * breathScale;

    // Thân hình oval, bụng hơi phệ
    final bodyRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + actualRadius * 0.05),
      width: actualRadius * 2.2,
      height: actualRadius * 2.0,
    );

    // Subsurface scattering layer
    canvas.drawOval(
      bodyRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            material.baseColor.withOpacity(0.4),
            material.baseColor.withOpacity(0.7),
            material.baseColor.withOpacity(0.85),
          ],
        ).createShader(bodyRect),
    );

    // Main body với 3D lighting
    canvas.drawOval(
      bodyRect,
      Paint()
        ..shader = GradientUtils.createSphereGradient(
          baseColor: material.baseColor,
          lightPosition: const Alignment(-0.4, -0.5),
          shininess: 0.5,
        ).createShader(bodyRect),
    );

    // Outer glow
    canvas.drawOval(
      bodyRect,
      Paint()
        ..color = material.baseColor.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Specular highlight (wet look)
    final highlightRect = Rect.fromCenter(
      center: Offset(center.dx - actualRadius * 0.3, center.dy - actualRadius * 0.4),
      width: actualRadius * 0.8,
      height: actualRadius * 1.0,
    );

    canvas.drawOval(
      highlightRect,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ).createShader(highlightRect),
    );
  }

  void _drawGills(Canvas canvas, Offset center, double radius) {
    // 3 cặp vây tai ở hai bên
    final gillCount = 3;
    
    for (int side in [-1, 1]) {
      for (int i = 0; i < gillCount; i++) {
        final baseAngle = side > 0 ? 0.0 : math.pi;
        final angleOffset = (i - 1) * 0.25; // Spread các gill
        final angle = baseAngle + angleOffset;
        
        final gillBase = Offset(
          center.dx + math.cos(angle) * radius * 0.9,
          center.dy - radius * 0.3 + i * radius * 0.25,
        );

        // Gill sẽ rung rinh theo animation
        final wiggle = math.sin(animationValue * math.pi * 2 + i * 0.5) * 0.15;
        
        _drawSingleGill(canvas, gillBase, radius * 0.4, angle + wiggle, side);
      }
    }
  }

  void _drawSingleGill(Canvas canvas, Offset base, double length, double angle, int side) {
    final path = Path();
    
    // 3 "fingers" trên mỗi gill
    final fingerCount = 3;
    final fingerSpacing = 0.3;

    for (int i = 0; i < fingerCount; i++) {
      final fingerAngle = angle + (i - 1) * fingerSpacing * side;
      final fingerLength = length * (0.7 + i * 0.15);
      
      final fingerTip = Offset(
        base.dx + math.cos(fingerAngle) * fingerLength,
        base.dy + math.sin(fingerAngle) * fingerLength,
      );

      final controlPoint = Offset(
        base.dx + math.cos(fingerAngle) * fingerLength * 0.6,
        base.dy + math.sin(fingerAngle) * fingerLength * 0.6,
      );

      if (i == 0) {
        path.moveTo(base.dx, base.dy);
      }

      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        fingerTip.dx,
        fingerTip.dy,
      );
    }

    // Draw gill
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getColorForHydration(hydrationPercent).withOpacity(0.8),
            _getColorForHydration(hydrationPercent).withOpacity(0.4),
            _getColorForHydration(hydrationPercent).withOpacity(0.1),
          ],
        ).createShader(path.getBounds())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // Glow on gills
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  void _drawBubbles(Canvas canvas, Offset center, double radius) {
    final bubbles = [
      (offset: Offset(0.2, -0.1), size: 0.08),
      (offset: Offset(-0.3, 0.2), size: 0.12),
      (offset: Offset(0.1, 0.3), size: 0.06),
      (offset: Offset(-0.1, -0.25), size: 0.1),
      (offset: Offset(0.35, 0.1), size: 0.07),
    ];

    for (final bubble in bubbles) {
      final bubblePos = Offset(
        center.dx + bubble.offset.dx * radius,
        center.dy + bubble.offset.dy * radius +
            math.sin(animationValue * math.pi * 2 + bubble.offset.dx) * 5,
      );
      final bubbleRadius = bubble.size * radius;

      // Bubble body
      canvas.drawCircle(
        bubblePos,
        bubbleRadius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.1),
            ],
          ).createShader(
            Rect.fromCircle(center: bubblePos, radius: bubbleRadius),
          ),
      );

      // Bubble highlight
      canvas.drawCircle(
        Offset(
          bubblePos.dx - bubbleRadius * 0.3,
          bubblePos.dy - bubbleRadius * 0.3,
        ),
        bubbleRadius * 0.4,
        Paint()..color = Colors.white.withOpacity(0.6),
      );

      // Bubble outline
      canvas.drawCircle(
        bubblePos,
        bubbleRadius,
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  void _drawWideSetEyes(Canvas canvas, Offset center, double radius) {
    // Mắt cách xa nhau - tạo vẻ ngáo ngơ
    final eyeRadius = radius * 0.18;
    final eyeSpacing = radius * 0.85; // Wide spacing!

    for (final side in [-1, 1]) {
      final eyeCenter = Offset(
        center.dx + eyeSpacing * side,
        center.dy - radius * 0.25,
      );

      // Eye white/background
      canvas.drawCircle(
        eyeCenter,
        eyeRadius,
        Paint()..color = Colors.white.withOpacity(0.9),
      );

      // Iris - Dark gradient
      final irisRadius = eyeRadius * 0.65;
      canvas.drawCircle(
        eyeCenter,
        irisRadius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF0F0F1E),
            ],
          ).createShader(
            Rect.fromCircle(center: eyeCenter, radius: irisRadius),
          ),
      );

      // Pupil
      canvas.drawCircle(
        eyeCenter,
        irisRadius * 0.5,
        Paint()..color = Colors.black,
      );

      // Triple highlight layers (3 điểm sáng)
      final highlights = [
        (offset: Offset(-0.35, -0.4), size: 0.4, opacity: 0.5),
        (offset: Offset(-0.25, -0.45), size: 0.25, opacity: 0.7),
        (offset: Offset(-0.4, -0.3), size: 0.15, opacity: 1.0),
      ];

      for (final hl in highlights) {
        canvas.drawCircle(
          Offset(
            eyeCenter.dx + eyeRadius * hl.offset.dx,
            eyeCenter.dy + eyeRadius * hl.offset.dy,
          ),
          eyeRadius * hl.size,
          Paint()..color = Colors.white.withOpacity(hl.opacity),
        );
      }

      // Eye outline
      canvas.drawCircle(
        eyeCenter,
        eyeRadius,
        Paint()
          ..color = _getColorForHydration(hydrationPercent).withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  void _drawSmileMouth(Canvas canvas, Offset center, double radius) {
    final mouthWidth = radius * 0.2;
    final mouthCenter = Offset(center.dx, center.dy + radius * 0.25);

    // "v" shape smile
    final path = Path();
    path.moveTo(mouthCenter.dx - mouthWidth, mouthCenter.dy);
    path.lineTo(mouthCenter.dx, mouthCenter.dy + mouthWidth * 0.4);
    path.lineTo(mouthCenter.dx + mouthWidth, mouthCenter.dy);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF051E3E).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawBlush(Canvas canvas, Offset center, double radius) {
    // Má hồng ở hai bên
    for (final side in [-1, 1]) {
      final blushCenter = Offset(
        center.dx + radius * 0.6 * side,
        center.dy + radius * 0.1,
      );

      canvas.drawOval(
        Rect.fromCenter(
          center: blushCenter,
          width: radius * 0.35,
          height: radius * 0.25,
        ),
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFB7C5).withOpacity(0.6),
              const Color(0xFFFFB7C5).withOpacity(0.0),
            ],
          ).createShader(
            Rect.fromCircle(center: blushCenter, radius: radius * 0.2),
          ),
      );
    }
  }

  Color _getColorForHydration(double percent) {
    if (percent > 0.75) {
      return const Color(0xFF2AF598);
    } else if (percent > 0.5) {
      return const Color(0xFF009EFD);
    } else if (percent > 0.25) {
      return const Color(0xFF7B9FFF);
    } else {
      return const Color(0xFFC5C5C5);
    }
  }

  @override
  bool shouldRepaint(PuruAxoPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.tailWagAngle != tailWagAngle ||
        oldDelegate.hydrationPercent != hydrationPercent;
  }
}

