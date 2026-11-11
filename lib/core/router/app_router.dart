import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/application/auth_controller.dart';
import '../../features/authentication/application/auth_state.dart';
import '../../features/authentication/domain/entities/user_role.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/role_home_screen.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import 'route_names.dart';

String homeRouteFor(UserRole role) => switch (role) {
      UserRole.businessOwner => Routes.business,
      UserRole.moneyLender => Routes.lender,
      UserRole.customer => Routes.customer,
      UserRole.administrator => Routes.admin,
    };

/// Pure redirect function (unit-testable).
/// UX-level guard only: the NestJS backend enforces real authorization.
String? authRedirect(AuthState auth, String location) {
  switch (auth.status) {
    case AuthStatus.unknown:
      return location == Routes.splash ? null : Routes.splash;
    case AuthStatus.unauthenticated:
      return location == Routes.login ? null : Routes.login;
    case AuthStatus.authenticated:
      final home = homeRouteFor(auth.user!.role);
      if (location == Routes.splash || location == Routes.login) return home;
      final inRoleArea = {
        Routes.business,
        Routes.lender,
        Routes.customer,
        Routes.admin,
      }.any(location.startsWith);
      // Inside any role area other than the user's own -> bounce home.
      if (inRoleArea && !location.startsWith(home)) return home;
      return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<AuthState>(authControllerProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) =>
        authRedirect(ref.read(authControllerProvider), state.matchedLocation),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: Routes.business,
        builder: (_, __) => const RoleHomeScreen(role: UserRole.businessOwner),
      ),
      GoRoute(
        path: Routes.lender,
        builder: (_, __) => const RoleHomeScreen(role: UserRole.moneyLender),
      ),
      GoRoute(
        path: Routes.customer,
        builder: (_, __) => const RoleHomeScreen(role: UserRole.customer),
      ),
      GoRoute(
        path: Routes.admin,
        builder: (_, __) => const RoleHomeScreen(role: UserRole.administrator),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
