import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._tokens);

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokens;

  @override
  Future<AuthUser> login({required String phone, required String password}) async {
    final res = await _remote.login(phone, password);
    await _tokens.save(
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
    );
    await _tokens.writeCachedUser(jsonEncode(res.user.toJson()));
    return res.user.toEntity();
  }

  @override
  Future<AuthUser?> restoreSession() async {
    if (await _tokens.readRefreshToken() == null) return null;
    try {
      final user = await _remote.me(); // interceptor refreshes if needed
      await _tokens.writeCachedUser(jsonEncode(user.toJson()));
      return user.toEntity();
    } on AppException catch (e) {
      if (e.type == AppExceptionType.network ||
          e.type == AppExceptionType.timeout) {
        // Offline start: reopen with the cached profile. Server-side
        // authorization still applies to every request once online.
        final cached = await _tokens.readCachedUser();
        if (cached != null) {
          return AuthUserModel.fromJson(
                  jsonDecode(cached) as Map<String, dynamic>)
              .toEntity();
        }
        rethrow;
      }
      await _tokens.clear();
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final refresh = await _tokens.readRefreshToken();
    try {
      if (refresh != null) await _remote.logout(refresh);
    } on AppException {
      // Best effort: always clear local credentials.
    } finally {
      await _tokens.clear();
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  ),
);
