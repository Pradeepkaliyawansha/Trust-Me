import '../constants/app_constants.dart';

/// Client-side validators. Return an error *key*, mapped to localized text in
/// the UI. The backend remains the source of truth for all validation.
enum ValidationError { required, invalidPhone, passwordTooShort, invalidNic }

class Validators {
  const Validators._();

  static final _phone = RegExp(r'^(?:\+94|0094|94|0)?7\d{8}$');
  static final _nicOld = RegExp(r'^\d{9}[VvXx]$');
  static final _nicNew = RegExp(r'^\d{12}$');

  static ValidationError? required(String? v) =>
      (v == null || v.trim().isEmpty) ? ValidationError.required : null;

  static ValidationError? phone(String? v) {
    if (required(v) != null) return ValidationError.required;
    final cleaned = v!.replaceAll(RegExp(r'[\s-]'), '');
    return _phone.hasMatch(cleaned) ? null : ValidationError.invalidPhone;
  }

  static ValidationError? password(String? v) {
    if (v == null || v.isEmpty) return ValidationError.required;
    return v.length < AppConstants.minPasswordLength
        ? ValidationError.passwordTooShort
        : null;
  }

  static ValidationError? nic(String? v) {
    if (required(v) != null) return ValidationError.required;
    final s = v!.trim();
    return (_nicOld.hasMatch(s) || _nicNew.hasMatch(s))
        ? null
        : ValidationError.invalidNic;
  }

  /// Normalizes to E.164 (+94XXXXXXXXX). Assumes [phone] already validated.
  static String normalizePhone(String input) {
    var s = input.replaceAll(RegExp(r'[\s-]'), '');
    if (s.startsWith('+94')) return s;
    if (s.startsWith('0094')) return '+94${s.substring(4)}';
    if (s.startsWith('94') && s.length == 11) return '+$s';
    if (s.startsWith('0')) s = s.substring(1);
    return '+94$s';
  }
}
