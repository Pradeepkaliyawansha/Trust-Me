import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'session_events.dart';

/// Attaches the access token and transparently handles 401s with refresh-token
/// rotation. Extends [QueuedInterceptor] so concurrent 401s trigger only one
/// refresh; later queued requests reuse the already-rotated token.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.retryDio,
    required this.tokens,
    required this.events,
  });

  /// A bare Dio (no AuthInterceptor) used for refresh + retry to avoid
  /// deadlocking the queue.
  final Dio retryDio;
  final TokenStorage tokens;
  final SessionEvents events;

  static const skipAuthKey = 'skipAuth';
  static const _retriedKey = 'retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthKey] != true) {
      final token = await tokens.readAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final req = err.requestOptions;
    final is401 = err.response?.statusCode == 401;
    if (!is401 ||
        req.extra[skipAuthKey] == true ||
        req.extra[_retriedKey] == true) {
      handler.next(err);
      return;
    }

    try {
      final current = await tokens.readAccessToken();
      final sent = req.headers['Authorization'];
      String? token;
      if (current != null && sent != 'Bearer $current') {
        token = current; // a previous queued request already refreshed
      } else {
        token = await _refresh();
      }

      if (token == null) {
        await _expireSession();
        handler.next(err);
        return;
      }

      req.headers['Authorization'] = 'Bearer $token';
      req.extra[_retriedKey] = true;
      handler.resolve(await retryDio.fetch<dynamic>(req));
    } on DioException catch (e) {
      handler.next(e); // e.g. network error mid-refresh: keep the session
    } catch (_) {
      handler.next(err);
    }
  }

  /// Returns the new access token, or null when the refresh token is
  /// definitively rejected / missing. Network failures are rethrown.
  Future<String?> _refresh() async {
    final refreshToken = await tokens.readRefreshToken();
    if (refreshToken == null) return null;
    try {
      final res = await retryDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {skipAuthKey: true}),
      );
      final data = res.data!;
      final access = data['accessToken'] as String;
      final refresh = data['refreshToken'] as String; // rotated
      await tokens.save(accessToken: access, refreshToken: refresh);
      return access;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) return null;
      rethrow;
    }
  }

  Future<void> _expireSession() async {
    await tokens.clear();
    events.notifyExpired();
  }
}
