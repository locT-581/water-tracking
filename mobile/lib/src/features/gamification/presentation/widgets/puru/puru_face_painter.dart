import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'puru_state.dart';
import 'puru_colors.dart';

/// Painter for Puru's face expressions
class PuruFacePainter extends CustomPainter {
  final PuruExpression expression;
  final double blinkProgress; // 0 = open, 1 = closed
  final double eyeOffsetX; // -1 to 1 for looking direction
  final double eyeOffsetY;
  final double mouthOpenness; // 0 = closed, 1 = fully open
  
  PuruFacePainter({
    required this.expression,
    this.blinkProgress = 0,
    this.eyeOffsetX = 0,
    this.eyeOffsetY = 0,
    this.mouthOpenness = 0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.width / 100; // Base scale for 100x100
    
    // Eye positions
    final leftEyeCenter = Offset(centerX - 15 * scale, centerY - 5 * scale);
    final rightEyeCenter = Offset(centerX + 15 * scale, centerY - 5 * scale);
    final eyeRadius = 10 * scale;
    
    // Draw eyes based on expression
    _drawEye(canvas, leftEyeCenter, eyeRadius, isLeft: true);
    _drawEye(canvas, rightEyeCenter, eyeRadius, isLeft: false);
    
    // Draw mouth
    _drawMouth(canvas, Offset(centerX, centerY + 15 * scale), scale);
    
    // Draw blush if applicable
    if (expression == PuruExpression.joyful || 
        expression == PuruExpression.excited ||
        expression == PuruExpression.happy) {
      _drawBlush(canvas, leftEyeCenter, rightEyeCenter, scale);
    }
    
    // Draw tears if sad
    if (expression == PuruExpression.sad) {
      _drawTears(canvas, leftEyeCenter, rightEyeCenter, scale);
    }
    
    // Draw sweat drop if worried
    if (expression == PuruExpression.worried) {
      _drawSweatDrop(canvas, rightEyeCenter, scale);
    }
    
    // Draw spiral eyes if dizzy
    if (expression == PuruExpression.dizzy) {
      _drawSpiralOverEyes(canvas, leftEyeCenter, rightEyeCenter, eyeRadius);
    }
    
    // Draw sparkles if excited
    if (expression == PuruExpression.excited) {
      _drawSparkles(canvas, leftEyeCenter, rightEyeCenter, scale);
    }
  }
  
  void _drawEye(Canvas canvas, Offset center, double radius, {required bool isLeft}) {
    final eyePaint = Paint()..style = PaintingStyle.fill;
    
    // Pupil offset based on look direction
    final pupilOffset = Offset(
      eyeOffsetX * radius * 0.3,
      eyeOffsetY * radius * 0.3,
    );
    
    if (expression == PuruExpression.sleepy || blinkProgress > 0.8) {
      // Half-closed sleepy eyes - draw as line
      final linePaint = Paint()
        ..color = PuruColors.eyeBlack
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.4
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(
        Offset(center.dx - radius * 0.6, center.dy),
        Offset(center.dx + radius * 0.6, center.dy),
        linePaint,
      );
      return;
    }
    
    if (expression == PuruExpression.joyful) {
      // Happy closed eyes - curved lines
      final path = Path();
      path.moveTo(center.dx - radius * 0.7, center.dy + radius * 0.2);
      path.quadraticBezierTo(
        center.dx, center.dy - radius * 0.5,
        center.dx + radius * 0.7, center.dy + radius * 0.2,
      );
      
      final linePaint = Paint()
        ..color = PuruColors.eyeBlack
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.3
        ..strokeCap = StrokeCap.round;
      
      canvas.drawPath(path, linePaint);
      return;
    }
    
    if (expression == PuruExpression.winking && !isLeft) {
      // Winking right eye
      final linePaint = Paint()
        ..color = PuruColors.eyeBlack
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.3
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(
        Offset(center.dx - radius * 0.5, center.dy),
        Offset(center.dx + radius * 0.5, center.dy),
        linePaint,
      );
      return;
    }
    
    // Calculate eye squeeze based on blink
    final eyeHeight = radius * (1 - blinkProgress * 0.9);
    
    // Eye white
    eyePaint.color = PuruColors.eyeWhite;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: eyeHeight * 2,
      ),
      eyePaint,
    );
    
