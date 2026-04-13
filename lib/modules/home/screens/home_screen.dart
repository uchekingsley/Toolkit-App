import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/dynamic_background.dart';
import '../../../shared/providers/history_provider.dart';
import '../../../shared/providers/theme_provider.dart';
import '../../../shared/widgets/glass_pane.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      body: DynamicBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              child: Icon(
                                ref.watch(themeProvider) == ThemeMode.dark ? LucideIcons.sun : LucideIcons.moon,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ).animate().fadeIn().scale(),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good afternoon,',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'Utility User',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.2),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Smart Toolkit',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 36,
                            ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    BentoCard(
                      title: 'Length',
                      subtitle: '8 Units',
                      icon: LucideIcons.ruler,
                      baseColor: const Color(0xFF6366F1),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.length),
                    ).animate().fadeIn(delay: 300.ms).scale(),
                    BentoCard(
                      title: 'Weight',
                      subtitle: '5 Units',
                      icon: LucideIcons.scale,
                      baseColor: const Color(0xFF10B981),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.weight),
                    ).animate().fadeIn(delay: 400.ms).scale(),
                    BentoCard(
                      title: 'Temperature',
                      subtitle: '3 Scales',
                      icon: LucideIcons.thermometer,
                      baseColor: const Color(0xFFF472B6),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.temperature),
                    ).animate().fadeIn(delay: 500.ms).scale(),
                    BentoCard(
                      title: 'More',
                      subtitle: 'Utilities',
                      icon: LucideIcons.plus,
                      baseColor: Colors.grey,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.more),
                    ).animate().fadeIn(delay: 600.ms).scale(),
                  ],
                ),
              ),
              if (history.isNotEmpty) ...[
                SliverPadding(
                  padding: const EdgeInsets.all(24.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(LucideIcons.history, size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Recent activity',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ).animate().fadeIn(),
                        const SizedBox(height: 16),
                        ...history.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GlassPane(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                borderRadius: 16,
                                blur: 5,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(LucideIcons.activity, size: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat('HH:mm').format(item.timestamp),
                                            style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      item.result,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6366F1),
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }
}
