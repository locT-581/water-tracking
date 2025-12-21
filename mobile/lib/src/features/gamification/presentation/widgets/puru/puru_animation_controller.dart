import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'puru_state.dart';
import 'puru_body_painter.dart';

/// Controller for all Puru animations
class PuruAnimationController extends ChangeNotifier {
  /// Breathing animation (continuous)
  late AnimationController _breathController;
  
  /// Floating animation (continuous)
  late AnimationController _floatController;
  
  /// Blinking animation (periodic)
  late AnimationController _blinkController;
  
  /// Wobble animation (continuous subtle)
  late AnimationController _wobbleController;
  
  /// Squish animation (on tap)
  late AnimationController _squishController;
  
  /// Bounce animation (celebration)
  late AnimationController _bounceController;
  
  /// Accessory animation
  late AnimationController _accessoryController;
  
  /// Eye tracking position
  double _eyeOffsetX = 0;
  double _eyeOffsetY = 0;
  
  /// Internal bubbles
  final List<PuruBubble> _bubbles = [];
  Timer? _bubbleTimer;
  
  /// Blink timer
  Timer? _blinkTimer;
  
  /// Current state
  PuruCompleteState _state = const PuruCompleteState(
    hydrationState: PuruHydrationState.good,
  );
  
  final TickerProvider _vsync;
  bool _isDisposed = false;
  
  PuruAnimationController({
    required TickerProvider vsync,
    PuruCompleteState? initialState,
  }) : _vsync = vsync {
    if (initialState != null) {
      _state = initialState;
    }
    _initAnimations();
    _initBubbles();
    _startBlinkTimer();
  }
  
  // Getters
  double get breathProgress => _breathController.value;
  double get floatOffset => math.sin(_floatController.value * math.pi * 2) * 8;
  double get blinkProgress => _blinkController.value;
  double get wobblePhase => _wobbleController.value * math.pi * 2;
  double get squishProgress => _squishController.value;
  double get bounceProgress => _bounceController.value;
  double get accessoryProgress => _accessoryController.value;
  double get eyeOffsetX => _eyeOffsetX;
  double get eyeOffsetY => _eyeOffsetY;
  List<PuruBubble> get bubbles => _bubbles;
  PuruCompleteState get state => _state;
  
