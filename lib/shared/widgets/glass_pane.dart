import 'dart:ui';
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class GlassPane extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? blur;
  final double? opacity;

  const GlassPane({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.blur,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    final glassTheme = Theme.of(context).extension<GlassThemeExtension>()!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur ?? glassTheme.blur,
          sigmaY: blur ?? glassTheme.blur,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 24),
            border: Border.all(
              color: glassTheme.borderColor,
              width: 1.5,
            ),
            gradient: glassTheme.gradient,
          ),
          child: child,
        ),
      ),
    );
  }
}
