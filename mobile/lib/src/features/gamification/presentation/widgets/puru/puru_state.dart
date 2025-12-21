import 'package:flutter/material.dart';

/// Puru's hydration state - determines overall appearance
enum PuruHydrationState {
  /// 100%+ hydration - Glowing, floating, very happy
  hydrated,
  
  /// 75-99% - Normal, content
  good,
  
  /// 50-74% - Slightly concerned
  okay,
  
  /// 25-49% - Deflated, worried, grayish
  thirsty,
  
  /// 0-24% - Melting, purple-ish, holding SOS sign
  dehydrated,
  
  /// During sleep hours
  sleeping,
  
  /// Way over 100% - Bloated, dizzy, hiccup bubbles
  overHydrated,
}

/// Puru's emotional expressions
enum PuruExpression {
  /// Default neutral happy
  happy,
  
  /// Very happy, eyes closed with smile
  joyful,
  
  /// Excited, sparkly eyes
  excited,
  
  /// Confused, one eyebrow raised
  confused,
  
  /// Worried, slightly sad
  worried,
  
  /// Very sad, tears
  sad,
  
  /// Sleepy, half-closed eyes
  sleepy,
  
  /// Dizzy, spiral eyes
  dizzy,
  
  /// Determined, focused
  determined,
  
  /// Surprised, wide eyes
  surprised,
  
  /// Winking
  winking,
}

/// Puru's accessories based on context
enum PuruAccessory {
  none,
  
  /// For hot weather
  sunglasses,
  
  /// After workout
  dumbbells,
  
  /// For morning
  coffee,
  
  /// For dehydrated state
  sosSign,
  
  /// For achievements
  crown,
  
  /// For streak milestones
  medal,
  
  /// For night time
  sleepCap,
  
  /// For rainy weather
  umbrella,
  
  /// For cold weather
  scarf,
}

/// Puru's current animation action
enum PuruAction {
  /// Idle breathing/bobbing
  idle,
  
  /// Bouncing happily
  bounce,
  
  /// Floating up and down
  float,
  
  /// Spinning celebration
  spin,
  
  /// Jiggling/wobbling
  jiggle,
  
  /// Melting slowly
  melt,
  
  /// Drinking water
  drink,
  
  /// Sleeping zzz
  sleep,
  
  /// Wave hello
  wave,
  
  /// Hiccup (for over-hydrated)
  hiccup,
  
  /// Deflating
  deflate,
  
  /// Inflating
  inflate,
}

/// Complete state of Puru at any moment
class PuruCompleteState {
  final PuruHydrationState hydrationState;
  final PuruExpression expression;
  final PuruAccessory accessory;
  final PuruAction action;
  final double hydrationPercent;
  final String? customMessage;
  
  const PuruCompleteState({
    required this.hydrationState,
    this.expression = PuruExpression.happy,
    this.accessory = PuruAccessory.none,
    this.action = PuruAction.idle,
    this.hydrationPercent = 0.5,
    this.customMessage,
  });
  
  /// Create state from hydration percentage
  factory PuruCompleteState.fromHydration(
    double percent, {
    bool isSleeping = false,
    bool isHotWeather = false,
    bool justWorkedOut = false,
  }) {
    PuruHydrationState state;
    PuruExpression expression;
    PuruAccessory accessory = PuruAccessory.none;
    PuruAction action = PuruAction.idle;
    
    // Determine hydration state
    if (isSleeping) {
      state = PuruHydrationState.sleeping;
      expression = PuruExpression.sleepy;
      accessory = PuruAccessory.sleepCap;
      action = PuruAction.sleep;
    } else if (percent > 1.2) {
      state = PuruHydrationState.overHydrated;
      expression = PuruExpression.dizzy;
      action = PuruAction.hiccup;
    } else if (percent >= 1.0) {
      state = PuruHydrationState.hydrated;
      expression = PuruExpression.joyful;
      action = PuruAction.float;
      if (isHotWeather) accessory = PuruAccessory.sunglasses;
      if (justWorkedOut) accessory = PuruAccessory.dumbbells;
    } else if (percent >= 0.75) {
      state = PuruHydrationState.good;
      expression = PuruExpression.happy;
      action = PuruAction.bounce;
    } else if (percent >= 0.5) {
      state = PuruHydrationState.okay;
      expression = PuruExpression.happy;
      action = PuruAction.idle;
    } else if (percent >= 0.25) {
      state = PuruHydrationState.thirsty;
      expression = PuruExpression.worried;
      action = PuruAction.deflate;
    } else {
      state = PuruHydrationState.dehydrated;
      expression = PuruExpression.sad;
      accessory = PuruAccessory.sosSign;
      action = PuruAction.melt;
    }
    
    return PuruCompleteState(
      hydrationState: state,
      expression: expression,
      accessory: accessory,
      action: action,
      hydrationPercent: percent,
    );
  }
  
