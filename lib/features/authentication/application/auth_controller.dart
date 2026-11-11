import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/utils/validators.dart';
import '../data/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final sub = ref.watch(sessionEventsProvider).onExpired.listen((_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    });
    ref.onDispose(sub.cancel);

    Future.microtask(_restore);
    return const AuthState();
  }

  Future<void> _restore() async {
    try {
      final user = await ref.read(authRepositoryProvider).restoreSession();
      state = user == null
          ? const AuthState(status: AuthStatus.unauthenticated)
          : AuthState(status: AuthStatus.authenticated, user: user);
    } on AppException {
      // Offline with no cached profile: fall back to the login screen.
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String phone, String password) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final user = await ref.read(authRepositoryProvider).login(
            phone: Validators.normalizePhone(phone),
            password: password,
          );
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
