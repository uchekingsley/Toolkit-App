import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'routes/app_routes.dart';

import 'shared/providers/theme_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SmartUtilityApp(),
    ),
  );
}

class SmartUtilityApp extends ConsumerWidget {
  const SmartUtilityApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Smart Utility Toolkit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
