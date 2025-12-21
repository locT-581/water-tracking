import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App Text Styles using Google Fonts
/// 
/// Nunito: Headings (rounded, friendly)
/// Inter: Body (clean, readable)
class AppTextStyles {
  AppTextStyles._();

  // ============== DISPLAY STYLES (Nunito) ==============
  
  static TextStyle displayLarge({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      color: color,
      height: 1.2,
    );
  }

  static TextStyle displayMedium({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      color: color,
      height: 1.2,
    );
  }

  static TextStyle displaySmall({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: color,
      height: 1.2,
    );
  }

  // ============== HEADLINE STYLES (Nunito) ==============
  
  static TextStyle headlineLarge({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: color,
      height: 1.3,
    );
  }

  static TextStyle headlineMedium({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: color,
      height: 1.3,
    );
  }

  static TextStyle headlineSmall({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color,
      height: 1.4,
    );
  }

  // ============== TITLE STYLES (Nunito) ==============
  
  static TextStyle titleLarge({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.4,
    );
  }

  static TextStyle titleMedium({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle titleSmall({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.5,
    );
  }

  // ============== BODY STYLES (Inter) ==============
  
  static TextStyle bodyLarge({Color color = AppColors.deepOcean}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle bodyMedium({Color color = AppColors.deepOcean}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle bodySmall({Color color = AppColors.deepOcean}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }

  // ============== LABEL STYLES (Inter) ==============
  
  static TextStyle labelLarge({Color color = AppColors.deepOcean}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.4,
      letterSpacing: 0.5,
    );
  }

  static TextStyle labelMedium({Color color = AppColors.deepOcean}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.4,
      letterSpacing: 0.5,
    );
  }

  static TextStyle labelSmall({Color color = AppColors.deepOcean}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.4,
      letterSpacing: 0.5,
    );
  }

  // ============== BUTTON STYLES ==============
  
  static TextStyle button({Color color = Colors.white}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 0.5,
    );
  }

  static TextStyle buttonSmall({Color color = Colors.white}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 0.5,
    );
  }

  // ============== SPECIAL STYLES ==============
  
  /// Number display (for water amount, goals)
  static TextStyle number({
    required double fontSize,
    Color color = AppColors.deepOcean,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFeatures: [
        const FontFeature.tabularFigures(), // Monospace numbers
      ],
    );
  }

  /// Caption style (small helper text)
  static TextStyle caption({Color color = AppColors.deepOcean}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color.withOpacity(0.7),
      height: 1.4,
    );
  }

  /// Overline (small uppercase text)
  static TextStyle overline({Color color = AppColors.deepOcean}) {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: color.withOpacity(0.7),
      letterSpacing: 1.5,
      height: 1.4,
    ).copyWith(
      // Force uppercase in style
      fontFeatures: [const FontFeature.enable('smcp')],
    );
  }

  /// Quote style (for Science Hub)
  static TextStyle quote({Color color = AppColors.deepOcean}) {
    return GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.6,
      fontStyle: FontStyle.italic,
    );
  }

  /// Code/Monospace (for technical info)
  static TextStyle code({Color color = AppColors.deepOcean}) {
    return GoogleFonts.robotoMono(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }
}

/// Helper extension for quick text styling
extension TextStyleHelper on TextStyle {
  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  
  /// Make text semibold
  TextStyle get semibold => copyWith(fontWeight: FontWeight.w600);
  
  /// Make text medium
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  
  /// Make text regular
  TextStyle get regular => copyWith(fontWeight: FontWeight.normal);
  
  /// Make text italic
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  
  /// Add color
  TextStyle withColor(Color color) => copyWith(color: color);
  
  /// Add opacity
  TextStyle withOpacity(double opacity) => copyWith(
    color: (color ?? Colors.black).withOpacity(opacity),
  );
  
  /// Scale size
  TextStyle withSize(double size) => copyWith(fontSize: size);
  
  /// Add letter spacing
  TextStyle withSpacing(double spacing) => copyWith(letterSpacing: spacing);
}

