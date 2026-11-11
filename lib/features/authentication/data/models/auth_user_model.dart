import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/entities/user_role.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
class AuthUserModel with _$AuthUserModel {
  const AuthUserModel._();

  const factory AuthUserModel({
    required String id,
    required String fullName,
    required String phone,
    required String role,
    String? email,
    @Default(false) bool isVerified,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  AuthUser toEntity() => AuthUser(
        id: id,
        fullName: fullName,
        phone: phone,
        role: UserRole.fromApi(role),
        email: email,
        isVerified: isVerified,
      );
}
