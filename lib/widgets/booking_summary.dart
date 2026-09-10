import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/room.dart';
import '../providers/booking_provider.dart';
import '../utils/booking_calc.dart';

class _SummaryView {
  const _SummaryView({
    required this.error,
    required this.guidance,
    required this.nights,
    required this.total,
    required this.room,
  });

  final String? error;
  final String? guidance;
  final int? nights;
  final int? total;
  final Room? room;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SummaryView &&
          error == other.error &&
          guidance == other.guidance &&
          nights == other.nights &&
          total == other.total &&
          room?.code == other.room?.code;

  @override
  int get hashCode => Object.hash(error, guidance, nights, total, room?.code);
}

class BookingSummary extends StatelessWidget {
  const BookingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BookingProvider, _SummaryView>(
      selector: (_, provider) => _SummaryView(
        error: provider.validationError,
        guidance: provider.guidanceMessage,
        nights: provider.nights,
        total: provider.totalPrice,
        room: provider.selectedRoom,
      ),
      builder: (context, view, _) {
        final scheme = Theme.of(context).colorScheme;

        if (view.error != null) {
          return _MessageCard(
            color: scheme.errorContainer,
            foreground: scheme.onErrorContainer,
            icon: Icons.error_outline,
            message: view.error!,
          );
        }

        if (view.guidance != null) {
          return _MessageCard(
            color: scheme.surfaceContainerHighest,
            foreground: scheme.onSurface,
            icon: Icons.info_outline,
            message: view.guidance!,
          );
        }

        final room = view.room!;
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
                  value: '${room.code} · ${room.type}',
                ),
                _SummaryRow(
                  label: 'Nights',
                  value: '${view.nights}',
                ),
                _SummaryRow(
                  label: 'Rate',
                  value: '${formatRupees(room.pricePerNight)} / night',
                ),
                const Divider(height: 24),
                _SummaryRow(
                  label: 'Total',
                  value: formatRupees(view.total!),
                  emphasize: true,
                ),
              ],
            ),
          ),
        );
      },
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
