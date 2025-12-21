import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradient utilities for SmartHydro
/// 
/// Following "Fluid & Organic" design philosophy with smooth gradient transitions
class AppGradients {
  AppGradients._();

  // ============== PRIMARY GRADIENTS ==============
  
  /// Main hydration gradient: #2AF598 → #009EFD
  static const LinearGradient primary = LinearGradient(
    colors: [
      AppColors.hydroStart,
      AppColors.hydroEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Reversed primary gradient for variety
  static const LinearGradient primaryReversed = LinearGradient(
    colors: [
      AppColors.hydroEnd,
      AppColors.hydroStart,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Horizontal primary gradient
  static const LinearGradient primaryHorizontal = LinearGradient(
    colors: [
      AppColors.hydroStart,
      AppColors.hydroEnd,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Vertical primary gradient
  static const LinearGradient primaryVertical = LinearGradient(
    colors: [
      AppColors.hydroStart,
      AppColors.hydroEnd,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============== TIME-BASED GRADIENTS ==============
  
  /// Morning gradient (6AM - 12PM): Fresh, awakening
  static const LinearGradient morning = LinearGradient(
    colors: [
      Color(0xFFFFA07A), // Light Salmon
      Color(0xFFFFD700), // Gold
      Color(0xFF87CEEB), // Sky Blue
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  /// Afternoon gradient (12PM - 6PM): Bright, energetic
  static const LinearGradient afternoon = LinearGradient(
    colors: [
      Color(0xFF87CEEB), // Sky Blue
      Color(0xFF00BFFF), // Deep Sky Blue
      Color(0xFF1E90FF), // Dodger Blue
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Evening gradient (6PM - 9PM): Warm, relaxing
  static const LinearGradient evening = LinearGradient(
    colors: [
      Color(0xFFFF6B6B), // Coral Red
      Color(0xFFFF8E53), // Sunset Orange
      Color(0xFFFFCA85), // Peach
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Night gradient (9PM - 6AM): Deep, calm
  static const LinearGradient night = LinearGradient(
    colors: [
      Color(0xFF0F2027), // Midnight Blue
      Color(0xFF203A43), // Deep Ocean
      Color(0xFF2C5364), // Dark Teal
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============== STATUS GRADIENTS ==============
  
  /// Success gradient (for achievements, milestones)
  static const LinearGradient success = LinearGradient(
    colors: [
      Color(0xFF56CCF2), // Light Blue
      AppColors.success,
      Color(0xFF0BAE5D), // Dark Green
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warning gradient (for low hydration)
  static const LinearGradient warning = LinearGradient(
    colors: [
      Color(0xFFFFC837), // Light Yellow
      AppColors.warning,
      Color(0xFFFFAA00), // Dark Yellow
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Danger gradient (for critical low hydration)
  static const LinearGradient danger = LinearGradient(
    colors: [
      Color(0xFFFF6B6B), // Light Red
      AppColors.danger,
      Color(0xFFCC0000), // Dark Red
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Science gradient (for Science Hub)
  static const LinearGradient science = LinearGradient(
    colors: [
      Color(0xFF7E57C2), // Light Purple
      AppColors.science,
      Color(0xFF4527A0), // Dark Purple
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============== SPECIAL EFFECT GRADIENTS ==============
  
  /// Glass overlay gradient (for glassmorphism)
  static LinearGradient glass({double opacity = 0.15}) {
    return LinearGradient(
      colors: [
        Colors.white.withOpacity(opacity),
        Colors.white.withOpacity(opacity * 0.5),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Shimmer gradient (for loading states)
  static const LinearGradient shimmer = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  /// Overlay gradient (for image overlays)
  static LinearGradient overlay({
    Color color = Colors.black,
    double opacity = 0.5,
  }) {
    return LinearGradient(
      colors: [
        color.withOpacity(0),
        color.withOpacity(opacity),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  // ============== HELPER METHODS ==============
  
  /// Get time-based gradient based on current hour
  static LinearGradient getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      return morning;
    } else if (hour >= 12 && hour < 18) {
      return afternoon;
    } else if (hour >= 18 && hour < 21) {
      return evening;
    } else {
      return night;
    }
  }

  /// Get hydration level gradient (based on percentage)
  static LinearGradient getHydrationGradient(double percentage) {
    if (percentage >= 1.0) {
      return success; // Over-hydrated or perfect
    } else if (percentage >= 0.75) {
      return primary; // Good hydration
    } else if (percentage >= 0.50) {
      return warning; // Low hydration
    } else {
      return danger; // Critical hydration
    }
  }

  /// Create a custom gradient with two colors
  static LinearGradient custom({
    required Color startColor,
    required Color endColor,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: [startColor, endColor],
      begin: begin,
      end: end,
    );
  }
}

/// Gradient decoration shortcuts
class GradientDecoration {
  /// Create BoxDecoration with gradient
  static BoxDecoration box({
    required Gradient gradient,
    double borderRadius = 0,
    Color? borderColor,
    double borderWidth = 0,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
      boxShadow: boxShadow,
    );
  }

  /// Create ShapeDecoration with gradient
  static ShapeDecoration shape({
    required Gradient gradient,
    required ShapeBorder shape,
    List<BoxShadow>? shadows,
  }) {
    return ShapeDecoration(
      gradient: gradient,
      shape: shape,
      shadows: shadows,
    );
  }

  /// Colored shadow matching gradient
  static List<BoxShadow> coloredShadow({
    required Color color,
    double blur = 20,
    double spread = 0,
    Offset offset = const Offset(0, 10),
    double opacity = 0.3,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blur,
        spreadRadius: spread,
        offset: offset,
      ),
    ];
  }
}

