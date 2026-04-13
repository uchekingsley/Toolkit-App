import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';
  late SharedPreferences _prefs;

  @override
  ThemeMode build() {
    _init();
    return ThemeMode.dark; // Default
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      state = savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
    }
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _prefs.setString(_themeKey, state == ThemeMode.light ? 'light' : 'dark');
  }
}
