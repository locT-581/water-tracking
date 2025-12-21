/// OPTION 2: "AQUA-AXO" V2 - Redesigned (Đơn giản & Đáng yêu hơn)
/// 
/// Giọt nước tròn với 2 vây tai nhỏ và đuôi ngắn gọn

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'puru_3d_engine.dart';

class PuruAxoV2Painter extends CustomPainter {
  final double animationValue;
  final JellyPhysics physics;
  final double hydrationPercent;

  PuruAxoV2Painter({
    required this.animationValue,
    required this.physics,
    required this.hydrationPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.33;
    
    // Breathing
    final breathScale = 1.0 + math.sin(animationValue * math.pi * 2) * 0.05;
    final radius = baseRadius * breathScale;

    // 1. Shadow
    _drawShadow(canvas, center, radius);

    // 2. Đuôi nhỏ (vẽ trước)
    _drawSimpleTail(canvas, center, radius);

    // 3. Main body - Tròn mập mạp
    _drawRoundBody(canvas, center, radius);

    // 4. 2 vây tai nhỏ (đơn giản)
    _drawSimpleGills(canvas, center, radius);

    // 5. Bọt khí (ít hơn)
    _drawFewBubbles(canvas, center, radius);

    // 6. Wide-set eyes (đặc trưng)
    _drawWideEyes(canvas, center, radius);

    // 7. Miệng "v" smile
    _drawVSmile(canvas, center, radius);

    // 8. Má hồng
    _drawBlush(canvas, center, radius);
  }

  void _drawShadow(Canvas canvas, Offset center, double radius) {
    final shadowCenter = Offset(center.dx, center.dy + radius * 1.3);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: radius * 1.6,
        height: radius * 0.4,
      ),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: shadowCenter, radius: radius * 0.8),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
  }

  void _drawSimpleTail(Canvas canvas, Offset center, double radius) {
    // Đuôi ngắn, đơn giản
    final tailStart = Offset(center.dx, center.dy + radius * 0.6);
    final tailWag = math.sin(animationValue * math.pi * 4) * 0.1;
    
    final path = Path();
    path.moveTo(tailStart.dx, tailStart.dy);
    
    // Curve to tail tip
    final tailEnd = Offset(
      tailStart.dx + tailWag * radius,
      tailStart.dy + radius * 0.4,
    );
    
    path.quadraticBezierTo(
      tailStart.dx + tailWag * radius * 0.5,
      tailStart.dy + radius * 0.2,
      tailEnd.dx,
      tailEnd.dy,
    );

    // Fan shape
    path.lineTo(tailEnd.dx + radius * 0.15, tailEnd.dy);
    path.lineTo(tailEnd.dx - radius * 0.15, tailEnd.dy);
    path.lineTo(tailStart.dx, tailStart.dy);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getColorForHydration(),
            _getColorForHydration().withOpacity(0.5),
          ],
        ).createShader(path.getBounds()),
    );
  }

  void _drawRoundBody(Canvas canvas, Offset center, double radius) {
    // Hình tròn đơn giản
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          colors: [
            Colors.white.withOpacity(0.3),
            _getColorForHydration().withOpacity(0.8),
            _getColorForHydration(),
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius),
        ),
    );

    // Soft glow
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _getColorForHydration().withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
  }

  void _drawSimpleGills(Canvas canvas, Offset center, double radius) {
    // Chỉ 2 vây nhỏ, đơn giản ở 2 bên
    for (final side in [-1, 1]) {
      final gillBase = Offset(
        center.dx + radius * 0.8 * side,
        center.dy - radius * 0.2,
      );

      // Wiggle animation
      final wiggle = math.sin(animationValue * math.pi * 2) * 0.1;
      final angle = (side > 0 ? 0.0 : math.pi) + wiggle;

      // Simple 3-finger gill
      for (int i = 0; i < 3; i++) {
        final fingerAngle = angle + (i - 1) * 0.2 * side;
        final fingerLength = radius * 0.25 * (0.8 + i * 0.1);
        
        final fingerTip = Offset(
          gillBase.dx + math.cos(fingerAngle) * fingerLength,
          gillBase.dy + math.sin(fingerAngle) * fingerLength * 0.5,
        );

        canvas.drawLine(
          gillBase,
          fingerTip,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getColorForHydration().withOpacity(0.7),
                _getColorForHydration().withOpacity(0.2),
              ],
            ).createShader(Rect.fromPoints(gillBase, fingerTip))
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  void _drawFewBubbles(Canvas canvas, Offset center, double radius) {
    // Chỉ 3 bong bóng
    final bubbles = [
      (offset: Offset(0.2, -0.1), size: 0.08),
      (offset: Offset(-0.25, 0.15), size: 0.1),
      (offset: Offset(0.1, 0.25), size: 0.06),
    ];

    for (final bubble in bubbles) {
      final bubblePos = Offset(
        center.dx + bubble.offset.dx * radius,
        center.dy + bubble.offset.dy * radius +
            math.sin(animationValue * math.pi * 2 + bubble.offset.dx) * 3,
      );
      final bubbleRadius = bubble.size * radius;

      canvas.drawCircle(
        bubblePos,
        bubbleRadius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.1),
            ],
          ).createShader(
            Rect.fromCircle(center: bubblePos, radius: bubbleRadius),
          ),
      );

      // Highlight
      canvas.drawCircle(
        Offset(
          bubblePos.dx - bubbleRadius * 0.3,
          bubblePos.dy - bubbleRadius * 0.3,
        ),
        bubbleRadius * 0.4,
        Paint()..color = Colors.white.withOpacity(0.7),
      );
    }
  }

  void _drawWideEyes(Canvas canvas, Offset center, double radius) {
    // Mắt cách xa - đặc trưng
    final eyeRadius = radius * 0.15;
    final eyeSpacing = radius * 0.75; // Wide!

    for (final side in [-1, 1]) {
      final eyeCenter = Offset(
        center.dx + eyeSpacing * side,
        center.dy - radius * 0.2,
      );

      // Eye white
      canvas.drawCircle(
        eyeCenter,
        eyeRadius,
        Paint()..color = Colors.white.withOpacity(0.95),
      );

      // Iris
      canvas.drawCircle(
        eyeCenter,
        eyeRadius * 0.6,
        Paint()..color = const Color(0xFF1A1A2E),
      );

      // Highlight
      canvas.drawCircle(
        Offset(
          eyeCenter.dx - eyeRadius * 0.3,
          eyeCenter.dy - eyeRadius * 0.3,
        ),
        eyeRadius * 0.35,
        Paint()..color = Colors.white.withOpacity(0.8),
      );
    }
  }

  void _drawVSmile(Canvas canvas, Offset center, double radius) {
    final mouthWidth = radius * 0.15;
    final mouthCenter = Offset(center.dx, center.dy + radius * 0.2);

    // "v" shape
    final path = Path();
    path.moveTo(mouthCenter.dx - mouthWidth, mouthCenter.dy);
    path.lineTo(mouthCenter.dx, mouthCenter.dy + mouthWidth * 0.4);
    path.lineTo(mouthCenter.dx + mouthWidth, mouthCenter.dy);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF051E3E).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawBlush(Canvas canvas, Offset center, double radius) {
    for (final side in [-1, 1]) {
      final blushCenter = Offset(
        center.dx + radius * 0.55 * side,
        center.dy + radius * 0.05,
      );

      canvas.drawOval(
        Rect.fromCenter(
          center: blushCenter,
          width: radius * 0.3,
          height: radius * 0.2,
        ),
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFB7C5).withOpacity(0.5),
              const Color(0xFFFFB7C5).withOpacity(0.0),
            ],
          ).createShader(
            Rect.fromCircle(center: blushCenter, radius: radius * 0.15),
          ),
      );
    }
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
  bool shouldRepaint(PuruAxoV2Painter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.hydrationPercent != hydrationPercent;
  }
}

