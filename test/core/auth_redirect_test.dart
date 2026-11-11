import 'package:flutter_test/flutter_test.dart';
import 'package:trust_me/core/router/app_router.dart';
import 'package:trust_me/core/router/route_names.dart';
import 'package:trust_me/features/authentication/application/auth_state.dart';
import 'package:trust_me/features/authentication/domain/entities/auth_user.dart';
import 'package:trust_me/features/authentication/domain/entities/user_role.dart';

AuthState _signedIn(UserRole role) => AuthState(
      status: AuthStatus.authenticated,
      user: AuthUser(id: '1', fullName: 'T', phone: '+94771234567', role: role),
    );

void main() {
  test('unknown -> splash', () {
    expect(authRedirect(const AuthState(), Routes.login), Routes.splash);
  });

  test('signed out -> login', () {
    const s = AuthState(status: AuthStatus.unauthenticated);
    expect(authRedirect(s, Routes.business), Routes.login);
    expect(authRedirect(s, Routes.login), isNull);
  });

  test('signed in leaves login for role home', () {
    expect(authRedirect(_signedIn(UserRole.customer), Routes.login), Routes.customer);
  });

  test('role cannot open another role area', () {
    expect(authRedirect(_signedIn(UserRole.customer), Routes.admin), Routes.customer);
    expect(authRedirect(_signedIn(UserRole.administrator), Routes.admin), isNull);
  });
}
