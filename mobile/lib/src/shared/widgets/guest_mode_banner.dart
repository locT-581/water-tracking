import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/guest_mode_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../../app/router.dart';

/// Guest Mode Banner - Shows when user is in guest mode
/// 
/// Displays a subtle banner encouraging users to link their account
/// for data backup and sync.
class GuestModeBanner extends ConsumerWidget {
  const GuestModeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuestMode = ref.watch(guestModeNotifierProvider);
    
    if (!isGuestMode) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppGradients.glass(opacity: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.hydroEnd.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLinkAccountDialog(context, ref),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.hydroEnd.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_off_outlined,
                    color: AppColors.hydroEnd,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'auth.guest_mode_banner'.tr(),
                        style: TextStyle(
                          color: AppColors.deepOcean,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'auth.link_account'.tr(),
                        style: TextStyle(
                          color: AppColors.hydroEnd,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.hydroEnd,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLinkAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => LinkAccountDialog(),
    );
  }
}

/// Dialog prompting user to link their account
class LinkAccountDialog extends ConsumerWidget {
  const LinkAccountDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'auth.link_account_prompt_title'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        'auth.link_account_prompt_message'.tr(),
        style: TextStyle(
          color: AppColors.deepOcean.withOpacity(0.8),
          fontSize: 14,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Mark as seen so we don't show the reminder again
            ref.read(guestModeServiceProvider).markLinkAccountPromptSeen();
          },
          child: Text(
            'auth.link_account_later'.tr(),
            style: TextStyle(
              color: AppColors.grey600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Navigate to login screen to link account
            context.go(AppRoutes.login);
            // Disable guest mode (user wants to sign in)
            ref.read(guestModeNotifierProvider.notifier).disableGuestMode();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.hydroEnd,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text('auth.link_account_now'.tr()),
        ),
      ],
    );
  }
}

/// Floating reminder that appears after 3 days of guest mode
class GuestModeReminder extends ConsumerStatefulWidget {
  final Widget child;
  
  const GuestModeReminder({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<GuestModeReminder> createState() => _GuestModeReminderState();
}

class _GuestModeReminderState extends ConsumerState<GuestModeReminder> {
  bool _hasShownReminder = false;

  @override
  void initState() {
    super.initState();
    // Check if we should show reminder after a short delay
    Future.delayed(const Duration(seconds: 2), _checkAndShowReminder);
  }

  void _checkAndShowReminder() {
    if (_hasShownReminder) return;
    
    final shouldShow = ref.read(shouldShowLinkAccountReminderProvider);
    if (shouldShow && mounted) {
      _hasShownReminder = true;
      showDialog(
        context: context,
        builder: (context) => const LinkAccountDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

