import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_gradients.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../core/services/guest_mode_service.dart';
import '../../../../app/router.dart';
import '../../../gamification/presentation/widgets/puru/puru_widget.dart';
import '../providers/auth_providers.dart';
import '../providers/onboarding_providers.dart';

/// Login Screen - First screen users see
/// 
/// Provides Google, Apple sign-in options and Guest Mode
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _puruAnimController;

  @override
  void initState() {
    super.initState();
    _puruAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _puruAnimController.dispose();
    super.dispose();
  }

  Future<void> _continueAsGuest() async {
    final guestModeNotifier = ref.read(guestModeNotifierProvider.notifier);
    final onboardingService = ref.read(onboardingServiceProvider);
    
    // Clear any existing onboarding data for fresh start
    await onboardingService.clearProfile();
    
    // Enable guest mode
    await guestModeNotifier.enableGuestMode();
    
    if (mounted) {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final authControllerNotifier = ref.read(authControllerProvider.notifier);

    // Listen to auth state changes
    ref.listen<AuthControllerState>(authControllerProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.getTimeBasedGradient(),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Puru Mascot with animation
                Hero(
                  tag: 'app_mascot',
                  child: AnimatedBuilder(
                    animation: _puruAnimController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          -8 * _puruAnimController.value,
                        ),
                        child: const PuruWidget(
                          size: 160,
                          hydrationPercent: 0.7,
                          showMessage: false,
                          enableEyeTracking: true,
                          showGlowEffect: true,
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // App name
                Text(
                  'app.name'.tr(),
                  style: AppTextStyles.displaySmall(color: Colors.white),
                ),
                
                const SizedBox(height: 12),
                
                // Slogan
                Text(
                  'app.slogan'.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                
                const Spacer(),
                
                // Loading indicator
                if (authController.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                
                // Google Sign In
                _SocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'auth.continue_with_google'.tr(),
                  onPressed: authController.isLoading
                      ? null
                      : () async {
                          await authControllerNotifier.signInWithGoogle();
                        },
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.deepOcean,
                ),
                
                const SizedBox(height: 12),
                
                // Apple Sign In
                _SocialButton(
                  icon: Icons.apple,
                  label: 'auth.continue_with_apple'.tr(),
                  onPressed: authController.isLoading
                      ? null
                      : () async {
                          await authControllerNotifier.signInWithApple();
                        },
                  backgroundColor: AppColors.deepOcean,
                  foregroundColor: Colors.white,
                ),
                
                const SizedBox(height: 24),
                
                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'auth.or'.tr(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Guest Mode Button
                _GuestModeButton(
                  onPressed: authController.isLoading ? null : _continueAsGuest,
                ),
                
                const SizedBox(height: 32),
                
                // Terms
                Text(
                  'auth.terms_agreement'.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Social sign-in button widget
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.button(color: foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Guest mode button with special styling
class _GuestModeButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _GuestModeButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 24,
              color: Colors.white.withOpacity(0.9),
            ),
            const SizedBox(width: 12),
            Text(
              'auth.try_without_account'.tr(),
              style: AppTextStyles.button(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
