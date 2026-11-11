import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trust_me/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:trust_me/features/authentication/domain/entities/auth_user.dart';
import 'package:trust_me/features/authentication/domain/repositories/auth_repository.dart';
import 'package:trust_me/features/authentication/presentation/screens/login_screen.dart';
import 'package:trust_me/l10n/generated/app_localizations.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser?> restoreSession() async => null;
  @override
  Future<AuthUser> login({required String phone, required String password}) =>
      throw UnimplementedError();
  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('shows validation errors for empty form', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(_FakeAuthRepository())],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('This field is required'), findsNWidgets(2));
  });
}
