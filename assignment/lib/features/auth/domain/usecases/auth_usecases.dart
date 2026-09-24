import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Signs in an existing user with email and password.
class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

/// Registers a new user with email, password, and optional display name.
class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _repository.registerWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}

/// Sends a password recovery email for the provided address.
class ForgotPasswordUseCase {
  final AuthRepository _repository;
  const ForgotPasswordUseCase(this._repository);

  Future<Result<void>> call({required String email}) {
    return _repository.sendPasswordResetEmail(email: email);
  }
}

/// Authenticates a user via Google OAuth credential.
class GoogleSignInUseCase {
  final AuthRepository _repository;
  const GoogleSignInUseCase(this._repository);

  Future<Result<UserEntity>> call() {
    return _repository.signInWithGoogle();
  }
}

/// Signs out the currently authenticated user.
class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<Result<void>> call() {
    return _repository.signOut();
  }
}

/// Retrieves the currently cached/authenticated user entity.
class GetCurrentUserUseCase {
  final AuthRepository _repository;
  const GetCurrentUserUseCase(this._repository);

  Future<Result<UserEntity?>> call() {
    return _repository.getCurrentUser();
  }
}

/// Provides a reactive stream of auth state changes.
class GetAuthStateStreamUseCase {
  final AuthRepository _repository;
  const GetAuthStateStreamUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.authStateChanges;
  }
}
