/// Mascot Factory - Tạo painters cho mascots
/// 
/// Factory Pattern để dễ dàng tạo CustomPainter tương ứng với từng mascot type

import 'package:flutter/material.dart';
import '../models/mascot_models.dart';
import '../../presentation/widgets/puru_3d/puru_3d_engine.dart';
import '../../presentation/widgets/puru_3d/puru_option0_classic.dart';
import '../../presentation/widgets/puru_3d/puru_option1_celestial_v2.dart';
import '../../presentation/widgets/puru_3d/puru_option2_axo_v2.dart';
import '../../presentation/widgets/puru_3d/puru_option3_chibi_bot_v2.dart';

/// Factory để tạo CustomPainter cho mascots
class MascotFactory {
  // Private constructor
  MascotFactory._();
  
  /// Create painter for a mascot type
  static CustomPainter createPainter({
    required MascotType type,
    required double animationValue,
    required JellyPhysics physics,
    required double hydrationPercent,
    Map<String, dynamic>? extraParams,
  }) {
    switch (type) {
      case MascotType.aquaAxo:
        // Classic Puru (Original)
        return PuruClassicPainter(
          animationValue: animationValue,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.celestialDrop:
        // Celestial Drop V2
        return PuruCelestialV2Painter(
          animationValue: animationValue,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.liquidChibiBot:
        // Liquid Chibi-Bot V2
        return PuruChibiBotV2Painter(
          animationValue: animationValue,
          hueShift: (extraParams?['hueShift'] as double?) ?? 0.0,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      // Wave 2: Seasonal & Achievement Mascots
      case MascotType.coralGuardian:
        // TODO: Implement Coral Guardian painter
        // For now, use Celestial as placeholder
        return PuruCelestialV2Painter(
          animationValue: animationValue,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.glacierSpirit:
        // TODO: Implement Glacier Spirit painter
        // For now, use Celestial as placeholder
        return PuruCelestialV2Painter(
          animationValue: animationValue,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.lavaDrop:
        // TODO: Implement Lava Drop painter
        // For now, use Aqua-Axo as placeholder
        return PuruAxoV2Painter(
          animationValue: animationValue,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.tsunamiTitan:
        // TODO: Implement Tsunami Titan painter
        // For now, use Chibi-Bot as placeholder
        return PuruChibiBotV2Painter(
          animationValue: animationValue,
          hueShift: (extraParams?['hueShift'] as double?) ?? 0.0,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      // Wave 3: Premium & Special Edition
      case MascotType.royalAquamarine:
        // TODO: Implement Royal Aquamarine painter
        // For now, use Chibi-Bot as placeholder
        return PuruChibiBotV2Painter(
          animationValue: animationValue,
          hueShift: (extraParams?['hueShift'] as double?) ?? 270.0, // Purple hue
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.spookySplash:
        // TODO: Implement Spooky Splash painter
        // For now, use Classic with orange tint
        return PuruClassicPainter(
          animationValue: animationValue,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.lunarDragon:
        // TODO: Implement Lunar Dragon painter
        // For now, use Aqua-Axo as placeholder
        return PuruAxoV2Painter(
          animationValue: animationValue,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
    }
  }
  
  /// Get required extra params for a mascot type
  static Map<String, dynamic> getDefaultExtraParams(MascotType type) {
    switch (type) {
      case MascotType.liquidChibiBot:
      case MascotType.tsunamiTitan:
      case MascotType.royalAquamarine:
        return {'hueShift': 0.0};
      
      default:
        return {};
    }
  }
  
  /// Check if mascot type needs hue shift animation
  static bool needsHueShift(MascotType type) {
    return type == MascotType.liquidChibiBot ||
        type == MascotType.tsunamiTitan ||
        type == MascotType.royalAquamarine;
  }
}

/// Widget wrapper for mascot painter
class MascotWidget extends StatefulWidget {
  final MascotType type;
  final double size;
  final double hydrationPercent;
  final VoidCallback? onTap;
  
  const MascotWidget({
    super.key,
    required this.type,
    required this.size,
    required this.hydrationPercent,
    this.onTap,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _hueController;
  late JellyPhysics _physics;

  @override
  void initState() {
    super.initState();
    
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _hueController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _physics = JellyPhysics(vertexCount: 20);
    
    // Physics update loop
    _startPhysicsLoop();
  }

  void _startPhysicsLoop() {
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(milliseconds: 16));
      if (mounted) {
        setState(() {
          _physics.update(0.016);
        });
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _hueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanDown: (details) {
        // Apply force on tap
        final localPos = details.localPosition;
        _physics.applyForceAtPosition(
          localPos,
          const Offset(0, 5),
          List.generate(
            20,
            (i) => Offset(widget.size / 2, widget.size / 2),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _breathingController,
          if (MascotFactory.needsHueShift(widget.type)) _hueController,
        ]),
        builder: (context, child) {
          final extraParams = MascotFactory.needsHueShift(widget.type)
              ? {'hueShift': _hueController.value * 360}
              : null;
          
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: MascotFactory.createPainter(
              type: widget.type,
              animationValue: _breathingController.value,
              physics: _physics,
              hydrationPercent: widget.hydrationPercent,
              extraParams: extraParams,
            ),
          );
        },
      ),
    );
  }
}

/// Mini version of mascot widget (for list/grid)
class MascotMiniWidget extends StatelessWidget {
  final MascotType type;
  final double size;
  final double hydrationPercent;
  
  const MascotMiniWidget({
    super.key,
    required this.type,
    this.size = 60,
    this.hydrationPercent = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: MascotWidget(
        type: type,
        size: size,
        hydrationPercent: hydrationPercent,
      ),
    );
  }
}

