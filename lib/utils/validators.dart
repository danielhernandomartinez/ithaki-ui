/// Returns true if [bytes] exceeds [maxMb] megabytes.
bool exceedsMaxFileSize(int bytes, {int maxMb = 5}) =>
    bytes > maxMb * 1024 * 1024;

/// Reusable password validation result.
///
/// Shared between register, reset-password, and change-password flows.
class PasswordValidation {
  final bool hasUpperAndLower;
  final bool hasMinLength;
  final bool hasNumber;
  final bool hasSpecial;

  const PasswordValidation._({
    required this.hasUpperAndLower,
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasSpecial,
  });

  static final _upper = RegExp(r'[A-Z]');
  static final _lower = RegExp(r'[a-z]');
  static final _digit = RegExp(r'[0-9]');
  static final _special = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

  factory PasswordValidation.of(String password) => PasswordValidation._(
        hasUpperAndLower:
            _upper.hasMatch(password) && _lower.hasMatch(password),
        hasMinLength: password.length >= 8,
        hasNumber: _digit.hasMatch(password),
        hasSpecial: _special.hasMatch(password),
      );

  bool get isValid => hasUpperAndLower && hasMinLength && hasNumber && hasSpecial;
}
