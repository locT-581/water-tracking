import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../shared/theme/app_theme.dart';
import '../shared/widgets/toast_overlay.dart';
import 'router.dart';

class SmartHydroApp extends ConsumerWidget {
  const SmartHydroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'SmartHydro',
      debugShowCheckedModeBanner: false,

      // Localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Router
      routerConfig: router,
      
      // Toast overlay wrapper
      builder: (context, child) {
        return ToastOverlay(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

