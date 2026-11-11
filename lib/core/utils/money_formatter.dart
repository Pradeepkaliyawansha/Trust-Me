import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Display-only formatting. Monetary amounts travel as decimal *strings* to and
/// from the API, never as binary doubles, to avoid rounding errors.
class MoneyFormatter {
  const MoneyFormatter._();

  static String format(String decimalAmount, {String locale = 'en'}) {
    final value = double.tryParse(decimalAmount) ?? 0;
    return NumberFormat.currency(
      locale: locale,
      symbol: AppConstants.currencySymbol,
      decimalDigits: 2,
    ).format(value);
  }
}