  void _initAnimations() {
    // Breathing - slow continuous
    _breathController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    
    // Floating - very slow up/down
    _floatController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    
    // Blinking - triggered periodically
    _blinkController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 150),
    );
    
    // Wobble - subtle edge wobble
    _wobbleController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    // Squish - triggered on tap
    _squishController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 200),
    );
    
    // Bounce - for celebration
    _bounceController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 500),
    );
    
    // Accessory - continuous for animated accessories
    _accessoryController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    // Add listeners to notify
    _breathController.addListener(_onAnimationUpdate);
    _floatController.addListener(_onAnimationUpdate);
    _blinkController.addListener(_onAnimationUpdate);
    _wobbleController.addListener(_onAnimationUpdate);
    _squishController.addListener(_onAnimationUpdate);
    _bounceController.addListener(_onAnimationUpdate);
    _accessoryController.addListener(_onAnimationUpdate);
  }
  
  void _onAnimationUpdate() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
  
  void _initBubbles() {
    final random = math.Random();
    
    // Create initial bubbles
    for (int i = 0; i < 8; i++) {
      _bubbles.add(PuruBubble(
        x: (random.nextDouble() - 0.5) * 1.2,
        y: random.nextDouble() * 2 - 1,
        radius: 0.5 + random.nextDouble() * 0.8,
        velocity: 0.3 + random.nextDouble() * 0.4,
        opacity: 0.3 + random.nextDouble() * 0.4,
      ));
    }
    
    // Update bubbles periodically
    _bubbleTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      for (final bubble in _bubbles) {
        bubble.update(0.05);
      }
      notifyListeners();
    });
  }
  
  void _startBlinkTimer() {
    _blinkTimer?.cancel();
    
    // Random blink interval between 2-5 seconds
    final random = math.Random();
    final nextBlink = Duration(milliseconds: 2000 + random.nextInt(3000));
    
    _blinkTimer = Timer(nextBlink, () {
      if (_isDisposed) return;
      _blink();
      _startBlinkTimer(); // Schedule next blink
    });
  }
  
  /// Trigger a blink
  void _blink() {
    if (_state.expression == PuruExpression.joyful ||
        _state.expression == PuruExpression.sleepy) {
      // Don't blink if eyes already closed
      return;
    }
    
    _blinkController.forward().then((_) {
      if (!_isDisposed) {
        _blinkController.reverse();
      }
    });
  }
  
  /// Update Puru's state
  void updateState(PuruCompleteState newState) {
    final oldState = _state;
    _state = newState;
    
    // Trigger appropriate animations based on state change
    if (oldState.hydrationState != newState.hydrationState) {
      _onHydrationStateChanged(oldState.hydrationState, newState.hydrationState);
    }
    
    notifyListeners();
  }
  
  void _onHydrationStateChanged(
    PuruHydrationState oldState,
    PuruHydrationState newState,
  ) {
    // Adjust animation speeds based on new state
    if (newState == PuruHydrationState.hydrated) {
      // Faster, more energetic
      _floatController.duration = const Duration(milliseconds: 3000);
      _breathController.duration = const Duration(milliseconds: 2500);
      bounce(); // Celebration!
    } else if (newState == PuruHydrationState.dehydrated ||
               newState == PuruHydrationState.thirsty) {
      // Slower, sluggish
      _floatController.duration = const Duration(milliseconds: 6000);
      _breathController.duration = const Duration(milliseconds: 4000);
    } else if (newState == PuruHydrationState.sleeping) {
      // Very slow
      _floatController.duration = const Duration(milliseconds: 8000);
      _breathController.duration = const Duration(milliseconds: 5000);
    } else {
      // Normal
      _floatController.duration = const Duration(milliseconds: 4000);
      _breathController.duration = const Duration(milliseconds: 3000);
    }
  }
  
  /// Trigger squish animation (on tap)
  void squish() {
    _squishController.forward().then((_) {
      if (!_isDisposed) {
        _squishController.reverse();
      }
    });
  }
  
  /// Trigger bounce animation
  void bounce() {
    _bounceController.forward(from: 0).then((_) {
      if (!_isDisposed) {
        _bounceController.reverse();
      }
    });
  }
  
  /// Update eye tracking position (follow finger/cursor)
  void updateEyePosition(double x, double y) {
    _eyeOffsetX = x.clamp(-1.0, 1.0);
    _eyeOffsetY = y.clamp(-1.0, 1.0);
    notifyListeners();
  }
  
  /// Reset eye position to center
  void resetEyePosition() {
    _eyeOffsetX = 0;
    _eyeOffsetY = 0;
    notifyListeners();
  }
  
  /// Trigger specific action animation
  void playAction(PuruAction action) {
    switch (action) {
      case PuruAction.bounce:
        bounce();
        break;
      case PuruAction.jiggle:
        squish();
        break;
      case PuruAction.spin:
        // Could implement spin animation
        bounce();
        break;
      default:
        break;
    }
  }
  
  /// Play drinking animation sequence
  Future<void> playDrinkAnimation() async {
    // Squish down
    await _squishController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await _squishController.reverse();
    
    // Bounce up
    bounce();
  }
  
  /// Play celebration sequence
  Future<void> playCelebration() async {
    for (int i = 0; i < 3; i++) {
      bounce();
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
  }
  
  @override
  void dispose() {
    _isDisposed = true;
    _blinkTimer?.cancel();
    _bubbleTimer?.cancel();
    
    _breathController.dispose();
    _floatController.dispose();
    _blinkController.dispose();
    _wobbleController.dispose();
    _squishController.dispose();
    _bounceController.dispose();
    _accessoryController.dispose();
    
    super.dispose();
  }
}

/// Mixin to provide PuruAnimationController in widgets
mixin PuruAnimationMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  late PuruAnimationController puruController;
  
  @override
  void initState() {
    super.initState();
    puruController = PuruAnimationController(vsync: this);
  }
  
  @override
  void dispose() {
    puruController.dispose();
    super.dispose();
  }
  
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

