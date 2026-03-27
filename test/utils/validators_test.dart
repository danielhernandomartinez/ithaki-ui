// test/utils/validators_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/utils/validators.dart';

void main() {
  // ─── PasswordValidation ───────────────────────────────────────────────────

  group('PasswordValidation', () {
    test('empty password fails all checks', () {
      final v = PasswordValidation.of('');
      expect(v.hasUpperAndLower, false);
      expect(v.hasMinLength, false);
      expect(v.hasNumber, false);
      expect(v.hasSpecial, false);
      expect(v.isValid, false);
    });

    test('password with upper and lower case satisfies hasUpperAndLower', () {
      expect(PasswordValidation.of('Abcdefg').hasUpperAndLower, true);
    });

    test('all-lowercase fails hasUpperAndLower', () {
      expect(PasswordValidation.of('abcdefgh').hasUpperAndLower, false);
    });

    test('all-uppercase fails hasUpperAndLower', () {
      expect(PasswordValidation.of('ABCDEFGH').hasUpperAndLower, false);
    });

    test('exactly 8 characters satisfies hasMinLength', () {
      expect(PasswordValidation.of('abcdefgh').hasMinLength, true);
    });

    test('7 characters fails hasMinLength', () {
      expect(PasswordValidation.of('abcdefg').hasMinLength, false);
    });

    test('password with a digit satisfies hasNumber', () {
      expect(PasswordValidation.of('abc123').hasNumber, true);
    });

    test('no digits fails hasNumber', () {
      expect(PasswordValidation.of('abcABCde').hasNumber, false);
    });

    test('password with a special character satisfies hasSpecial', () {
      expect(PasswordValidation.of('abc!').hasSpecial, true);
    });

    test('no special characters fails hasSpecial', () {
      expect(PasswordValidation.of('abc123ABC').hasSpecial, false);
    });

    test('fully valid password passes all checks and isValid', () {
      final v = PasswordValidation.of('MyPass1!');
      expect(v.hasUpperAndLower, true);
      expect(v.hasMinLength, true);
      expect(v.hasNumber, true);
      expect(v.hasSpecial, true);
      expect(v.isValid, true);
    });

    test('isValid is false when only one check is missing', () {
      // Missing special character
      final v = PasswordValidation.of('MyPass12');
      expect(v.hasUpperAndLower, true);
      expect(v.hasMinLength, true);
      expect(v.hasNumber, true);
      expect(v.hasSpecial, false);
      expect(v.isValid, false);
    });

    test('each valid special character is recognized', () {
      const specials = r'!@#$%^&*(),.?":{}|<>';
      for (final ch in specials.split('')) {
        final v = PasswordValidation.of('Aa1$ch');
        expect(v.hasSpecial, true,
            reason: '"$ch" should be recognized as a special character');
      }
    });

    test('longer valid password satisfies all checks', () {
      expect(PasswordValidation.of('MyLongPass123!').isValid, true);
    });
  });
}
