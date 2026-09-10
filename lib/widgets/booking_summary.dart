import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/booking_provider.dart';
import '../utils/booking_calc.dart';

class BookingSummary extends StatelessWidget {
  const BookingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final scheme = Theme.of(context).colorScheme;

    if (provider.validationError != null) {
      return _MessageCard(
        color: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
        icon: Icons.error_outline,
        message: provider.validationError!,
      );
    }

    if (provider.guidanceMessage != null) {
      return _MessageCard(
        color: scheme.surfaceContainerHighest,
        foreground: scheme.onSurface,
        icon: Icons.info_outline,
        message: provider.guidanceMessage!,
      );
    }

    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              label: 'Room',
              value:
                  '${provider.selectedRoom!.code} · ${provider.selectedRoom!.type}',
            ),
            _SummaryRow(
              label: 'Nights',
              value: '${provider.nights}',
            ),
            _SummaryRow(
              label: 'Rate',
              value:
                  '${formatRupees(provider.selectedRoom!.pricePerNight)} / night',
            ),
            const Divider(height: 24),
            _SummaryRow(
              label: 'Total',
              value: formatRupees(provider.total!),
              emphasize: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            )
        : Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.color,
    required this.foreground,
    required this.icon,
    required this.message,
  });

  final Color color;
  final Color foreground;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: foreground),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: foreground,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
