import 'package:assignment/core/utils/input_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputValidators.validatePhone', () {
    test('returns error when phone number is null or empty', () {
      expect(InputValidators.validatePhone(null), 'Mobile number is required');
      expect(InputValidators.validatePhone(''), 'Mobile number is required');
      expect(InputValidators.validatePhone('   '), 'Mobile number is required');
    });

    test('returns error when phone number is less than 10 digits', () {
      expect(
        InputValidators.validatePhone('123456789'),
        'Mobile number must be exactly 10 digits',
      );
      expect(
        InputValidators.validatePhone('98765'),
        'Mobile number must be exactly 10 digits',
      );
    });

    test('returns error when phone number is more than 10 digits', () {
      expect(
        InputValidators.validatePhone('12345678901'),
        'Mobile number must be exactly 10 digits',
      );
    });

    test('returns error when phone contains non-numeric characters', () {
      expect(
        InputValidators.validatePhone('98765abcd0'),
        'Mobile number must be exactly 10 digits',
      );
    });

    test('returns null when phone number has exactly 10 digits', () {
      expect(InputValidators.validatePhone('9876543210'), isNull);
      expect(InputValidators.validatePhone('9985744152'), isNull);
      expect(InputValidators.validatePhone('98765-43210'), isNull);
    });
  });

  group('InputValidators.validateEmail', () {
    test('validates email addresses properly', () {
      expect(InputValidators.validateEmail(null), 'Email is required');
      expect(InputValidators.validateEmail('invalid'), 'Please enter a valid email address');
      expect(InputValidators.validateEmail('test@example.com'), isNull);
    });
  });
}
