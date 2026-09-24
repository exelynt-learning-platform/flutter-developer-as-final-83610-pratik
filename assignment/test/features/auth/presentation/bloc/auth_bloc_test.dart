import 'dart:async';
import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/core/utils/result.dart';
import 'package:assignment/features/auth/domain/entities/user_entity.dart';
import 'package:assignment/features/auth/domain/usecases/auth_usecases.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockGoogleSignInUseCase extends Mock implements GoogleSignInUseCase {}

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockGetAuthStateStreamUseCase extends Mock
    implements GetAuthStateStreamUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockGoogleSignInUseCase mockGoogleSignInUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockGetAuthStateStreamUseCase mockGetAuthStateStreamUseCase;
  late StreamController<UserEntity?> authStreamController;

  const tUser = UserEntity(
    id: 'user_123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockGoogleSignInUseCase = MockGoogleSignInUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockGetAuthStateStreamUseCase = MockGetAuthStateStreamUseCase();
    authStreamController = StreamController<UserEntity?>.broadcast();

    when(
      () => mockGetAuthStateStreamUseCase(),
    ).thenAnswer((_) => authStreamController.stream);
  });

  tearDown(() {
    authStreamController.close();
  });

  AuthBloc buildBloc() {
    return AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      googleSignInUseCase: mockGoogleSignInUseCase,
      forgotPasswordUseCase: mockForgotPasswordUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      getAuthStateStreamUseCase: mockGetAuthStateStreamUseCase,
    );
  }

  group('AuthBloc', () {
    test('initial state is AuthInitialState', () {
      expect(buildBloc().state, equals(const AuthInitialState()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, AuthenticatedState] when CheckAuthStatusEvent finds a user',
      setUp: () {
        when(
          () => mockGetCurrentUserUseCase(),
        ).thenAnswer((_) async => const Success(tUser));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CheckAuthStatusEvent()),
      expect: () => [
        const AuthLoadingState('Checking session...'),
        const AuthenticatedState(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, UnauthenticatedState] when CheckAuthStatusEvent returns null user',
      setUp: () {
        when(
          () => mockGetCurrentUserUseCase(),
        ).thenAnswer((_) async => const Success(null));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CheckAuthStatusEvent()),
      expect: () => [
        const AuthLoadingState('Checking session...'),
        const UnauthenticatedState(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, AuthenticatedState] on successful LoginRequestedEvent',
      setUp: () {
        when(
          () => mockLoginUseCase(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => const Success(tUser));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
      expect: () => [
        const AuthLoadingState('Signing in...'),
        const AuthenticatedState(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, AuthFailureState] when LoginRequestedEvent fails',
      setUp: () {
        when(
          () => mockLoginUseCase(email: 'test@example.com', password: 'wrong'),
        ).thenAnswer(
          (_) async =>
              const Error(AuthFailure(message: 'Incorrect email or password.')),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(email: 'test@example.com', password: 'wrong'),
      ),
      expect: () => [
        const AuthLoadingState('Signing in...'),
        const AuthFailureState('Incorrect email or password.'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, UnauthenticatedState] on LogoutRequestedEvent success',
      setUp: () {
        when(
          () => mockLogoutUseCase(),
        ).thenAnswer((_) async => const Success(null));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const LogoutRequestedEvent()),
      expect: () => [
        const AuthLoadingState('Signing out...'),
        const UnauthenticatedState(),
      ],
    );
  });
}
