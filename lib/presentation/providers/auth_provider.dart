import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyfeed/core/constants.dart';
import 'package:dailyfeed/data/services/storage_service.dart';

class AuthState {
  const AuthState({
    required this.isLoggedIn,
    this.email,
  });

  final bool isLoggedIn;
  final String? email;

  AuthState copyWith({
    bool? isLoggedIn,
    String? email,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final isLoggedIn =
        StorageService.auth.get(StorageKeys.isLoggedInKey, defaultValue: false)
            as bool;
    final email = StorageService.auth.get(StorageKeys.userEmailKey) as String?;
    return AuthState(isLoggedIn: isLoggedIn, email: email);
  }

  Future<void> login(String email) async {
    await StorageService.auth.put(StorageKeys.isLoggedInKey, true);
    await StorageService.auth.put(StorageKeys.userEmailKey, email);
    state = AuthState(isLoggedIn: true, email: email);
  }

  Future<void> logout() async {
    await StorageService.auth.delete(StorageKeys.isLoggedInKey);
    await StorageService.auth.delete(StorageKeys.userEmailKey);
    state = const AuthState(isLoggedIn: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
