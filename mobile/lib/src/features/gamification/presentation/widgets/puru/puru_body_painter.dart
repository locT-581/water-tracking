import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'puru_state.dart';
import 'puru_colors.dart';

/// Internal bubble for Puru's body
class PuruBubble {
  double x; // -1 to 1 relative position
  double y;
  double radius;
  double velocity;
  double opacity;
  
  PuruBubble({
    required this.x,
    required this.y,
    required this.radius,
    this.velocity = 0.5,
    this.opacity = 0.5,
  });
  
  void update(double dt) {
    y -= velocity * dt;
    // Wiggle horizontally
    x += math.sin(y * 10) * 0.01;
    // Reset if out of bounds
    if (y < -1) {
      y = 1;
      x = (math.Random().nextDouble() - 0.5) * 1.2;
    }
    // Clamp x
    x = x.clamp(-0.8, 0.8);
  }
}

/// Painter for Puru's body (water blob)
class PuruBodyPainter extends CustomPainter {
  final PuruState state;
  final double animationProgress; // 0 to 1, breathing animation
  final List<Offset> jellyOffsets; // Jelly physics offsets
  
  // Legacy support
  double breathProgress; // 0 to 1, breathing animation
  double squishProgress; // 0 to 1, squish when tapped
  double bounceProgress; // 0 to 1, bouncing animation
  double floatOffset; // vertical offset for floating
  double wobblePhase; // for wobbly edges
  List<PuruBubble> bubbles;
  
