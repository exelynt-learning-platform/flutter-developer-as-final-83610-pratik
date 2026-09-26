import 'package:assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:assignment/features/auth/presentation/pages/login_page.dart';
import 'package:assignment/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginPage(),
      ),
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('renders all critical UI elements and input fields', (
      tester,
    ) async {
      when(() => mockAuthBloc.state).thenReturn(const UnauthenticatedState());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('PeopleFlow'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(SocialAuthButton), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('shows validation errors when submitting with empty fields', (
      tester,
    ) async {
      when(() => mockAuthBloc.state).thenReturn(const UnauthenticatedState());

      await tester.pumpWidget(createWidgetUnderTest());

      // Tap Sign In button with empty form
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows Email not registered SnackBar on AuthFailureState with unregistered email', (
      tester,
    ) async {
      whenListen(
        mockAuthBloc,
        Stream.fromIterable([
          const AuthFailureState('Email not registered'),
        ]),
        initialState: const UnauthenticatedState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Email not registered'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows inline error when AuthFailureState is Incorrect password', (
      tester,
    ) async {
      whenListen(
        mockAuthBloc,
        Stream.fromIterable([
          const AuthFailureState('Incorrect password'),
        ]),
        initialState: const UnauthenticatedState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Incorrect password'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
