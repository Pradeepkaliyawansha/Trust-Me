import 'dart:io';

import 'package:dio/dio.dart';

enum AppExceptionType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  conflict,
  server,
  cancelled,
  unknown,
}

/// Single error type exposed to the domain/presentation layers.
class AppException implements Exception {
  const AppException({
    required this.type,
    this.message = '',
    this.statusCode,
    this.code,
  });

  final AppExceptionType type;
  final String message;
  final int? statusCode;

  /// Machine-readable backend error code, e.g. `INVALID_CREDENTIALS`.
  final String? code;

  factory AppException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const AppException(type: AppExceptionType.timeout);
      case DioExceptionType.connectionError:
        return const AppException(type: AppExceptionType.network);
      case DioExceptionType.cancel:
        return const AppException(type: AppExceptionType.cancelled);
      case DioExceptionType.badResponse:
        return _fromResponse(e.response);
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const AppException(type: AppExceptionType.network);
        }
        return AppException(
            type: AppExceptionType.unknown, message: e.message ?? '');
    }
  }

  static AppException _fromResponse(Response<dynamic>? response) {
    final status = response?.statusCode ?? 0;
    String message = '';
    String? code;
    final data = response?.data;
    if (data is Map) {
      final raw = data['message'];
      message = raw is List ? raw.join('\n') : (raw?.toString() ?? '');
      code = data['code']?.toString();
    }

    final type = switch (status) {
      400 || 422 => AppExceptionType.validation,
      401 => AppExceptionType.unauthorized,
      403 => AppExceptionType.forbidden,
      404 => AppExceptionType.notFound,
      409 => AppExceptionType.conflict,
      >= 500 => AppExceptionType.server,
      _ => AppExceptionType.unknown,
    };
    return AppException(
        type: type, message: message, statusCode: status, code: code);
  }

  @override
  String toString() => 'AppException($type, $statusCode, $code, $message)';
}
