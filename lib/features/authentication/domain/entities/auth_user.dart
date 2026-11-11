import 'user_role.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.role,
    this.email,
    this.isVerified = false,
  });

  final String id;
  final String fullName;
  final String phone;
  final UserRole role;
  final String? email;
  final bool isVerified;
}
