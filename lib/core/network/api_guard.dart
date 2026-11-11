import 'package:dio/dio.dart';

import '../errors/app_exception.dart';

/// Runs an API call and converts transport errors into [AppException].
Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on AppException {
    rethrow;
  } on DioException catch (e) {
    throw AppException.fromDio(e);
  } catch (e) {
    throw AppException(type: AppExceptionType.unknown, message: e.toString());
  }
}
