import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/hydration/presentation/screens/home_screen.dart';
import '../features/hydration/presentation/screens/logging_screen.dart';
import '../features/hydration/presentation/screens/analysis_screen.dart';
import '../features/science_hub/presentation/screens/science_hub_screen.dart';
import '../features/science_hub/presentation/screens/article_detail_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/gamification/presentation/screens/buddy_screen.dart';
import '../features/gamification/presentation/screens/challenges_screen.dart';
import '../features/gamification/presentation/screens/achievements_screen.dart';
import '../features/gamification/presentation/screens/mascot_gallery_screen.dart';
import '../features/gamification/presentation/widgets/puru/puru_showcase.dart';
import '../features/gamification/presentation/widgets/puru_3d/puru_3d_comparison_showcase.dart';

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
  static const String mascotGallery = '/mascot-gallery'; // Mascot Collection Gallery
  static const String puruTest = '/puru-test'; // Dev route for testing Puru
  static const String puru3DComparison = '/puru-3d-comparison'; // 3D Comparison Showcase
}

final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state for routing decisions
  final authStatus = ref.watch(authStatusProvider);
  final hasCompletedOnboarding = ref.watch(hasCompletedOnboardingProvider);
  
  return GoRouter(
    // 🔧 DEV MODE: Change to AppRoutes.splash for production
    initialLocation: AppRoutes.puru3DComparison,
    debugLogDiagnostics: true,
    
    // Redirect logic based on auth state
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == AppRoutes.login;
      final isGoingToOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isGoingToSplash = state.matchedLocation == AppRoutes.splash;
      
      // Dev routes - allow access
      if (state.matchedLocation == AppRoutes.puruTest ||
          state.matchedLocation == AppRoutes.puru3DComparison) {
        return null;
      }
      
      // If not authenticated, go to login
      if (authStatus == AuthStatus.unauthenticated) {
        return isGoingToLogin || isGoingToSplash ? null : AppRoutes.login;
      }
      
      // If authenticated but not onboarded, go to onboarding
      if (authStatus == AuthStatus.authenticated && !hasCompletedOnboarding) {
        return isGoingToOnboarding ? null : AppRoutes.onboarding;
      }
      
      // If authenticated and onboarded, prevent going back to login/onboarding
      if (authStatus == AuthStatus.authenticated && hasCompletedOnboarding) {
        if (isGoingToLogin || isGoingToOnboarding || isGoingToSplash) {
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
      
      // 🧪 DEV: Puru showcase for testing mascot
      GoRoute(
        path: AppRoutes.puruTest,
        builder: (context, state) => const PuruShowcase(),
      ),
      GoRoute(
        path: AppRoutes.puru3DComparison,
        builder: (context, state) => const Puru3DComparisonShowcase(),
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
      
      // Dev/Test routes
      GoRoute(
        path: AppRoutes.puruTest,
        builder: (context, state) => const PuruShowcase(),
      ),
      GoRoute(
        path: AppRoutes.puru3DComparison,
        builder: (context, state) => const Puru3DComparisonShowcase(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});

// Splash Screen placeholder
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement splash screen with auth check
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// Main Shell with bottom navigation
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const MainBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.log),
        child: const Icon(Icons.water_drop),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Bottom Navigation Bar
class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isSelected: location == AppRoutes.home,
            onTap: () => context.go(AppRoutes.home),
          ),
          _NavItem(
            icon: Icons.bar_chart_rounded,
            label: 'Analysis',
            isSelected: location == AppRoutes.analysis,
            onTap: () => context.go(AppRoutes.analysis),
          ),
          const SizedBox(width: 48), // Space for FAB
          _NavItem(
            icon: Icons.science_rounded,
            label: 'Science',
            isSelected: location == AppRoutes.scienceHub,
            onTap: () => context.go(AppRoutes.scienceHub),
          ),
          _NavItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            isSelected: location == AppRoutes.settings,
            onTap: () => context.go(AppRoutes.settings),
          ),
        ],
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
    final theme = Theme.of(context);
    final color = isSelected ? theme.primaryColor : theme.unselectedWidgetColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
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

