import 'package:flutter/material.dart';
import '../shared/styles/app_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        background: AppColors.lightBackground,
        surface: Colors.white.withOpacity(0.9),
        onBackground: AppColors.lightText,
        onSurface: AppColors.lightText,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.lightText),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.lightText),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.slate800),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate600),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.lightText),
      ),
      extensions: [
        GlassThemeExtension(
          blur: 15.0,
          opacity: 0.8,
          borderColor: Colors.black.withOpacity(0.08),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.85),
            ],
          ),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        background: AppColors.background,
        surface: AppColors.surface,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.white),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.white60),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      ),
      extensions: [
        GlassThemeExtension(
          blur: 20.0,
          opacity: 0.1,
          borderColor: Colors.white.withOpacity(0.2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.12),
              Colors.white.withOpacity(0.04),
            ],
          ),
        ),
      ],
    );
  }
}

class GlassThemeExtension extends ThemeExtension<GlassThemeExtension> {
  final double blur;
  final double opacity;
  final Color borderColor;
  final Gradient gradient;

  GlassThemeExtension({
    required this.blur,
    required this.opacity,
    required this.borderColor,
    required this.gradient,
  });

  @override
  ThemeExtension<GlassThemeExtension> copyWith({
    double? blur,
    double? opacity,
    Color? borderColor,
    Gradient? gradient,
  }) {
    return GlassThemeExtension(
      blur: blur ?? this.blur,
      opacity: opacity ?? this.opacity,
      borderColor: borderColor ?? this.borderColor,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  ThemeExtension<GlassThemeExtension> lerp(
    ThemeExtension<GlassThemeExtension>? other,
    double t,
  ) {
    if (other is! GlassThemeExtension) return this;
    return GlassThemeExtension(
      blur: lerpDouble(blur, other.blur, t)!,
      opacity: lerpDouble(opacity, other.opacity, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      gradient: Gradient.lerp(gradient, other.gradient, t)!,
    );
  }

  double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
