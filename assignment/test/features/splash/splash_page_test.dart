import 'package:assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:assignment/features/splash/presentation/pages/splash_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(const UnauthenticatedState());
  });

  testWidgets(
    'SplashPage renders PeopleFlow brand title, subtitle and doodle elements',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const SplashPage(),
          ),
        ),
      );

      // Verify Initial Render
      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byIcon(Icons.people_outline_rounded), findsOneWidget);

      // Advance animation
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.text('PeopleFlow'), findsOneWidget);
      expect(find.text('Employee Management'), findsOneWidget);

      // Unmount cleanly so cancelable timers and loops stop
      await tester.pumpWidget(const SizedBox());
    },
  );
}
