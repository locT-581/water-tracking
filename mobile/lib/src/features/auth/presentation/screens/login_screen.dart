import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_gradients.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../app/router.dart';
import '../providers/auth_providers.dart';

/// Login Screen - First screen users see
/// 
/// Provides Google and Apple sign-in options
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
                
                // Logo with animated gradient
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      shape: BoxShape.circle,
                      boxShadow: GradientDecoration.coloredShadow(
                        color: AppColors.hydroEnd,
                        blur: 30,
                        spread: 5,
                        opacity: 0.4,
                      ),
                    ),
                    child: const Icon(
                      Icons.water_drop_rounded,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
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
                
                const SizedBox(height: 16),
                
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
                
                const SizedBox(height: 40),
                
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

