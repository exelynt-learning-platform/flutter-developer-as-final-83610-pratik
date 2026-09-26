import 'package:assignment/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
  });

  group('ThemeCubit', () {
    test('initial state is ThemeMode.light when no preference is saved', () {
      when(() => mockPrefs.getString('APP_THEME_MODE')).thenReturn(null);

      final cubit = ThemeCubit(mockPrefs);

      expect(cubit.state, ThemeMode.light);
      expect(cubit.isDarkMode, false);
    });

    test('initial state is ThemeMode.dark when stored preference is dark', () {
      when(() => mockPrefs.getString('APP_THEME_MODE')).thenReturn('dark');

      final cubit = ThemeCubit(mockPrefs);

      expect(cubit.state, ThemeMode.dark);
      expect(cubit.isDarkMode, true);
    });

    test('toggleTheme switches between light and dark modes and saves to prefs', () async {
      when(() => mockPrefs.getString('APP_THEME_MODE')).thenReturn('light');
      when(() => mockPrefs.setString('APP_THEME_MODE', 'dark'))
          .thenAnswer((_) async => true);
      when(() => mockPrefs.setString('APP_THEME_MODE', 'light'))
          .thenAnswer((_) async => true);

      final cubit = ThemeCubit(mockPrefs);
      expect(cubit.state, ThemeMode.light);

      await cubit.toggleTheme();
      expect(cubit.state, ThemeMode.dark);
      verify(() => mockPrefs.setString('APP_THEME_MODE', 'dark')).called(1);

      await cubit.toggleTheme();
      expect(cubit.state, ThemeMode.light);
      verify(() => mockPrefs.setString('APP_THEME_MODE', 'light')).called(1);
    });
  });
}
