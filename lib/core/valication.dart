class Validators {
  const Validators._();

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$",
  );

  /// Accepts a valid email OR a username (dummyjson uses usernames).
  static String? emailOrUsername(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Email is required';

    if (input.contains('@')) {
      return _emailRegex.hasMatch(input) ? null : 'Enter a valid email address';
    }
    return input.length >= 3 ? null : 'Enter a valid email or username';
  }

  static String? password(String? value) {
    final input = value ?? '';
    if (input.isEmpty) return 'Password is required';
    if (input.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
