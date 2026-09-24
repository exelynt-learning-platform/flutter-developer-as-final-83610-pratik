import 'package:assignment/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late ThemeCubit themeCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    themeCubit = ThemeCubit(prefs);
  });

  tearDown(() {
    themeCubit.close();
  });

  group('ThemeCubit', () {
    test('initial state defaults to ThemeMode.system when nothing stored', () {
      expect(themeCubit.state, equals(ThemeMode.system));
    });

    test(
      'emits and persists dark theme when updateThemeMode is called',
      () async {
        await themeCubit.updateThemeMode(ThemeMode.dark);
        expect(themeCubit.state, equals(ThemeMode.dark));
        expect(prefs.getString('user_theme_mode'), equals('dark'));
      },
    );

    test('toggles from light to dark, and dark to light', () async {
      await themeCubit.updateThemeMode(ThemeMode.light);
      expect(themeCubit.state, equals(ThemeMode.light));

      themeCubit.toggleTheme();
      expect(themeCubit.state, equals(ThemeMode.dark));

      themeCubit.toggleTheme();
      expect(themeCubit.state, equals(ThemeMode.light));
    });

    test('loads saved dark mode from SharedPreferences on init', () async {
      SharedPreferences.setMockInitialValues({'user_theme_mode': 'dark'});
      final savedPrefs = await SharedPreferences.getInstance();
      final loadedCubit = ThemeCubit(savedPrefs);

      expect(loadedCubit.state, equals(ThemeMode.dark));
      await loadedCubit.close();
    });
  });
}
