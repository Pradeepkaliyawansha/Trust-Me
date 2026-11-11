import '../../../../l10n/generated/app_localizations.dart';

enum UserRole {
  businessOwner('BUSINESS_OWNER'),
  moneyLender('MONEY_LENDER'),
  customer('CUSTOMER'),
  administrator('ADMIN');

  const UserRole(this.apiValue);
  final String apiValue;

  static UserRole fromApi(String value) => UserRole.values.firstWhere(
        (r) => r.apiValue == value,
        orElse: () => UserRole.customer, // least-privileged fallback
      );

  String label(AppLocalizations l10n) => switch (this) {
        UserRole.businessOwner => l10n.roleBusinessOwner,
        UserRole.moneyLender => l10n.roleMoneyLender,
        UserRole.customer => l10n.roleCustomer,
        UserRole.administrator => l10n.roleAdministrator,
      };
}
