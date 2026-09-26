// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetAuthStateStreamUseCase _getAuthStateStreamUseCase;

  StreamSubscription? _authStateSubscription;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetAuthStateStreamUseCase getAuthStateStreamUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _googleSignInUseCase = googleSignInUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _getAuthStateStreamUseCase = getAuthStateStreamUseCase,
       super(const AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginRequestedEvent>(_onLoginRequested);
    on<RegisterRequestedEvent>(_onRegisterRequested);
    on<GoogleSignInRequestedEvent>(_onGoogleSignInRequested);
    on<ForgotPasswordRequestedEvent>(_onForgotPasswordRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<AuthUserChangedInternalEvent>(_onAuthUserChanged);

    _authStateSubscription = _getAuthStateStreamUseCase().listen(
      (user) => add(AuthUserChangedInternalEvent(user)),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState('Checking session...'));
    final result = await _getCurrentUserUseCase();
    result.fold(
      onSuccess: (user) {
        if (user != null) {
          emit(AuthenticatedState(user));
        } else {
          emit(const UnauthenticatedState());
        }
      },
      onError: (failure) => emit(const UnauthenticatedState()),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState('Signing in...'));
    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      onSuccess: (user) => emit(AuthenticatedState(user)),
      onError: (failure) => emit(AuthFailureState(failure.message, failure: failure)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState('Creating account...'));
    final result = await _registerUseCase(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );
    result.fold(
      onSuccess: (user) => emit(AuthenticatedState(user)),
      onError: (failure) => emit(AuthFailureState(failure.message, failure: failure)),
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState('Connecting with Google...'));
    final result = await _googleSignInUseCase();
    result.fold(
      onSuccess: (user) => emit(AuthenticatedState(user)),
      onError: (failure) => emit(AuthFailureState(failure.message, failure: failure)),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState('Sending recovery email...'));
    final result = await _forgotPasswordUseCase(email: event.email);
    result.fold(
      onSuccess: (_) => emit(PasswordResetSentState(event.email)),
      onError: (failure) => emit(AuthFailureState(failure.message, failure: failure)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState('Signing out...'));
    final result = await _logoutUseCase();
    result.fold(
      onSuccess: (_) => emit(const UnauthenticatedState()),
      onError: (failure) => emit(AuthFailureState(failure.message)),
    );
  }

  void _onAuthUserChanged(
    AuthUserChangedInternalEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthenticatedState(event.user!));
    } else {
      emit(const UnauthenticatedState());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
