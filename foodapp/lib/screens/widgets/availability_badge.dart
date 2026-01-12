import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';

class AvailabilityBadge extends StatelessWidget {
  final bool available;

  const AvailabilityBadge({super.key, required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: available ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        available
            ? AppLocalizations.of(context).t('available')
            : AppLocalizations.of(context).t('outOfStock'),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
