import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_message.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _msg(AppLocalizations l10n, ValidationError? e) => switch (e) {
        null => null,
        ValidationError.required => l10n.fieldRequired,
        ValidationError.invalidPhone => l10n.invalidPhone,
        ValidationError.passwordTooShort => l10n.passwordTooShort,
        ValidationError.invalidNic => l10n.fieldRequired,
      };

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .login(_phone.text, _password.text);
    if (!ok && mounted) {
      final error = ref.read(authControllerProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizedError(AppLocalizations.of(context), error))),
        );
      }
    }
    // On success the router redirect moves the user to their role home.
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = ref.watch(authControllerProvider.select((s) => s.isSubmitting));

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.verified_user,
                          size: 64, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 12),
                      Text(l10n.appName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(l10n.tagline,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 32),
                      Text(l10n.welcomeBack,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _phone,
                        label: l10n.phoneNumber,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        validator: (v) => _msg(l10n, Validators.phone(v)),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _password,
                        label: l10n.password,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        onSubmitted: (_) => _submit(),
                        validator: (v) => _msg(l10n, Validators.password(v)),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: l10n.signIn,
                        isLoading: isSubmitting,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
