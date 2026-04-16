import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'routes/app_routes.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/services/clipboard_intelligence.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SmartUtilityApp(),
    ),
  );
}

class SmartUtilityApp extends ConsumerStatefulWidget {
  const SmartUtilityApp({super.key});

  @override
  ConsumerState<SmartUtilityApp> createState() => _SmartUtilityAppState();
}

class _SmartUtilityAppState extends ConsumerState<SmartUtilityApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 2), () {
       if (mounted) ClipboardIntelligence().checkClipboard(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ClipboardIntelligence().checkClipboard(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
