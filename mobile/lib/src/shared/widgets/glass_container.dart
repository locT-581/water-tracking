import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_gradients.dart';

/// Glassmorphism Container Widget
/// 
/// Provides the glass effect with backdrop filter blur,
/// following SmartHydro's "Fluid & Organic" design philosophy
class GlassContainer extends StatelessWidget {
  /// Child widget inside the glass container
  final Widget? child;
  
  /// Width of the container
  final double? width;
  
  /// Height of the container
  final double? height;
  
  /// Border radius (default: 24 - SmartHydro standard)
  final double borderRadius;
  
  /// Background gradient opacity (0.0 - 1.0, default: 0.15)
  final double opacity;
  
  /// Blur intensity (default: 10.0)
  final double blur;
  
  /// Border color
  final Color? borderColor;
  
  /// Border width
  final double borderWidth;
  
  /// Padding inside container
  final EdgeInsetsGeometry? padding;
  
  /// Margin outside container
  final EdgeInsetsGeometry? margin;
  
  /// Custom gradient (defaults to white glass)
  final Gradient? gradient;
  
  /// Box shadows
  final List<BoxShadow>? boxShadow;
  
  /// Alignment of child
  final AlignmentGeometry? alignment;

  const GlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.opacity = 0.15,
    this.blur = 10.0,
    this.borderColor,
    this.borderWidth = 1.5,
    this.padding,
    this.margin,
    this.gradient,
    this.boxShadow,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? _defaultShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: Container(
            alignment: alignment,
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient ?? AppGradients.glass(opacity: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderColor != null
                  ? Border.all(
                      color: borderColor!,
                      width: borderWidth,
                    )
                  : Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: borderWidth,
                    ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  List<BoxShadow> get _defaultShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];
}

/// Glassmorphism Card Widget
/// 
/// A card widget with glass effect, perfect for dashboard cards
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.borderRadius = 24,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final container = GlassContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      gradient: gradient,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: container,
      );
    }

    return container;
  }
}

/// Glassmorphism AppBar
/// 
/// Transparent app bar with glass effect
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;
  final double blur;

  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.height = kToolbarHeight,
    this.blur = 10.0,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          height: height + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            gradient: AppGradients.glass(opacity: 0.1),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (leading != null) leading!,
                  if (leading != null) const SizedBox(width: 12),
                  Expanded(
                    child: title ?? const SizedBox.shrink(),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphism Bottom Sheet
/// 
/// Bottom sheet with glass effect background
class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;

  const GlassBottomSheet({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blur = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(borderRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.glass(opacity: 0.2),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Show glass bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double borderRadius = 24,
    double blur = 10.0,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => GlassBottomSheet(
        borderRadius: borderRadius,
        blur: blur,
        child: child,
      ),
    );
  }
}

