import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF10B981);
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color accent = Color(0xFFF472B6);
  static const Color info = Color(0xFF0EA5E9);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  
  static const Color lightBackground = Color(0xFFF1F5F9);
  static const Color lightText = Color(0xFF0F172A);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate800 = Color(0xFF1E293B);
}

class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get displayMedium => GoogleFonts.jetBrainsMono(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        letterSpacing: -1,
      );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
      );
}
