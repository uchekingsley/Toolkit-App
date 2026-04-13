import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'glass_pane.dart';

// bento card widget
class BentoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color baseColor;
  final VoidCallback onTap;
  final double? height;

  const BentoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.baseColor,
    required this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: GlassPane(
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  icon,
                  size: 120,
                  color: baseColor.withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: baseColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: baseColor.withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: baseColor,
                        size: 32,
                      ),
                    ).animate().scale(delay: 200.ms),
                    const Spacer(),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
