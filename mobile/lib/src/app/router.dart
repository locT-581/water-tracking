import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/bhi_constants.dart';
import '../core/services/guest_mode_service.dart';
import '../shared/theme/app_colors.dart';
import '../shared/theme/app_gradients.dart';
import '../shared/widgets/toast_overlay.dart';
import '../features/hydration/presentation/providers/hydration_providers.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/hydration/presentation/screens/home_screen.dart';
import '../features/hydration/presentation/screens/logging_screen.dart';
import '../features/hydration/presentation/screens/analysis_screen.dart';
import '../features/hydration/presentation/widgets/logging_bottom_sheet.dart';
import '../features/science_hub/presentation/screens/science_hub_screen.dart';
import '../features/science_hub/presentation/screens/article_detail_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/gamification/presentation/screens/buddy_screen.dart';
import '../features/gamification/presentation/screens/challenges_screen.dart';
import '../features/gamification/presentation/screens/achievements_screen.dart';
import '../features/gamification/presentation/screens/mascot_gallery_screen.dart';

// Route names
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String log = '/log';
  static const String analysis = '/analysis';
  static const String scienceHub = '/science';
  static const String articleDetail = '/science/:id';
  static const String settings = '/settings';
  static const String buddy = '/buddy';
  static const String challenges = '/challenges';
  static const String achievements = '/achievements';
  static const String mascotGallery = '/mascot-gallery';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state and guest mode for routing decisions
  final authStatus = ref.watch(authStatusProvider);
  final hasCompletedOnboarding = ref.watch(hasCompletedOnboardingProvider);
  final isGuestMode = ref.watch(guestModeNotifierProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    // Redirect logic based on auth state and guest mode
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == AppRoutes.login;
      final isGoingToOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isGoingToSplash = state.matchedLocation == AppRoutes.splash;
      
      // Allow splash screen to handle its own navigation
      if (isGoingToSplash) {
        return null;
      }
      
      // Guest mode - check onboarding status
      if (isGuestMode) {
        // If guest hasn't completed onboarding, force onboarding
        if (!hasCompletedOnboarding) {
          // Allow going to onboarding, redirect everything else to onboarding
          return isGoingToOnboarding ? null : AppRoutes.onboarding;
        }
        
        // Guest has completed onboarding - allow main app, block login/onboarding
        if (isGoingToLogin || isGoingToOnboarding) {
          return AppRoutes.home;
        }
        return null;
      }
      
      // If not authenticated and not guest, go to login
      if (authStatus == AuthStatus.unauthenticated) {
        return isGoingToLogin ? null : AppRoutes.login;
      }
      
      // If authenticated but not onboarded, go to onboarding
      if (authStatus == AuthStatus.authenticated && !hasCompletedOnboarding) {
        return isGoingToOnboarding ? null : AppRoutes.onboarding;
      }
      
      // If authenticated and onboarded, prevent going back to login/onboarding
      if (authStatus == AuthStatus.authenticated && hasCompletedOnboarding) {
        if (isGoingToLogin || isGoingToOnboarding) {
          return AppRoutes.home;
        }
      }
      
      return null;
    },
    
    routes: [
      // Splash / Initial route
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main app routes with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.analysis,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalysisScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.scienceHub,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ScienceHubScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),

      // Modal routes
      GoRoute(
        path: AppRoutes.log,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LoggingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),

      // Article detail
      GoRoute(
        path: AppRoutes.articleDetail,
        builder: (context, state) {
          final articleId = state.pathParameters['id'] ?? '';
          return ArticleDetailScreen(articleId: articleId);
        },
      ),

      // Gamification routes
      GoRoute(
        path: AppRoutes.buddy,
        builder: (context, state) => const BuddyScreen(),
      ),
      GoRoute(
        path: AppRoutes.challenges,
        builder: (context, state) => const ChallengesScreen(),
      ),
      GoRoute(
        path: AppRoutes.achievements,
        builder: (context, state) => const AchievementsScreen(),
      ),
      
      // Mascot Collection Gallery
      GoRoute(
        path: AppRoutes.mascotGallery,
        builder: (context, state) => const MascotGalleryScreen(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});

// Main Shell with bottom navigation
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const MainBottomNavBar(),
      floatingActionButton: const _WaterFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/// Animated water drop FAB with Quick Log support
/// - Tap: Instantly log 250ml water (1-tap logging!)
/// - Long press: Open full logging bottom sheet
class _WaterFAB extends ConsumerStatefulWidget {
  const _WaterFAB();

  @override
  ConsumerState<_WaterFAB> createState() => _WaterFABState();
}

class _WaterFABState extends ConsumerState<_WaterFAB> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  // For tap feedback animation
  late AnimationController _tapController;
  late Animation<double> _tapAnimation;
  
  // Quick log default settings
  static const int _quickLogVolume = 250; // ml
  static const BeverageType _quickLogBeverage = BeverageType.water;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation (idle state)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Tap feedback animation
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  /// Quick log: Instantly add 250ml water
  Future<void> _quickLog() async {
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    // Play tap animation
    await _tapController.forward();
    await _tapController.reverse();
    
    // Capture notifier before async operation
    final logsNotifier = ref.read(todayLogsProvider.notifier);
    
    try {
      // Add log via provider
      await logsNotifier.addLog(
        beverageType: _quickLogBeverage,
        volumeMl: _quickLogVolume,
      );
      
      // Get last log for undo
      final lastLog = logsNotifier.getLastLog();
      
      // Show success toast with undo
      toast.success(
        '+250ml nước 💧',
        onUndo: lastLog != null 
            ? () => logsNotifier.removeLog(lastLog.logId)
            : null,
      );
    } catch (e) {
      toast.error('Không thể ghi nhận. Thử lại sau.');
    }
  }
  
  /// Open full logging bottom sheet
  void _openFullLogging() {
    HapticFeedback.heavyImpact();
    LoggingBottomSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _tapAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value * _tapAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _quickLog,
        onLongPress: _openFullLogging,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.hydroEnd.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main icon
              const Icon(
                Icons.water_drop_rounded,
                color: Colors.white,
                size: 32,
              ),
              // Quick log badge (bottom-right)
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '+250',
                    style: TextStyle(
                      color: AppColors.hydroEnd,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom Navigation Bar
class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Trang chủ',
                  isSelected: location == AppRoutes.home,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(AppRoutes.home);
                  },
                ),
                _NavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Thống kê',
                  isSelected: location == AppRoutes.analysis,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(AppRoutes.analysis);
                  },
                ),
                const SizedBox(width: 64), // Space for FAB
                _NavItem(
                  icon: Icons.auto_stories_rounded,
                  label: 'Kiến thức',
                  isSelected: location == AppRoutes.scienceHub,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(AppRoutes.scienceHub);
                  },
                ),
                _NavItem(
                  icon: Icons.settings_rounded,
                  label: 'Cài đặt',
                  isSelected: location == AppRoutes.settings,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(AppRoutes.settings);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.hydroEnd.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.hydroEnd : AppColors.grey400,
                size: 22,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.hydroEnd : AppColors.grey500,
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Error Screen
class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(error?.toString() ?? 'Unknown error'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

