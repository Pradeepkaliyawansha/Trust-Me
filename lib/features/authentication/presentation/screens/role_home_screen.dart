import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_controller.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/auth_controller.dart';
import '../../domain/entities/user_role.dart';

/// Role landing shell. The role dashboards (Phase 6) replace the body;
/// Phase 1 only proves auth, role routing, localization and sign-out.
class RoleHomeScreen extends ConsumerWidget {
  const RoleHomeScreen({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(role.label(l10n)),
        actions: [
          PopupMenuButton<Locale>(
            tooltip: l10n.language,
            icon: const Icon(Icons.language),
            onSelected: ref.read(localeControllerProvider.notifier).setLocale,
            itemBuilder: (_) => [
              for (final (locale, name) in supportedLanguageOptions)
                PopupMenuItem(value: locale, child: Text(name)),
            ],
          ),
          IconButton(
            tooltip: l10n.signOut,
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.welcomeUser(user?.fullName ?? '')),
                subtitle: Text(user?.phone ?? ''),
              ),
            ),
          ),
          const Expanded(child: EmptyView()),
        ],
      ),
    );
  }
}
