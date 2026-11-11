import 'package:flutter_test/flutter_test.dart';
import 'package:trust_me/core/utils/validators.dart';

void main() {
  group('phone', () {
    test('accepts valid Sri Lankan formats', () {
      for (final p in ['0771234567', '+94771234567', '94771234567', '077 123 4567']) {
        expect(Validators.phone(p), isNull, reason: p);
      }
    });
    test('rejects invalid numbers', () {
      expect(Validators.phone(''), ValidationError.required);
      expect(Validators.phone('0112345678'), ValidationError.invalidPhone);
      expect(Validators.phone('12345'), ValidationError.invalidPhone);
    });
    test('normalizes to E.164', () {
      expect(Validators.normalizePhone('0771234567'), '+94771234567');
      expect(Validators.normalizePhone('94771234567'), '+94771234567');
      expect(Validators.normalizePhone('+94 77 123 4567'), '+94771234567');
    });
  });

  group('nic', () {
    test('old and new formats', () {
      expect(Validators.nic('901234567V'), isNull);
      expect(Validators.nic('199012345678'), isNull);
      expect(Validators.nic('90123'), ValidationError.invalidNic);
    });
  });

  group('password', () {
    test('min length', () {
      expect(Validators.password('short'), ValidationError.passwordTooShort);
      expect(Validators.password('longenough1'), isNull);
    });
  });
}
