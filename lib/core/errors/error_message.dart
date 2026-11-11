import '../../l10n/generated/app_localizations.dart';
import 'app_exception.dart';

/// Maps any error to a localized, user-facing message.
String localizedError(AppLocalizations l10n, Object error) {
  if (error is AppException) {
    switch (error.type) {
      case AppExceptionType.network:
        return l10n.errorNetwork;
      case AppExceptionType.timeout:
        return l10n.errorTimeout;
      case AppExceptionType.unauthorized:
      case AppExceptionType.forbidden:
      case AppExceptionType.validation:
      case AppExceptionType.conflict:
      case AppExceptionType.notFound:
        // Backend messages for these are written to be user-safe.
        return error.message.isNotEmpty ? error.message : l10n.errorGeneric;
      case AppExceptionType.server:
      case AppExceptionType.cancelled:
      case AppExceptionType.unknown:
        return l10n.errorGeneric;
    }
  }
  return l10n.errorGeneric;
}