    // Eye outline
    final outlinePaint = Paint()
      ..color = PuruColors.eyeBlack.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: eyeHeight * 2,
      ),
      outlinePaint,
    );
    
    // Pupil (black part)
    final pupilRadius = radius * 0.6;
    final pupilCenter = center + pupilOffset;
    eyePaint.color = PuruColors.eyeBlack;
    canvas.drawCircle(pupilCenter, pupilRadius * (1 - blinkProgress * 0.5), eyePaint);
    
    // Eye highlight (white reflection)
    eyePaint.color = PuruColors.eyeHighlight;
    final highlightOffset = Offset(-radius * 0.25, -radius * 0.25);
    canvas.drawCircle(
      pupilCenter + highlightOffset,
      radius * 0.2 * (1 - blinkProgress),
      eyePaint,
    );
    
    // Small secondary highlight
    canvas.drawCircle(
      pupilCenter + Offset(radius * 0.15, radius * 0.15),
      radius * 0.1 * (1 - blinkProgress),
      eyePaint,
    );
    
    // Surprised expression - larger eyes
    if (expression == PuruExpression.surprised) {
      // Draw additional eye widening effect
      final widePaint = Paint()
        ..color = PuruColors.eyeWhite
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2.3,
          height: eyeHeight * 2.3,
        ),
        widePaint,
      );
    }
  }
  
  void _drawMouth(Canvas canvas, Offset center, double scale) {
    final mouthPaint = Paint()
      ..color = PuruColors.eyeBlack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    
    switch (expression) {
      case PuruExpression.happy:
      case PuruExpression.excited:
        // Simple smile curve
        path.moveTo(center.dx - 10 * scale, center.dy);
        path.quadraticBezierTo(
          center.dx, center.dy + 8 * scale,
          center.dx + 10 * scale, center.dy,
        );
        break;
        
      case PuruExpression.joyful:
        // Big open smile
        mouthPaint.style = PaintingStyle.fill;
        path.moveTo(center.dx - 12 * scale, center.dy - 2 * scale);
        path.quadraticBezierTo(
          center.dx, center.dy + 12 * scale,
          center.dx + 12 * scale, center.dy - 2 * scale,
        );
        path.close();
        break;
        
      case PuruExpression.worried:
      case PuruExpression.sad:
        // Frown
        path.moveTo(center.dx - 8 * scale, center.dy + 3 * scale);
        path.quadraticBezierTo(
          center.dx, center.dy - 5 * scale,
          center.dx + 8 * scale, center.dy + 3 * scale,
        );
        break;
        
      case PuruExpression.confused:
        // Wavy/uncertain mouth
        path.moveTo(center.dx - 10 * scale, center.dy);
        path.quadraticBezierTo(
          center.dx - 5 * scale, center.dy - 4 * scale,
          center.dx, center.dy,
        );
        path.quadraticBezierTo(
          center.dx + 5 * scale, center.dy + 4 * scale,
          center.dx + 10 * scale, center.dy,
        );
        break;
        
      case PuruExpression.sleepy:
        // Small open mouth (yawn-ish)
        mouthPaint.style = PaintingStyle.fill;
        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: 8 * scale,
            height: 6 * scale * (0.5 + mouthOpenness * 0.5),
          ),
          mouthPaint,
        );
        return;
        
      case PuruExpression.dizzy:
        // Wobbly confused mouth
        path.moveTo(center.dx - 8 * scale, center.dy + 2 * scale);
        path.lineTo(center.dx + 8 * scale, center.dy - 2 * scale);
        break;
        
      case PuruExpression.surprised:
        // O-shaped surprised mouth
        mouthPaint.style = PaintingStyle.fill;
        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: 10 * scale,
            height: 14 * scale,
          ),
          mouthPaint,
        );
        return;
        
      case PuruExpression.determined:
        // Firm line
        path.moveTo(center.dx - 8 * scale, center.dy);
        path.lineTo(center.dx + 8 * scale, center.dy);
        break;
        
      case PuruExpression.winking:
        // Cheeky smile
        path.moveTo(center.dx - 10 * scale, center.dy);
        path.quadraticBezierTo(
          center.dx, center.dy + 10 * scale,
          center.dx + 10 * scale, center.dy - 2 * scale,
        );
        break;
    }
    
    canvas.drawPath(path, mouthPaint);
  }
  
  void _drawBlush(Canvas canvas, Offset leftEye, Offset rightEye, double scale) {
    final blushPaint = Paint()
      ..color = PuruColors.blush
      ..style = PaintingStyle.fill;
    
    // Left cheek
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(leftEye.dx - 8 * scale, leftEye.dy + 15 * scale),
        width: 10 * scale,
        height: 6 * scale,
      ),
      blushPaint,
    );
    
    // Right cheek
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(rightEye.dx + 8 * scale, rightEye.dy + 15 * scale),
        width: 10 * scale,
        height: 6 * scale,
      ),
      blushPaint,
    );
  }
  
  void _drawTears(Canvas canvas, Offset leftEye, Offset rightEye, double scale) {
    final tearPaint = Paint()
      ..color = PuruColors.tear
      ..style = PaintingStyle.fill;
    
    // Tear drop shape
    final tearPath = Path();
    
    // Left tear
    final leftTearStart = Offset(leftEye.dx, leftEye.dy + 12 * scale);
    tearPath.moveTo(leftTearStart.dx, leftTearStart.dy);
    tearPath.quadraticBezierTo(
      leftTearStart.dx - 4 * scale, leftTearStart.dy + 8 * scale,
      leftTearStart.dx, leftTearStart.dy + 15 * scale,
    );
    tearPath.quadraticBezierTo(
      leftTearStart.dx + 4 * scale, leftTearStart.dy + 8 * scale,
      leftTearStart.dx, leftTearStart.dy,
    );
    
    canvas.drawPath(tearPath, tearPaint);
    
    // Right tear
    tearPath.reset();
    final rightTearStart = Offset(rightEye.dx, rightEye.dy + 12 * scale);
    tearPath.moveTo(rightTearStart.dx, rightTearStart.dy);
    tearPath.quadraticBezierTo(
      rightTearStart.dx - 4 * scale, rightTearStart.dy + 8 * scale,
      rightTearStart.dx, rightTearStart.dy + 15 * scale,
    );
    tearPath.quadraticBezierTo(
      rightTearStart.dx + 4 * scale, rightTearStart.dy + 8 * scale,
      rightTearStart.dx, rightTearStart.dy,
    );
    
    canvas.drawPath(tearPath, tearPaint);
  }
  
  void _drawSweatDrop(Canvas canvas, Offset rightEye, double scale) {
    final sweatPaint = Paint()
      ..color = PuruColors.tear.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final sweatStart = Offset(rightEye.dx + 18 * scale, rightEye.dy - 10 * scale);
    final path = Path();
    path.moveTo(sweatStart.dx, sweatStart.dy);
    path.quadraticBezierTo(
      sweatStart.dx - 4 * scale, sweatStart.dy + 8 * scale,
      sweatStart.dx, sweatStart.dy + 12 * scale,
    );
    path.quadraticBezierTo(
      sweatStart.dx + 4 * scale, sweatStart.dy + 8 * scale,
      sweatStart.dx, sweatStart.dy,
    );
    
    canvas.drawPath(path, sweatPaint);
  }
  
  void _drawSpiralOverEyes(Canvas canvas, Offset leftEye, Offset rightEye, double radius) {
    final spiralPaint = Paint()
      ..color = PuruColors.eyeBlack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Draw spirals
    for (final eyeCenter in [leftEye, rightEye]) {
      final path = Path();
      for (double t = 0; t < 4 * math.pi; t += 0.1) {
        final r = radius * 0.1 * t / math.pi;
        final x = eyeCenter.dx + r * math.cos(t);
        final y = eyeCenter.dy + r * math.sin(t);
        if (t == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, spiralPaint);
    }
  }
  
  void _drawSparkles(Canvas canvas, Offset leftEye, Offset rightEye, double scale) {
    final sparklePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    
    // Four-pointed star sparkle
    void drawSparkle(Offset center, double size) {
      final path = Path();
      path.moveTo(center.dx, center.dy - size);
      path.lineTo(center.dx + size * 0.3, center.dy);
      path.lineTo(center.dx + size, center.dy);
      path.lineTo(center.dx + size * 0.3, center.dy);
      path.lineTo(center.dx, center.dy + size);
      path.lineTo(center.dx - size * 0.3, center.dy);
      path.lineTo(center.dx - size, center.dy);
      path.lineTo(center.dx - size * 0.3, center.dy);
      path.close();
      canvas.drawPath(path, sparklePaint);
    }
    
    drawSparkle(Offset(leftEye.dx - 15 * scale, leftEye.dy - 15 * scale), 4 * scale);
    drawSparkle(Offset(rightEye.dx + 15 * scale, rightEye.dy - 12 * scale), 3 * scale);
    drawSparkle(Offset(leftEye.dx + 5 * scale, leftEye.dy - 20 * scale), 2 * scale);
  }
  
  @override
  bool shouldRepaint(covariant PuruFacePainter oldDelegate) {
    return expression != oldDelegate.expression ||
        blinkProgress != oldDelegate.blinkProgress ||
        eyeOffsetX != oldDelegate.eyeOffsetX ||
        eyeOffsetY != oldDelegate.eyeOffsetY ||
        mouthOpenness != oldDelegate.mouthOpenness;
  }
}

