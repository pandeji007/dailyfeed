import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyfeed/data/repositories/auth_repository_impl.dart';
import 'package:dailyfeed/data/services/api_service.dart';
import 'package:dailyfeed/domain/entities/user.dart';
import 'package:dailyfeed/domain/repositories/auth_repository.dart';

// --- Dependencies ------------------------------------------------------------

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(apiServiceProvider)),
);

// --- Auth State --------------------------------------------------------------

/// Emits: null = signed out, User = signed in.
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() => ref.read(authRepositoryProvider).getSavedUser();

  Future<void> login({
    required String email,
    required String password,
    bool remember = true,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .login(username: email, password: password, remember: remember),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
