import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Theme extension so status colours adapt to light/dark mode.
@immutable
class PaymentStatusColors extends ThemeExtension<PaymentStatusColors> {
  const PaymentStatusColors({
    required this.paid,
    required this.upcoming,
    required this.overdue,
  });

  final Color paid;
  final Color upcoming;
  final Color overdue;

  static const light = PaymentStatusColors(
    paid: AppColors.success,
    upcoming: Color(0xFFB36B00),
    overdue: AppColors.danger,
  );

  static const dark = PaymentStatusColors(
    paid: Color(0xFF4CD08A),
    upcoming: Color(0xFFFFC857),
    overdue: Color(0xFFFF7A70),
  );

  @override
  PaymentStatusColors copyWith({Color? paid, Color? upcoming, Color? overdue}) =>
      PaymentStatusColors(
        paid: paid ?? this.paid,
        upcoming: upcoming ?? this.upcoming,
        overdue: overdue ?? this.overdue,
      );

  @override
  PaymentStatusColors lerp(ThemeExtension<PaymentStatusColors>? other, double t) {
    if (other is! PaymentStatusColors) return this;
    return PaymentStatusColors(
      paid: Color.lerp(paid, other.paid, t)!,
      upcoming: Color.lerp(upcoming, other.upcoming, t)!,
      overdue: Color.lerp(overdue, other.overdue, t)!,
    );
  }
}
