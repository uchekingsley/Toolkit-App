import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'glass_pane.dart';
import '../providers/theme_provider.dart';

import 'command_palette.dart';
import '../services/haptic_service.dart';

class GlassAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showSearch;
  final bool showThemeToggle;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.showSearch = false,
    this.showThemeToggle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GlassPane(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          borderRadius: 20,
          blur: 10,
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  onPressed: () {
                    HapticService.light();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    LucideIcons.chevronLeft,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              if (showSearch)
                IconButton(
                  onPressed: () {
                    HapticService.medium();
                    CommandPalette.show(context);
                  },
                  icon: Icon(
                    LucideIcons.search,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              if (showThemeToggle)
                IconButton(
                  onPressed: () {
                    HapticService.light();
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  icon: Icon(
                    isDark ? LucideIcons.sun : LucideIcons.moon,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
