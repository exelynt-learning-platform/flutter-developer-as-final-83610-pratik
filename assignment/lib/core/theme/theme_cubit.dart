import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit managing app-wide theme mode (Light, Dark, System) with SharedPreferences persistence.
class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'APP_THEME_MODE';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_loadInitialTheme(_prefs));

  static ThemeMode _loadInitialTheme(SharedPreferences prefs) {
    final stored = prefs.getString(_themeKey);
    if (stored == 'dark') return ThemeMode.dark;
    if (stored == 'light') return ThemeMode.light;
    return ThemeMode.light;
  }

  bool get isDarkMode => state == ThemeMode.dark;

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    final value = mode == ThemeMode.dark ? 'dark' : 'light';
    await _prefs.setString(_themeKey, value);
  }
}
