import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/payment_status_colors.dart';

enum PaymentStatus { paid, upcoming, overdue }

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<PaymentStatusColors>()!;
    final (label, color, icon) = switch (status) {
      PaymentStatus.paid => (l10n.statusPaid, colors.paid, Icons.check_circle),
      PaymentStatus.upcoming =>
        (l10n.statusUpcoming, colors.upcoming, Icons.schedule),
      PaymentStatus.overdue =>
        (l10n.statusOverdue, colors.overdue, Icons.error),
    };

    // Icon + text, not colour alone, for accessibility.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
