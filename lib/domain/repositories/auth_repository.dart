import 'package:dailyfeed/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String username,
    required String password,
    bool remember,
  });

  Future<User?> getSavedUser();

  Future<void> logout();
}
