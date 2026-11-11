import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/storage_providers.dart';
import 'auth_interceptor.dart';
import 'connectivity_service.dart';
import 'session_events.dart';

Dio _baseDio() => Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {'Accept': 'application/json'},
        contentType: Headers.jsonContentType,
      ),
    );

final sessionEventsProvider = Provider<SessionEvents>((ref) {
  final events = SessionEvents();
  ref.onDispose(events.dispose);
  return events;
});

/// Dio without auth handling: used for refresh/retry.
final bareDioProvider = Provider<Dio>((_) => _baseDio());

/// The centralized API client used by all data sources.
final apiClientProvider = Provider<Dio>((ref) {
  final dio = _baseDio();
  dio.interceptors.add(
    AuthInterceptor(
      retryDio: ref.watch(bareDioProvider),
      tokens: ref.watch(tokenStorageProvider),
      events: ref.watch(sessionEventsProvider),
    ),
  );
  if (AppConfig.enableLogging) {
    // Bodies deliberately NOT logged: they contain credentials/financial data.
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
  }
  return dio;
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
});

/// Emits true when any network transport is available.
final isOnlineProvider = StreamProvider<bool>(
  (ref) => ref.watch(connectivityServiceProvider).onlineStream,
);
