import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app/app.dart';
import 'src/core/services/background_task_service.dart';
import 'src/core/services/guest_mode_service.dart';
import 'src/core/services/isar_service.dart';
import 'src/features/auth/data/services/onboarding_service.dart';
import 'src/features/auth/presentation/providers/onboarding_providers.dart';
import 'src/features/gamification/presentation/providers/mascot_providers.dart';
import 'src/features/hydration/presentation/providers/hydration_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Isar database
  final isar = await IsarService.initialize();

  // Initialize SharedPreferences for services
  final prefs = await SharedPreferences.getInstance();
  final guestModeService = GuestModeService(prefs);
  final onboardingService = OnboardingService(prefs);

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Initialize background tasks
  await BackgroundTaskService.initialize();
  await BackgroundTaskService.registerPeriodicTasks();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi'),
      child: ProviderScope(
        overrides: [
          // Provide SharedPreferences
          sharedPreferencesProvider.overrideWithValue(prefs),
          // Provide the GuestModeService
          guestModeServiceProvider.overrideWithValue(guestModeService),
          // Provide the OnboardingService
          onboardingServiceProvider.overrideWithValue(onboardingService),
          // Provide the Isar database
          isarProvider.overrideWithValue(isar),
        ],
        child: const SmartHydroApp(),
      ),
    ),
  );
}
