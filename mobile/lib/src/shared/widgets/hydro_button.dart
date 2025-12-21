import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Primary gradient button for SmartHydro
class HydroButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;

  const HydroButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            side: const BorderSide(color: AppColors.hydroEnd, width: 2),
            shape: const StadiumBorder(),
          ),
          child: _buildChild(context, isOutlined: true),
        ),
      );
    }

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null ? AppColors.hydroGradient : null,
          color: onPressed == null ? AppColors.grey300 : null,
          borderRadius: BorderRadius.circular(50),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.hydroEnd.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: -10,
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: const StadiumBorder(),
          ),
          child: _buildChild(context),
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context, {bool isOutlined = false}) {
    final color = isOutlined ? AppColors.hydroEnd : Colors.white;

    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    return Text(
      label,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}

/// Circular FAB with water drop icon
class HydroFab extends StatelessWidget {
  final VoidCallback onPressed;
  final bool showPulse;

  const HydroFab({
    super.key,
    required this.onPressed,
    this.showPulse = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.hydroGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.hydroEnd.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.water_drop,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

/// Glass-morphism card
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassDark : AppColors.glassLight,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }
}

