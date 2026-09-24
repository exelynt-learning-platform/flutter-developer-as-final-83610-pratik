import 'package:assignment/core/errors/exceptions.dart';
import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/core/utils/result.dart';
import 'package:assignment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:assignment/features/auth/data/models/user_model.dart';
import 'package:assignment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  const tUserModel = UserModel(
    id: 'user_123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  group('loginWithEmailAndPassword', () {
    test(
      'should return Success(user) when remote data source succeeds',
      () async {
        when(
          () => mockRemoteDataSource.loginWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tUserModel);

        final result = await repository.loginWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, isA<Success<dynamic>>());
        expect((result as Success).data, equals(tUserModel));
        verify(
          () => mockRemoteDataSource.loginWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      },
    );

    test(
      'should return Error(AuthFailure) when remote data source throws AuthException',
      () async {
        when(
          () => mockRemoteDataSource.loginWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          const AuthException(
            message: 'Invalid credentials',
            code: 'wrong-password',
          ),
        );

        final result = await repository.loginWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrong',
        );

        expect(result, isA<Error<dynamic>>());
        final error = result as Error;
        expect(error.failure, isA<AuthFailure>());
        expect(error.failure.message, equals('Invalid credentials'));
      },
    );
  });

  group('signInWithGoogle', () {
    test('should return Success(user) on successful Google Sign-In', () async {
      when(
        () => mockRemoteDataSource.signInWithGoogle(),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signInWithGoogle();

      expect(result, isA<Success<dynamic>>());
      expect((result as Success).data, equals(tUserModel));
      verify(() => mockRemoteDataSource.signInWithGoogle()).called(1);
    });
  });

  group('signOut', () {
    test('should return Success(null) on successful sign out', () async {
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, isA<Success<dynamic>>());
      verify(() => mockRemoteDataSource.signOut()).called(1);
    });
  });
}