  /// Get Puru's body color based on state
  Color get bodyColor {
    switch (hydrationState) {
      case PuruHydrationState.hydrated:
        return const Color(0xFF2AF598); // Glowing cyan-green
      case PuruHydrationState.good:
        return const Color(0xFF4FC3F7); // Bright blue
      case PuruHydrationState.okay:
        return const Color(0xFF81D4FA); // Light blue
      case PuruHydrationState.thirsty:
        return const Color(0xFFB0BEC5); // Grayish blue
      case PuruHydrationState.dehydrated:
        return const Color(0xFF9575CD); // Purple-gray (medical signal)
      case PuruHydrationState.overHydrated:
        return const Color(0xFFE1F5FE); // Very pale blue
      case PuruHydrationState.sleeping:
        return const Color(0xFF90CAF9); // Soft blue
    }
  }
  
  /// Get glow color for body
  Color get glowColor {
    if (hydrationState == PuruHydrationState.hydrated) {
      return const Color(0xFF2AF598).withOpacity(0.6);
    }
    return bodyColor.withOpacity(0.3);
  }
  
  /// Get secondary/highlight color
  Color get highlightColor {
    return Colors.white.withOpacity(0.6);
  }
  
  /// Get Vietnamese message for current state
  String get messageVi {
    if (customMessage != null) return customMessage!;
    
    switch (hydrationState) {
      case PuruHydrationState.hydrated:
        return 'Tuyệt vời! Puru rất vui! 🎉';
      case PuruHydrationState.good:
        return 'Rất tốt! Còn một chút nữa thôi!';
      case PuruHydrationState.okay:
        return 'Cố lên! Bạn đang làm tốt lắm!';
      case PuruHydrationState.thirsty:
        return 'Puru hơi khát... uống nước đi nào!';
      case PuruHydrationState.dehydrated:
        return 'Ối! Puru cần nước gấp! 💧';
      case PuruHydrationState.overHydrated:
        return 'Hic... Puru uống hơi nhiều rồi! 😅';
      case PuruHydrationState.sleeping:
        return 'Zzz... Hẹn gặp lại sáng mai!';
    }
  }
  
  /// Get body deformation factor (1.0 = normal, < 1.0 = squished, > 1.0 = stretched)
  double get bodyDeformX {
    switch (hydrationState) {
      case PuruHydrationState.hydrated:
        return 1.0;
      case PuruHydrationState.good:
        return 1.0;
      case PuruHydrationState.okay:
        return 0.98;
      case PuruHydrationState.thirsty:
        return 1.1; // Wider but shorter
      case PuruHydrationState.dehydrated:
        return 1.3; // Melted - very wide
      case PuruHydrationState.overHydrated:
        return 1.15; // Bloated
      case PuruHydrationState.sleeping:
        return 1.05;
    }
  }
  
  double get bodyDeformY {
    switch (hydrationState) {
      case PuruHydrationState.hydrated:
        return 1.0;
      case PuruHydrationState.good:
        return 1.0;
      case PuruHydrationState.okay:
        return 0.98;
      case PuruHydrationState.thirsty:
        return 0.85; // Shorter
      case PuruHydrationState.dehydrated:
        return 0.6; // Very short - melted
      case PuruHydrationState.overHydrated:
        return 1.1; // Tall and bloated
      case PuruHydrationState.sleeping:
        return 0.9;
    }
  }
  
  PuruCompleteState copyWith({
    PuruHydrationState? hydrationState,
    PuruExpression? expression,
    PuruAccessory? accessory,
    PuruAction? action,
    double? hydrationPercent,
    String? customMessage,
  }) {
    return PuruCompleteState(
      hydrationState: hydrationState ?? this.hydrationState,
      expression: expression ?? this.expression,
      accessory: accessory ?? this.accessory,
      action: action ?? this.action,
      hydrationPercent: hydrationPercent ?? this.hydrationPercent,
      customMessage: customMessage ?? this.customMessage,
    );
  }
}

/// Type alias for backwards compatibility
typedef PuruState = PuruCompleteState;

