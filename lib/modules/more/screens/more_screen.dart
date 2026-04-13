import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/dynamic_background.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../routes/app_routes.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'More Utilities', showBackButton: true),
      body: DynamicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                BentoCard(
                  title: 'Currency',
                  subtitle: 'Live Rates',
                  icon: LucideIcons.banknote,
                  baseColor: const Color(0xFF6366F1),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.currency),
                ).animate().fadeIn(delay: 100.ms).scale(),
                BentoCard(
                  title: 'BMI',
                  subtitle: 'Health',
                  icon: LucideIcons.activity,
                  baseColor: const Color(0xFFEF4444),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.bmi),
                ).animate().fadeIn(delay: 200.ms).scale(),
                BentoCard(
                  title: 'Fuel',
                  subtitle: 'Efficiency',
                  icon: LucideIcons.fuel,
                  baseColor: const Color(0xFFF59E0B),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.fuel),
                ).animate().fadeIn(delay: 300.ms).scale(),
                BentoCard(
                  title: 'Password',
                  subtitle: 'Coming Soon',
                  icon: LucideIcons.lock,
                  baseColor: Colors.grey,
                  onTap: () {},
                ).animate().fadeIn(delay: 400.ms).scale(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
