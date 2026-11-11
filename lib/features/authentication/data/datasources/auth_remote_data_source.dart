import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_guard.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../../../../core/network/network_providers.dart';
import '../models/auth_response_model.dart';
import '../models/auth_user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthResponseModel> login(String phone, String password) => guardApi(() async {
        final res = await _dio.post<Map<String, dynamic>>(
          '/auth/login',
          data: {'phone': phone, 'password': password},
          options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
        );
        return AuthResponseModel.fromJson(res.data!);
      });

  Future<AuthUserModel> me() => guardApi(() async {
        final res = await _dio.get<Map<String, dynamic>>('/auth/me');
        return AuthUserModel.fromJson(res.data!);
      });

  Future<void> logout(String refreshToken) => guardApi(() async {
        await _dio.post<void>('/auth/logout', data: {'refreshToken': refreshToken});
      });
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(apiClientProvider)),
);
