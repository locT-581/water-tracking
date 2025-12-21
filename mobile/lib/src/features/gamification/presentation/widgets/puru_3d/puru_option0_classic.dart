/// OPTION 0: "CLASSIC PURU" - Mascot gốc (DEFAULT)
/// 
/// Đây là mascot đầu tiên của SmartHydro - design đã được verified
/// Giữ lại để làm default option vì đã được yêu thích

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../puru/puru_state.dart';
import '../puru/puru_body_painter.dart';
import '../puru/puru_face_painter.dart';
import 'puru_3d_engine.dart';

/// Classic Puru Painter - Sử dụng lại logic từ mascot gốc
class PuruClassicPainter extends CustomPainter {
  final double animationValue;
  final JellyPhysics physics;
  final double hydrationPercent;
  final PuruExpression? expression;
  
  // Internal painters
  late final PuruBodyPainter _bodyPainter;
  late final PuruFacePainter _facePainter;

  PuruClassicPainter({
    required this.animationValue,
    required this.physics,
    required this.hydrationPercent,
    this.expression,
  }) {
    // Determine state from hydration
    final state = _getStateFromHydration(hydrationPercent);
    final actualExpression = expression ?? _getExpressionFromState(state);
    
    _bodyPainter = PuruBodyPainter(
      state: state,
      animationProgress: animationValue,
      jellyOffsets: physics.vertices.map((v) => v.offset).toList(),
    );
    
    _facePainter = PuruFacePainter(
      expression: actualExpression,
      blinkProgress: (math.sin(animationValue * math.pi * 2) + 1) / 2,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Use original painters
    _bodyPainter.paint(canvas, size);
    _facePainter.paint(canvas, size);
  }

  PuruState _getStateFromHydration(double percent) {
    return PuruCompleteState.fromHydration(percent);
  }

  PuruExpression _getExpressionFromState(PuruState state) {
    return switch (state.hydrationState) {
      PuruHydrationState.hydrated => PuruExpression.joyful,
      PuruHydrationState.good => PuruExpression.happy,
      PuruHydrationState.okay => PuruExpression.confused,
      PuruHydrationState.thirsty => PuruExpression.worried,
      PuruHydrationState.dehydrated => PuruExpression.sad,
      PuruHydrationState.overHydrated => PuruExpression.dizzy,
      PuruHydrationState.sleeping => PuruExpression.sleepy,
    };
  }

  @override
  bool shouldRepaint(PuruClassicPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.hydrationPercent != hydrationPercent ||
        oldDelegate.expression != expression;
  }
}

