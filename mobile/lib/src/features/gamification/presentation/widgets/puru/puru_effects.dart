import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Hiccup bubbles effect for over-hydrated state
class HiccupBubblesEffect extends StatefulWidget {
  final bool isActive;
  final double size;
  
  const HiccupBubblesEffect({
    super.key,
    required this.isActive,
    this.size = 100,
  });
  
  @override
  State<HiccupBubblesEffect> createState() => _HiccupBubblesEffectState();
}

class _HiccupBubblesEffectState extends State<HiccupBubblesEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_HiccupBubble> _bubbles = [];
  final _random = math.Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    
    if (widget.isActive) {
      _startEffect();
    }
  }
  
  @override
  void didUpdateWidget(HiccupBubblesEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startEffect();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _bubbles.clear();
    }
  }
  
  void _startEffect() {
    _spawnBubble();
    _controller.repeat();
  }
  
  void _spawnBubble() {
    if (!widget.isActive) return;
    
    _bubbles.add(_HiccupBubble(
      x: 0.5 + (_random.nextDouble() - 0.5) * 0.3,
      startY: 0.4,
      size: 0.1 + _random.nextDouble() * 0.1,
      speed: 0.5 + _random.nextDouble() * 0.3,
    ));
    
    // Clean up old bubbles
    _bubbles.removeWhere((b) => b.y < -0.5);
    
    // Schedule next bubble
    Future.delayed(
      Duration(milliseconds: 800 + _random.nextInt(400)),
      _spawnBubble,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Update bubble positions
    for (final bubble in _bubbles) {
      bubble.y -= bubble.speed * 0.016; // ~60fps
      bubble.wobble = math.sin(_controller.value * math.pi * 4 + bubble.x * 10) * 0.05;
    }
    
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _HiccupBubblesPainter(bubbles: _bubbles),
    );
  }
}

class _HiccupBubble {
  double x;
  double y;
  double size;
  double speed;
  double wobble;
  
  _HiccupBubble({
    required this.x,
    required double startY,
    required this.size,
    required this.speed,
  }) : y = startY, wobble = 0;
}

class _HiccupBubblesPainter extends CustomPainter {
  final List<_HiccupBubble> bubbles;
  
  _HiccupBubblesPainter({required this.bubbles});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final opacity = ((bubble.y + 0.5) / 0.9).clamp(0.0, 1.0);
      
      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.6)
        ..style = PaintingStyle.fill;
      
      final x = (bubble.x + bubble.wobble) * size.width;
      final y = bubble.y * size.height;
      final radius = bubble.size * size.width * 0.5;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
      
      // Highlight
      paint.color = Colors.white.withOpacity(opacity * 0.8);
      canvas.drawCircle(
        Offset(x - radius * 0.3, y - radius * 0.3),
        radius * 0.3,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant _HiccupBubblesPainter oldDelegate) => true;
}

/// Sleep Zzz effect for sleeping state
class SleepZzzEffect extends StatefulWidget {
  final bool isActive;
  final double size;
  
  const SleepZzzEffect({
    super.key,
    required this.isActive,
    this.size = 100,
  });
  
  @override
  State<SleepZzzEffect> createState() => _SleepZzzEffectState();
}

class _SleepZzzEffectState extends State<SleepZzzEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    if (widget.isActive) {
      _controller.repeat();
    }
  }
  
  @override
  void didUpdateWidget(SleepZzzEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SleepZzzPainter(progress: _controller.value),
        );
      },
    );
  }
}

class _SleepZzzPainter extends CustomPainter {
  final double progress;
  
  _SleepZzzPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    // Draw 3 Z's at different phases
    for (int i = 0; i < 3; i++) {
      final phase = (progress + i * 0.33) % 1.0;
      final opacity = math.sin(phase * math.pi).clamp(0.0, 1.0);
      
      final baseX = size.width * 0.6;
      final baseY = size.height * 0.2;
      
      final x = baseX + i * size.width * 0.1 + phase * size.width * 0.15;
      final y = baseY - phase * size.height * 0.3;
      final scale = 0.8 + i * 0.2;
      
      textPainter.text = TextSpan(
        text: 'Z',
        style: TextStyle(
          color: Colors.white.withOpacity(opacity * 0.8),
          fontSize: size.width * 0.15 * scale,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }
  
  @override
  bool shouldRepaint(covariant _SleepZzzPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

/// Glow effect for hydrated state
class HydrationGlowEffect extends StatefulWidget {
  final bool isActive;
  final Color color;
  final double size;
  
  const HydrationGlowEffect({
    super.key,
    required this.isActive,
    this.color = const Color(0xFF2AF598),
    this.size = 100,
  });
  
  @override
  State<HydrationGlowEffect> createState() => _HydrationGlowEffectState();
}

class _HydrationGlowEffectState extends State<HydrationGlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }
  
  @override
  void didUpdateWidget(HydrationGlowEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final glowIntensity = 0.3 + _controller.value * 0.4;
        final glowSize = 1.0 + _controller.value * 0.15;
        
        return Container(
          width: widget.size * glowSize,
          height: widget.size * glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(glowIntensity),
                blurRadius: widget.size * 0.4,
                spreadRadius: widget.size * 0.1,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Water drip effect for dehydrated state
class WaterDripEffect extends StatefulWidget {
  final bool isActive;
  final double size;
  
  const WaterDripEffect({
    super.key,
    required this.isActive,
    this.size = 100,
  });
  
  @override
  State<WaterDripEffect> createState() => _WaterDripEffectState();
}

class _WaterDripEffectState extends State<WaterDripEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_WaterDrip> _drips = [];
  final _random = math.Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        if (mounted) setState(() {});
      });
    
    if (widget.isActive) {
      _startEffect();
    }
  }
  
  @override
  void didUpdateWidget(WaterDripEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startEffect();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _drips.clear();
    }
  }
  
