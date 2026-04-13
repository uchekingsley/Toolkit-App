import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// app theme
class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF10B981); // Emerald
  static const Color backgroundColor = Color(0xFF0F172A); // Slate 900
  static const Color surfaceColor = Color(0xFF1E293B); // Slate 800
  static const Color accentColor = Color(0xFFF472B6); // Pink

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: const Color(0xFFF1F5F9), // Slate 100
        surface: Colors.white.withOpacity(0.9),
        onBackground: const Color(0xFF0F172A), // Slate 900
        onSurface: const Color(0xFF0F172A), // Slate 900
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0F172A),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF1E293B), // Slate 800
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF475569), // Slate 600
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.inter(color: const Color(0xFF0F172A)),
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
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white60,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.inter(color: Colors.white),
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

// glass design extension
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
