import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/theme/app_gradients.dart';
import '../../../gamification/presentation/widgets/puru/puru_widget.dart';

/// Animated goal reveal dialog
/// Shows the calculated daily water goal with celebration animation
class GoalRevealDialog extends StatefulWidget {
  final int goalMl;
  final String? formulaExplanation;
  final VoidCallback onStart;

  const GoalRevealDialog({
    super.key,
    required this.goalMl,
    this.formulaExplanation,
    required this.onStart,
  });

  /// Show the dialog with animation
  static Future<void> show(
    BuildContext context, {
    required int goalMl,
    String? formulaExplanation,
    required VoidCallback onStart,
  }) {
    HapticFeedback.heavyImpact();
    
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return GoalRevealDialog(
          goalMl: goalMl,
          formulaExplanation: formulaExplanation,
          onStart: onStart,
        );
      },
    );
  }

  @override
  State<GoalRevealDialog> createState() => _GoalRevealDialogState();
}

class _GoalRevealDialogState extends State<GoalRevealDialog>
    with TickerProviderStateMixin {
  late AnimationController _countController;
  late AnimationController _pulseController;
  late AnimationController _confettiController;
  late Animation<int> _countAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Count animation
    _countController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _countAnimation = IntTween(begin: 0, end: widget.goalMl).animate(
      CurvedAnimation(
        parent: _countController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    // Pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Confetti animation
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 300), () {
      _countController.forward();
      _confettiController.forward();
    });
  }
  
  @override
  void dispose() {
    _countController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.hydroEnd.withOpacity(0.2),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Confetti
            Positioned.fill(
              child: _ConfettiOverlay(controller: _confettiController),
            ),
            
            // Content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'onboarding.your_goal'.tr(),
                  style: AppTextStyles.titleMedium(color: AppColors.grey600),
                ),
                
                const SizedBox(height: 16),
                
                // Animated goal circle - SMALLER
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale = 1.0 + 0.03 * _pulseController.value;
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.hydroEnd.withOpacity(0.3),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated number
                        AnimatedBuilder(
                          animation: _countAnimation,
                          builder: (context, _) {
                            return Text(
                              '${_countAnimation.value}',
                              style: AppTextStyles.headlineLarge(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        Text(
                          'onboarding.ml_per_day'.tr(),
                          style: AppTextStyles.labelMedium(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Formula explanation - more compact
                if (widget.formulaExplanation != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calculate_outlined,
                          color: AppColors.science,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.formulaExplanation!,
                          style: AppTextStyles.labelSmall(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Description - shorter
                Text(
                  'onboarding.goal_will_adjust'.tr(),
                  style: AppTextStyles.bodySmall(color: AppColors.grey600),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Dynamic adjustment icons - inline
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AdjustmentIconCompact(
                      icon: Icons.wb_sunny_outlined,
                      label: 'onboarding.weather'.tr(),
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 20),
                    _AdjustmentIconCompact(
                      icon: Icons.directions_run_outlined,
                      label: 'onboarding.activity'.tr(),
                      color: AppColors.success,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Puru celebrating - smaller
                const PuruWidget(
                  size: 64,
                  hydrationPercent: 1.0,
                  showMessage: false,
                  showGlowEffect: true,
                ),
                
                const SizedBox(height: 16),
                
                // Start button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).pop();
                      widget.onStart();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepOcean,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'onboarding.start'.tr(),
                      style: AppTextStyles.button(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact adjustment indicator (inline)
class _AdjustmentIconCompact extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _AdjustmentIconCompact({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.labelSmall(color: AppColors.grey600),
        ),
      ],
    );
  }
}

/// Confetti overlay animation
class _ConfettiOverlay extends StatelessWidget {
  final AnimationController controller;

  const _ConfettiOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.value == 0) return const SizedBox.shrink();
        
        return CustomPaint(
          painter: _ConfettiPainter(
            progress: controller.value,
          ),
        );
      },
    );
  }
}

/// Confetti painter
class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_Confetti> _confettis = [];
  final math.Random _random = math.Random(42);

  _ConfettiPainter({required this.progress}) {
    // Generate confetti particles
    if (_confettis.isEmpty) {
      for (int i = 0; i < 30; i++) {
        _confettis.add(_Confetti(
          x: _random.nextDouble(),
          speed: 0.5 + _random.nextDouble() * 0.5,
          size: 4 + _random.nextDouble() * 6,
          color: [
            AppColors.hydroStart,
            AppColors.hydroEnd,
            AppColors.success,
            AppColors.warning,
            Colors.white,
          ][_random.nextInt(5)],
          rotation: _random.nextDouble() * math.pi * 2,
        ));
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final confetti in _confettis) {
      final y = -50 + (size.height + 100) * progress * confetti.speed;
      final x = confetti.x * size.width + math.sin(y * 0.02) * 20;
      final opacity = (1 - progress).clamp(0.0, 1.0);
      
      final paint = Paint()
        ..color = confetti.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(confetti.rotation + progress * math.pi * 2);
      
      // Draw rectangle confetti
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: confetti.size,
            height: confetti.size * 0.6,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => 
      oldDelegate.progress != progress;
}

class _Confetti {
  final double x;
  final double speed;
  final double size;
  final Color color;
  final double rotation;

  _Confetti({
    required this.x,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotation,
  });
}