  void _startEffect() {
    _spawnDrip();
    _controller.repeat();
  }
  
  void _spawnDrip() {
    if (!widget.isActive) return;
    
    _drips.add(_WaterDrip(
      x: 0.3 + _random.nextDouble() * 0.4,
      y: 0.7,
      speed: 0.3 + _random.nextDouble() * 0.2,
    ));
    
    _drips.removeWhere((d) => d.y > 1.3);
    
    Future.delayed(
      Duration(milliseconds: 1500 + _random.nextInt(1000)),
      _spawnDrip,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    for (final drip in _drips) {
      drip.y += drip.speed * 0.02;
      drip.stretch = math.min(1.0, drip.stretch + 0.05);
    }
    
    return CustomPaint(
      size: Size(widget.size, widget.size * 1.5),
      painter: _WaterDripPainter(drips: _drips),
    );
  }
}

class _WaterDrip {
  double x;
  double y;
  double speed;
  double stretch;
  
  _WaterDrip({
    required this.x,
    required this.y,
    required this.speed,
  }) : stretch = 0;
}

class _WaterDripPainter extends CustomPainter {
  final List<_WaterDrip> drips;
  
  _WaterDripPainter({required this.drips});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final drip in drips) {
      final opacity = (1.0 - (drip.y - 0.7) / 0.6).clamp(0.0, 1.0);
      
      final paint = Paint()
        ..color = const Color(0xFF9575CD).withOpacity(opacity * 0.7)
        ..style = PaintingStyle.fill;
      
      final x = drip.x * size.width;
      final y = drip.y * size.height;
      
      // Teardrop shape
      final path = Path();
      final dropSize = size.width * 0.05;
      
      path.moveTo(x, y - dropSize * (1 + drip.stretch));
      path.quadraticBezierTo(
        x + dropSize, y,
        x, y + dropSize,
      );
      path.quadraticBezierTo(
        x - dropSize, y,
        x, y - dropSize * (1 + drip.stretch),
      );
      
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _WaterDripPainter oldDelegate) => true;
}

/// Sparkle effect for celebrations
class SparkleEffect extends StatefulWidget {
  final bool isActive;
  final double size;
  final Color color;
  
  const SparkleEffect({
    super.key,
    required this.isActive,
    this.size = 100,
    this.color = const Color(0xFFFFD700),
  });
  
  @override
  State<SparkleEffect> createState() => _SparkleEffectState();
}

class _SparkleEffectState extends State<SparkleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Sparkle> _sparkles = [];
  final _random = math.Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        if (mounted) setState(() {});
      });
    
    if (widget.isActive) {
      _startEffect();
    }
  }
  
  @override
  void didUpdateWidget(SparkleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startEffect();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }
  
  void _startEffect() {
    _sparkles.clear();
    
    // Spawn multiple sparkles
    for (int i = 0; i < 8; i++) {
      _sparkles.add(_Sparkle(
        x: 0.2 + _random.nextDouble() * 0.6,
        y: 0.2 + _random.nextDouble() * 0.6,
        size: 0.05 + _random.nextDouble() * 0.1,
        rotation: _random.nextDouble() * math.pi,
        delay: _random.nextDouble() * 0.5,
      ));
    }
    
    _controller.forward(from: 0);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _SparklePainter(
        sparkles: _sparkles,
        progress: _controller.value,
        color: widget.color,
      ),
    );
  }
}

class _Sparkle {
  double x;
  double y;
  double size;
  double rotation;
  double delay;
  
  _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.rotation,
    required this.delay,
  });
}

class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final double progress;
  final Color color;
  
  _SparklePainter({
    required this.sparkles,
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final sparkle in sparkles) {
      final adjustedProgress = ((progress - sparkle.delay) / (1 - sparkle.delay))
          .clamp(0.0, 1.0);
      
      if (adjustedProgress <= 0) continue;
      
      final opacity = math.sin(adjustedProgress * math.pi);
      final scale = 0.5 + adjustedProgress * 0.5;
      
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      
      final x = sparkle.x * size.width;
      final y = sparkle.y * size.height;
      final sparkleSize = sparkle.size * size.width * scale;
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(sparkle.rotation + adjustedProgress * math.pi);
      
      // Four-pointed star
      final path = Path();
      path.moveTo(0, -sparkleSize);
      path.lineTo(sparkleSize * 0.2, 0);
      path.lineTo(sparkleSize, 0);
      path.lineTo(sparkleSize * 0.2, 0);
      path.lineTo(0, sparkleSize);
      path.lineTo(-sparkleSize * 0.2, 0);
      path.lineTo(-sparkleSize, 0);
      path.lineTo(-sparkleSize * 0.2, 0);
      path.close();
      
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }
  
  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

