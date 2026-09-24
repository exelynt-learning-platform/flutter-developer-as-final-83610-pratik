import 'package:assignment/core/constants/app_strings.dart';
import 'package:assignment/core/theme/theme_cubit.dart';
import 'package:assignment/features/splash/presentation/pages/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  testWidgets(
    'InitialPage renders app title, phase status, and toggles theme',
    (tester) async {
      await tester.pumpWidget(
        BlocProvider<ThemeCubit>.value(
          value: themeCubit,
          child: const MaterialApp(home: InitialPage()),
        ),
      );

      // Verify Title and Phase Status
      expect(find.text(AppStrings.appTitle), findsAtLeastNWidgets(1));
      expect(find.text('Phase 1 — Foundation'), findsOneWidget);
      expect(find.text('Clean Architecture (Core Layer)'), findsOneWidget);

      // Tap theme toggle button
      final toggleButton = find.byType(OutlinedButton);
      expect(toggleButton, findsOneWidget);

      await tester.tap(toggleButton);
      await tester.pumpAndSettle();

      // Verify theme changed in cubit
      expect(themeCubit.state, equals(ThemeMode.dark));
    },
  );
}