  PuruBodyPainter({
    required this.state,
    this.animationProgress = 0,
    this.jellyOffsets = const [],
    this.breathProgress = 0,
    this.squishProgress = 0,
    this.bounceProgress = 0,
    this.floatOffset = 0,
    this.wobblePhase = 0,
    this.bubbles = const [],
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2 + floatOffset;
    final baseRadius = math.min(size.width, size.height) * 0.35;
    
    // Apply breathing effect
    final breathScale = 1 + math.sin(breathProgress * math.pi * 2) * 0.03;
    
    // Apply squish effect
    final squishX = 1 + squishProgress * 0.2;
    final squishY = 1 - squishProgress * 0.15;
    
    // Apply state deformation
    final deformX = state.bodyDeformX * breathScale * squishX;
    final deformY = state.bodyDeformY * breathScale * squishY;
    
    final radiusX = baseRadius * deformX;
    final radiusY = baseRadius * deformY;
    
    // Draw shadow
    _drawShadow(canvas, Offset(centerX, centerY + radiusY + 10), radiusX * 0.8);
    
    // Draw glow effect for hydrated state
    if (state.hydrationState == PuruHydrationState.hydrated) {
      _drawGlow(canvas, Offset(centerX, centerY), radiusX * 1.3, state.glowColor);
    }
    
    // Draw main body
    _drawBody(canvas, Offset(centerX, centerY), radiusX, radiusY);
    
    // Draw internal bubbles
    _drawBubbles(canvas, Offset(centerX, centerY), radiusX, radiusY);
    
    // Draw highlight/shine
    _drawHighlight(canvas, Offset(centerX, centerY), radiusX, radiusY);
  }
  
  void _drawShadow(Canvas canvas, Offset center, double radius) {
    final shadowPaint = Paint()
      ..color = PuruColors.shadowLight
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 0.3,
      ),
      shadowPaint,
    );
  }
  
  void _drawGlow(Canvas canvas, Offset center, double radius, Color glowColor) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          glowColor,
          glowColor.withOpacity(0),
        ],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, glowPaint);
  }
  
  void _drawBody(Canvas canvas, Offset center, double radiusX, double radiusY) {
    final bodyColor = state.bodyColor;
    
    // Create wobbly path for organic feel
    final path = _createWobblyOval(center, radiusX, radiusY);
    
    // Gradient fill
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _lightenColor(bodyColor, 0.2),
          bodyColor,
          _darkenColor(bodyColor, 0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCenter(
        center: center,
        width: radiusX * 2,
        height: radiusY * 2,
      ));
    
    canvas.drawPath(path, gradientPaint);
    
    // Subtle outline
    final outlinePaint = Paint()
      ..color = _darkenColor(bodyColor, 0.2).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    canvas.drawPath(path, outlinePaint);
  }
  
  Path _createWobblyOval(Offset center, double radiusX, double radiusY) {
    final path = Path();
    const segments = 36;
    
    for (int i = 0; i <= segments; i++) {
      final angle = (i / segments) * math.pi * 2;
      
      // Add wobble based on phase
      final wobble = math.sin(angle * 3 + wobblePhase) * 0.02;
      final rx = radiusX * (1 + wobble);
      final ry = radiusY * (1 + wobble);
      
      final x = center.dx + rx * math.cos(angle);
      final y = center.dy + ry * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Use quadratic bezier for smoother curves
        final prevAngle = ((i - 1) / segments) * math.pi * 2;
        final midAngle = (angle + prevAngle) / 2;
        
        final midWobble = math.sin(midAngle * 3 + wobblePhase) * 0.02;
        final midRx = radiusX * (1 + midWobble) * 1.02;
        final midRy = radiusY * (1 + midWobble) * 1.02;
        
        final ctrlX = center.dx + midRx * math.cos(midAngle);
        final ctrlY = center.dy + midRy * math.sin(midAngle);
        
        path.quadraticBezierTo(ctrlX, ctrlY, x, y);
      }
    }
    
    path.close();
    return path;
  }
  
  void _drawBubbles(Canvas canvas, Offset center, double radiusX, double radiusY) {
    if (bubbles.isEmpty) return;
    
    final bubblePaint = Paint()..style = PaintingStyle.fill;
    
    for (final bubble in bubbles) {
      // Only draw if inside the body
      final bx = center.dx + bubble.x * radiusX * 0.7;
      final by = center.dy + bubble.y * radiusY * 0.7;
      
      // Check if inside body bounds (approximate)
      final normalizedX = (bx - center.dx) / radiusX;
      final normalizedY = (by - center.dy) / radiusY;
      if (normalizedX * normalizedX + normalizedY * normalizedY > 0.8) continue;
      
      final bubbleRadius = bubble.radius * radiusX * 0.08;
      
      // Bubble gradient
      bubblePaint.shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          Colors.white.withOpacity(bubble.opacity * 0.8),
          Colors.white.withOpacity(bubble.opacity * 0.2),
        ],
      ).createShader(Rect.fromCircle(center: Offset(bx, by), radius: bubbleRadius));
      
      canvas.drawCircle(Offset(bx, by), bubbleRadius, bubblePaint);
    }
  }
  
  void _drawHighlight(Canvas canvas, Offset center, double radiusX, double radiusY) {
    // Main top-left highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -0.5),
        radius: 0.8,
        colors: [
          PuruColors.bodyShine,
          Colors.white.withOpacity(0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCenter(
        center: center,
        width: radiusX * 2,
        height: radiusY * 2,
      ));
    
    // Create highlight path (elliptical arc in top-left)
    final highlightPath = Path();
    final highlightCenterX = center.dx - radiusX * 0.35;
    final highlightCenterY = center.dy - radiusY * 0.35;
    final highlightRadiusX = radiusX * 0.4;
    final highlightRadiusY = radiusY * 0.3;
    
    highlightPath.addOval(Rect.fromCenter(
      center: Offset(highlightCenterX, highlightCenterY),
      width: highlightRadiusX * 2,
      height: highlightRadiusY * 2,
    ));
    
    canvas.drawPath(highlightPath, highlightPaint);
    
    // Secondary smaller highlight
    final secondaryPaint = Paint()
      ..color = Colors.white.withOpacity(0.6);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx - radiusX * 0.15,
          center.dy - radiusY * 0.55,
        ),
        width: radiusX * 0.15,
        height: radiusY * 0.1,
      ),
      secondaryPaint,
    );
  }
  
  Color _lightenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red + (255 - color.red) * amount).round().clamp(0, 255),
      (color.green + (255 - color.green) * amount).round().clamp(0, 255),
      (color.blue + (255 - color.blue) * amount).round().clamp(0, 255),
    );
  }
  
  Color _darkenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - amount)).round().clamp(0, 255),
      (color.green * (1 - amount)).round().clamp(0, 255),
      (color.blue * (1 - amount)).round().clamp(0, 255),
    );
  }
  
  @override
  bool shouldRepaint(covariant PuruBodyPainter oldDelegate) {
    return state.hydrationState != oldDelegate.state.hydrationState ||
        breathProgress != oldDelegate.breathProgress ||
        squishProgress != oldDelegate.squishProgress ||
        bounceProgress != oldDelegate.bounceProgress ||
        floatOffset != oldDelegate.floatOffset ||
        wobblePhase != oldDelegate.wobblePhase ||
        bubbles.length != oldDelegate.bubbles.length;
  }
}

