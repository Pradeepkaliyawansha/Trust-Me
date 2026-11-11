import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keychain (iOS) / EncryptedSharedPreferences (Android) backed token store.
/// Never stores passwords.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _userKey = 'cached_user';

  String? _accessCache;

  Future<String?> readAccessToken() async =>
      _accessCache ??= await _storage.read(key: _accessKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessCache = accessToken;
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  Future<String?> readCachedUser() => _storage.read(key: _userKey);

  Future<void> writeCachedUser(String json) =>
      _storage.write(key: _userKey, value: json);

  Future<void> clear() async {
    _accessCache = null;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _userKey);
  }
}
