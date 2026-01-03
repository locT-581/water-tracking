import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_gradients.dart';
import '../../../../core/services/guest_mode_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../gamification/presentation/widgets/puru/puru_widget.dart';
import '../../../../app/router.dart';

/// Splash Screen - First screen users see when opening the app
/// 
/// Shows SmartHydro branding with Puru mascot animation
/// Then navigates based on auth state or guest mode
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.bounceOut),
      ),
    );

    _controller.forward();

    // Navigate after animation
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Wait for animation and minimum splash time
    await Future<void>.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Check if guest mode is enabled
    final isGuestMode = ref.read(isGuestModeProvider);
    
    if (isGuestMode) {
      // Guest user - go directly to home (they've already onboarded)
      context.go(AppRoutes.home);
      return;
    }

    // Check auth status for non-guest users
    final authStatus = ref.read(authStatusProvider);
    final hasCompletedOnboarding = ref.read(hasCompletedOnboardingProvider);

    if (authStatus == AuthStatus.authenticated) {
      if (hasCompletedOnboarding) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.onboarding);
      }
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.getTimeBasedGradient(),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Puru Mascot
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Hero(
                        tag: 'app_mascot',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.hydroEnd.withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const PuruWidget(
                            size: 160,
                            hydrationPercent: 0.8,
                            showMessage: false,
                            enableEyeTracking: false,
                            showGlowEffect: true,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App name
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: const Text(
                        'SmartHydro',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Slogan
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Text(
                        'Hydration tuned to your biology',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Loading indicator with water animation
                    Opacity(
                      opacity: _bounceAnimation.value,
                      child: const _WaterLoadingIndicator(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom water-themed loading indicator
class _WaterLoadingIndicator extends StatefulWidget {
  const _WaterLoadingIndicator();

  @override
  State<_WaterLoadingIndicator> createState() => _WaterLoadingIndicatorState();
}

class _WaterLoadingIndicatorState extends State<_WaterLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Transform.scale(
                scale: 1.0 + (_waveController.value * 0.3),
                child: Opacity(
                  opacity: 1.0 - _waveController.value,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // Inner drop
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
