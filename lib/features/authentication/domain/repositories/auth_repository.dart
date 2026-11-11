import '../entities/auth_user.dart';

abstract class AuthRepository {
  /// Restores a session from secure storage. Returns null if signed out.
  Future<AuthUser?> restoreSession();

  Future<AuthUser> login({required String phone, required String password});

  Future<void> logout();
}
