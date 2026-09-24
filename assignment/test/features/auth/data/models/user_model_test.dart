import 'package:assignment/features/auth/data/models/user_model.dart';
import 'package:assignment/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUserModel = UserModel(
    id: 'user_123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.png',
  );

  test('UserModel is a subclass of UserEntity', () {
    expect(tUserModel, isA<UserEntity>());
  });

  group('fromJson', () {
    test('should return a valid model from JSON map', () {
      final jsonMap = {
        'id': 'user_123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': 'https://example.com/photo.png',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result, equals(tUserModel));
      expect(result.id, equals('user_123'));
      expect(result.email, equals('test@example.com'));
      expect(result.displayName, equals('Test User'));
    });

    test('should fallback to uid and name when present in json', () {
      final jsonMap = {
        'uid': 'user_456',
        'email': 'alt@example.com',
        'name': 'Alt User',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, equals('user_456'));
      expect(result.email, equals('alt@example.com'));
      expect(result.displayName, equals('Alt User'));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tUserModel.toJson();

      final expectedMap = {
        'id': 'user_123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': 'https://example.com/photo.png',
      };

      expect(result, equals(expectedMap));
    });
  });
}
