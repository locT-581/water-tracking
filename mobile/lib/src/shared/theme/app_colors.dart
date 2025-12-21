import 'package:flutter/material.dart';

/// SmartHydro Color Palette
/// Based on "Liquid Life" concept - Gradient-based, water-inspired colors
class AppColors {
  AppColors._();

  // Primary Colors (Hydro Blue Gradient)
  static const Color hydroStart = Color(0xFF2AF598); // Turquoise - Fresh, Vitality
  static const Color hydroEnd = Color(0xFF009EFD);   // Ocean Blue - Depth, Trust

  // Gradient
  static const LinearGradient hydroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [hydroStart, hydroEnd],
  );

  static const LinearGradient hydroGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [hydroStart, hydroEnd],
  );

  // Text & Elements
  static const Color deepOcean = Color(0xFF051E3E); // Dark blue-black for text

  // Functional Colors
  static const Color success = Color(0xFF00C853);   // Green - Goal complete
  static const Color warning = Color(0xFFFFD600);   // Amber - Mild dehydration
  static const Color danger = Color(0xFFFF3D00);    // Red-Orange - Severe dehydration
  static const Color science = Color(0xFF651FFF);   // Violet - Blog/Knowledge

  // Background Colors
  static const Color lightBackground = Color(0xFFF0F8FF); // Alice Blue
  static const Color darkBackground = Color(0xFF001220);  // Deep night blue
  static const Color darkSurface = Color(0xFF0A2540);     // Slightly lighter for cards

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Puru (Buddy) State Colors
  static const Color puruHydrated = Color(0xFF2AF598);    // Bright, glowing
  static const Color puruGood = Color(0xFF4FC3F7);        // Normal blue
  static const Color puruOkay = Color(0xFF81D4FA);        // Lighter blue
  static const Color puruThirsty = Color(0xFFB0BEC5);     // Grayish blue
  static const Color puruDehydrated = Color(0xFF9575CD); // Purple-gray
  static const Color puruOverhydrated = Color(0xFFE1F5FE); // Pale blue

  // Beverage Type Colors
  static const Color beverageWater = Color(0xFF2196F3);
  static const Color beverageCoffee = Color(0xFF795548);
  static const Color beverageTea = Color(0xFF8D6E63);
  static const Color beverageMilk = Color(0xFFFFFDE7);
  static const Color beverageJuice = Color(0xFFFF9800);
  static const Color beverageSoda = Color(0xFFF44336);
  static const Color beverageAlcohol = Color(0xFF9C27B0);
  static const Color beverageCoconut = Color(0xFF4CAF50);
  static const Color beverageEnergy = Color(0xFFFFEB3B);

  // Shadows (Colored shadows instead of black)
  static BoxShadow get primaryShadow => BoxShadow(
    color: hydroEnd.withOpacity(0.3),
    blurRadius: 20,
    offset: const Offset(0, 10),
    spreadRadius: -10,
  );

  static BoxShadow get secondaryShadow => BoxShadow(
    color: hydroStart.withOpacity(0.3),
    blurRadius: 20,
    offset: const Offset(0, 10),
    spreadRadius: -10,
  );

  static BoxShadow get cardShadow => BoxShadow(
    color: deepOcean.withOpacity(0.08),
    blurRadius: 20,
    offset: const Offset(0, 4),
  );

  // Glassmorphism backgrounds
  static Color get glassLight => Colors.white.withOpacity(0.7);
  static Color get glassDark => const Color(0xFF001220).withOpacity(0.6);
  static Color get glassBorder => Colors.white.withOpacity(0.2);
}

