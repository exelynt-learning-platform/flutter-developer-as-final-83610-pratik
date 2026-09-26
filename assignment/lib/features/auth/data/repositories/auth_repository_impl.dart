import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(user);
    } on AuthException catch (e) {
      return Error(_mapAuthException(e));
    } on NetworkException catch (e) {
      return Error(NetworkFailure(message: e.message));
    } catch (e) {
      return Error(AuthFailure(message: e.toString()));
    }
  }

  AuthFailure _mapAuthException(AuthException e) {
    if (e.code == 'wrong-password' || e.message.toLowerCase().contains('incorrect password')) {
      return InvalidCredentialsFailure(message: e.message, code: e.code);
    }
    if (e.code == 'user-not-found' || e.message.toLowerCase().contains('not registered')) {
      return UserNotFoundFailure(message: e.message, code: e.code);
    }
    return AuthFailure(message: e.message, code: e.code);
  }

  @override
  Future<Result<UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final user = await _remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Success(user);
    } on AuthException catch (e) {
      return Error(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Error(NetworkFailure(message: e.message));
    } catch (e) {
      return Error(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Success(user);
    } on AuthException catch (e) {
      return Error(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Error(NetworkFailure(message: e.message));
    } catch (e) {
      return Error(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email: email);
      return const Success(null);
    } on AuthException catch (e) {
      return Error(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Error(NetworkFailure(message: e.message));
    } catch (e) {
      return Error(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Success(null);
    } on AuthException catch (e) {
      return Error(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Error(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Success(user);
    } on AuthException catch (e) {
      return Error(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Error(AuthFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges;
}
