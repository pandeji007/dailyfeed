class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.accessToken,
    this.image = '',
  });

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String accessToken;
  final String image;

  String get displayName => '$firstName $lastName'.trim();
}
