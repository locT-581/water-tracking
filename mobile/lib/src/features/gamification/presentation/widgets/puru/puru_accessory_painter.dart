import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'puru_state.dart';
import 'puru_colors.dart';

/// Painter for Puru's accessories
class PuruAccessoryPainter extends CustomPainter {
  final PuruAccessory accessory;
  final double animationProgress; // For accessory-specific animations
  
  PuruAccessoryPainter({
    required this.accessory,
    this.animationProgress = 0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.width / 100;
    
    switch (accessory) {
      case PuruAccessory.none:
        break;
      case PuruAccessory.sunglasses:
        _drawSunglasses(canvas, Offset(centerX, centerY - 5 * scale), scale);
        break;
      case PuruAccessory.dumbbells:
        _drawDumbbells(canvas, Offset(centerX, centerY), scale);
        break;
      case PuruAccessory.coffee:
        _drawCoffeeCup(canvas, Offset(centerX + 30 * scale, centerY + 10 * scale), scale);
        break;
      case PuruAccessory.sosSign:
        _drawSOSSign(canvas, Offset(centerX + 35 * scale, centerY - 20 * scale), scale);
        break;
      case PuruAccessory.crown:
        _drawCrown(canvas, Offset(centerX, centerY - 40 * scale), scale);
        break;
      case PuruAccessory.medal:
        _drawMedal(canvas, Offset(centerX, centerY + 25 * scale), scale);
        break;
      case PuruAccessory.sleepCap:
        _drawSleepCap(canvas, Offset(centerX, centerY - 35 * scale), scale);
        break;
      case PuruAccessory.umbrella:
        _drawUmbrella(canvas, Offset(centerX + 35 * scale, centerY - 30 * scale), scale);
        break;
      case PuruAccessory.scarf:
        _drawScarf(canvas, Offset(centerX, centerY + 20 * scale), scale);
        break;
    }
  }
  
  void _drawSunglasses(Canvas canvas, Offset center, double scale) {
    final framePaint = Paint()
      ..color = PuruColors.sunglassesFrame
      ..style = PaintingStyle.fill;
    
    final lensPaint = Paint()
      ..color = PuruColors.sunglassesLens
      ..style = PaintingStyle.fill;
    
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Left lens
    final leftLensRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - 15 * scale, center.dy),
        width: 18 * scale,
        height: 14 * scale,
      ),
      Radius.circular(4 * scale),
    );
    
    // Right lens
    final rightLensRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 15 * scale, center.dy),
        width: 18 * scale,
        height: 14 * scale,
      ),
      Radius.circular(4 * scale),
    );
    
    // Draw lenses
    canvas.drawRRect(leftLensRect, lensPaint);
    canvas.drawRRect(rightLensRect, lensPaint);
    
    // Draw frames
    framePaint.style = PaintingStyle.stroke;
    framePaint.strokeWidth = 2.5 * scale;
    canvas.drawRRect(leftLensRect, framePaint);
    canvas.drawRRect(rightLensRect, framePaint);
    
    // Bridge
    final bridgePath = Path();
    bridgePath.moveTo(center.dx - 6 * scale, center.dy);
    bridgePath.quadraticBezierTo(
      center.dx, center.dy - 3 * scale,
      center.dx + 6 * scale, center.dy,
    );
    canvas.drawPath(bridgePath, framePaint);
    
    // Temples (arms)
    canvas.drawLine(
      Offset(center.dx - 24 * scale, center.dy),
      Offset(center.dx - 35 * scale, center.dy - 5 * scale),
      framePaint,
    );
    canvas.drawLine(
      Offset(center.dx + 24 * scale, center.dy),
      Offset(center.dx + 35 * scale, center.dy - 5 * scale),
      framePaint,
    );
    
    // Shine on lenses
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 18 * scale, center.dy - 3 * scale),
        width: 4 * scale,
        height: 6 * scale,
      ),
      shinePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 12 * scale, center.dy - 3 * scale),
        width: 4 * scale,
        height: 6 * scale,
      ),
      shinePaint,
    );
  }
  
  void _drawDumbbells(Canvas canvas, Offset center, double scale) {
    final metalPaint = Paint()
      ..color = PuruColors.dumbbellMetal
      ..style = PaintingStyle.fill;
    
    final weightPaint = Paint()
      ..color = PuruColors.dumbbellWeight
      ..style = PaintingStyle.fill;
    
    // Animation: slight rotation based on progress
    final angle = math.sin(animationProgress * math.pi * 2) * 0.1;
    
    canvas.save();
    canvas.translate(center.dx + 38 * scale, center.dy);
    canvas.rotate(angle);
    
    // Bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: 25 * scale,
          height: 4 * scale,
        ),
        Radius.circular(2 * scale),
      ),
      metalPaint,
    );
    
    // Weights
    for (final dx in [-10 * scale, 10 * scale]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(dx, 0),
            width: 6 * scale,
            height: 14 * scale,
          ),
          Radius.circular(2 * scale),
        ),
        weightPaint,
      );
    }
    
    canvas.restore();
  }
  
  void _drawCoffeeCup(Canvas canvas, Offset center, double scale) {
    final cupPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    
    final coffeePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.fill;
    
    // Cup body
    final cupPath = Path();
    cupPath.moveTo(center.dx - 8 * scale, center.dy - 10 * scale);
    cupPath.lineTo(center.dx - 6 * scale, center.dy + 10 * scale);
    cupPath.quadraticBezierTo(
      center.dx, center.dy + 14 * scale,
      center.dx + 6 * scale, center.dy + 10 * scale,
    );
    cupPath.lineTo(center.dx + 8 * scale, center.dy - 10 * scale);
    cupPath.close();
    
    canvas.drawPath(cupPath, cupPaint);
    
    // Coffee inside
    final coffeePath = Path();
    coffeePath.moveTo(center.dx - 7 * scale, center.dy - 6 * scale);
    coffeePath.lineTo(center.dx - 5.5 * scale, center.dy + 8 * scale);
    coffeePath.quadraticBezierTo(
      center.dx, center.dy + 11 * scale,
      center.dx + 5.5 * scale, center.dy + 8 * scale,
    );
    coffeePath.lineTo(center.dx + 7 * scale, center.dy - 6 * scale);
    coffeePath.close();
    
    canvas.drawPath(coffeePath, coffeePaint);
    
    // Handle
    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    
    final handlePath = Path();
    handlePath.moveTo(center.dx + 8 * scale, center.dy - 5 * scale);
    handlePath.quadraticBezierTo(
      center.dx + 15 * scale, center.dy,
      center.dx + 8 * scale, center.dy + 5 * scale,
    );
    
    canvas.drawPath(handlePath, handlePaint);
    
    // Steam
    final steamPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 3; i++) {
      final steamPath = Path();
      final startX = center.dx + (i - 1) * 4 * scale;
      final offset = math.sin(animationProgress * math.pi * 2 + i) * 2 * scale;
      
      steamPath.moveTo(startX, center.dy - 12 * scale);
      steamPath.quadraticBezierTo(
        startX + offset, center.dy - 18 * scale,
        startX, center.dy - 24 * scale,
      );
      
      canvas.drawPath(steamPath, steamPaint);
    }
  }
  
  void _drawSOSSign(Canvas canvas, Offset center, double scale) {
    // Sign background
    final signPaint = Paint()
      ..color = PuruColors.sosWhite
      ..style = PaintingStyle.fill;
    
    final signRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: 35 * scale,
        height: 18 * scale,
      ),
      Radius.circular(4 * scale),
    );
    
    canvas.drawRRect(signRect, signPaint);
    
    // Red border
    final borderPaint = Paint()
      ..color = PuruColors.sosRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    
    canvas.drawRRect(signRect, borderPaint);
    
    // SOS text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'SOS',
        style: TextStyle(
          color: PuruColors.sosRed,
          fontSize: 10 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
    
    // Stick
    final stickPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(center.dx - 15 * scale, center.dy + 9 * scale),
      Offset(center.dx - 25 * scale, center.dy + 30 * scale),
      stickPaint,
    );
  }
  
  void _drawCrown(Canvas canvas, Offset center, double scale) {
    final crownPaint = Paint()
      ..color = PuruColors.crownGold
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    // Crown base
    path.moveTo(center.dx - 20 * scale, center.dy + 10 * scale);
    path.lineTo(center.dx - 18 * scale, center.dy - 5 * scale);
    path.lineTo(center.dx - 10 * scale, center.dy + 2 * scale);
    path.lineTo(center.dx, center.dy - 10 * scale);
    path.lineTo(center.dx + 10 * scale, center.dy + 2 * scale);
    path.lineTo(center.dx + 18 * scale, center.dy - 5 * scale);
    path.lineTo(center.dx + 20 * scale, center.dy + 10 * scale);
    path.close();
    
    canvas.drawPath(path, crownPaint);
    
    // Jewels
    final jewelPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(center.dx, center.dy - 3 * scale), 3 * scale, jewelPaint);
    
    jewelPaint.color = Colors.blue;
    canvas.drawCircle(Offset(center.dx - 12 * scale, center.dy + 2 * scale), 2 * scale, jewelPaint);
    canvas.drawCircle(Offset(center.dx + 12 * scale, center.dy + 2 * scale), 2 * scale, jewelPaint);
    
    // Shine
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 8 * scale, center.dy - 2 * scale),
        width: 6 * scale,
        height: 4 * scale,
      ),
      shinePaint,
    );
  }
  
  void _drawMedal(Canvas canvas, Offset center, double scale) {
    // Ribbon
    final ribbonPaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..style = PaintingStyle.fill;
    
    final ribbonPath = Path();
    ribbonPath.moveTo(center.dx - 8 * scale, center.dy - 15 * scale);
    ribbonPath.lineTo(center.dx - 6 * scale, center.dy);
    ribbonPath.lineTo(center.dx + 6 * scale, center.dy);
    ribbonPath.lineTo(center.dx + 8 * scale, center.dy - 15 * scale);
    ribbonPath.close();
    
    canvas.drawPath(ribbonPath, ribbonPaint);
    
    // Medal
    final medalPaint = Paint()
      ..color = PuruColors.medalGold
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 10 * scale, medalPaint);
    
    // Medal rim
    final rimPaint = Paint()
      ..color = const Color(0xFFFF8F00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    
    canvas.drawCircle(center, 8 * scale, rimPaint);
    
    // Star in center
    final starPaint = Paint()
      ..color = const Color(0xFFFFE082)
      ..style = PaintingStyle.fill;
    
    _drawStar(canvas, center, 5 * scale, starPaint);
  }
  
  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    final innerRadius = radius * 0.4;
    
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : innerRadius;
      final angle = (i * math.pi / points) - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  void _drawSleepCap(Canvas canvas, Offset center, double scale) {
    final capPaint = Paint()
      ..color = PuruColors.sleepCapBlue
      ..style = PaintingStyle.fill;
    
    // Cap body (triangle-ish)
    final capPath = Path();
    capPath.moveTo(center.dx - 25 * scale, center.dy + 15 * scale);
    capPath.quadraticBezierTo(
      center.dx - 10 * scale, center.dy - 10 * scale,
      center.dx + 30 * scale, center.dy - 20 * scale,
    );
    capPath.quadraticBezierTo(
      center.dx + 10 * scale, center.dy + 5 * scale,
      center.dx + 25 * scale, center.dy + 15 * scale,
    );
    capPath.close();
    
    canvas.drawPath(capPath, capPaint);
    
    // Pom-pom at tip
    final pomPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(center.dx + 30 * scale, center.dy - 20 * scale),
      6 * scale,
      pomPaint,
    );
    
    // Rim
    final rimPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + 15 * scale),
          width: 55 * scale,
          height: 8 * scale,
        ),
        Radius.circular(4 * scale),
      ),
      rimPaint,
    );
  }
  
  void _drawUmbrella(Canvas canvas, Offset center, double scale) {
    // Handle
    final handlePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx, center.dy + 40 * scale),
      handlePaint,
    );
    
    // Hook at bottom
    final hookPath = Path();
    hookPath.moveTo(center.dx, center.dy + 40 * scale);
    hookPath.quadraticBezierTo(
      center.dx - 8 * scale, center.dy + 45 * scale,
      center.dx - 8 * scale, center.dy + 38 * scale,
    );
    canvas.drawPath(hookPath, handlePaint);
    
    // Canopy
    final canopyPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.fill;
    
    final canopyPath = Path();
    canopyPath.moveTo(center.dx - 25 * scale, center.dy);
    canopyPath.quadraticBezierTo(
      center.dx, center.dy - 25 * scale,
      center.dx + 25 * scale, center.dy,
    );
    canopyPath.close();
    
    canvas.drawPath(canopyPath, canopyPaint);
    
    // Canopy segments
    final segmentPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 4; i++) {
      if (i % 2 == 0) {
        final segPath = Path();
        final startX = center.dx - 25 * scale + i * 12.5 * scale;
        final endX = startX + 12.5 * scale;
        final midX = (startX + endX) / 2;
        
        segPath.moveTo(startX, center.dy);
        segPath.quadraticBezierTo(
          midX, center.dy - 20 * scale,
          endX, center.dy,
        );
        segPath.close();
        
        canvas.drawPath(segPath, segmentPaint);
      }
    }
  }
  
  void _drawScarf(Canvas canvas, Offset center, double scale) {
    final scarfPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;
    
    // Main scarf wrap
    final wrapPath = Path();
    wrapPath.moveTo(center.dx - 30 * scale, center.dy - 5 * scale);
    wrapPath.quadraticBezierTo(
      center.dx, center.dy + 8 * scale,
      center.dx + 30 * scale, center.dy - 5 * scale,
    );
    wrapPath.quadraticBezierTo(
      center.dx, center.dy + 15 * scale,
      center.dx - 30 * scale, center.dy - 5 * scale,
    );
    
    canvas.drawPath(wrapPath, scarfPaint);
    
    // Hanging end
    final endPath = Path();
    endPath.moveTo(center.dx + 15 * scale, center.dy + 5 * scale);
    endPath.quadraticBezierTo(
      center.dx + 25 * scale, center.dy + 25 * scale,
      center.dx + 15 * scale, center.dy + 40 * scale,
    );
    endPath.lineTo(center.dx + 25 * scale, center.dy + 40 * scale);
    endPath.quadraticBezierTo(
      center.dx + 35 * scale, center.dy + 25 * scale,
      center.dx + 25 * scale, center.dy + 5 * scale,
    );
    endPath.close();
    
    canvas.drawPath(endPath, scarfPaint);
    
    // Stripes
    final stripePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    
    canvas.drawLine(
      Offset(center.dx - 20 * scale, center.dy + 2 * scale),
      Offset(center.dx + 20 * scale, center.dy + 2 * scale),
      stripePaint,
    );
    
    canvas.drawLine(
      Offset(center.dx + 18 * scale, center.dy + 15 * scale),
      Offset(center.dx + 22 * scale, center.dy + 35 * scale),
      stripePaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant PuruAccessoryPainter oldDelegate) {
    return accessory != oldDelegate.accessory ||
        animationProgress != oldDelegate.animationProgress;
  }
}

