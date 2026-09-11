import 'package:dailyfeed/core/constants.dart';
import 'package:dailyfeed/data/models/user_model.dart';
import 'package:dailyfeed/data/services/api_service.dart';
import 'package:dailyfeed/data/services/storage_service.dart';
import 'package:dailyfeed/domain/entities/user.dart';
import 'package:dailyfeed/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api);

  final ApiService _api;

  @override
  Future<User> login({
    required String username,
    required String password,
    bool remember = true,
  }) async {
    final json = await _api.post(
      '${AppConfig.authBaseUrl}/auth/login',
      body: <String, dynamic>{
        'username': username.trim(),
        'password': password,
        'expiresInMins': 60,
      },
    );

    final model = UserModel.fromJson(json);

    if (remember) {
      await StorageService.saveUser(model.toJson());
    } else {
      await StorageService.clearUser();
    }

    return model.toEntity();
  }

  @override
  Future<User?> getSavedUser() async {
    final json = StorageService.readUser();
    if (json == null) return null;
    try {
      return UserModel.fromJson(json).toEntity();
    } catch (_) {
      await StorageService.clearUser();
      return null;
    }
  }

  @override
  Future<void> logout() => StorageService.clearUser();
}
