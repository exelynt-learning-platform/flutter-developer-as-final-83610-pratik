import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Result<UserEntity>> signInWithGoogle();

  Future<Result<void>> sendPasswordResetEmail({required String email});

  Future<Result<void>> signOut();

  Future<Result<UserEntity?>> getCurrentUser();

  Stream<UserEntity?> get authStateChanges;
}
