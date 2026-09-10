import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/room.dart';
import '../providers/booking_provider.dart';
import '../utils/booking_calc.dart';

class RoomList extends StatelessWidget {
  const RoomList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final rooms = provider.filteredRooms;

    if (rooms.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No rooms match the selected guest filter.'),
        ),
      );
    }

    return Column(
      children: [
        for (final room in rooms) ...[
          _RoomCard(
            room: room,
            selected: provider.selectedRoom?.code == room.code,
            conflicted: _isConflicted(provider, room),
            onTap: () => provider.selectRoom(room),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  bool _isConflicted(BookingProvider provider, Room room) {
    if (provider.checkIn == null ||
        provider.checkOut == null ||
        provider.dateValidationError != null) {
      return false;
    }
    return hasBookingConflict(
      roomCode: room.code,
      checkIn: provider.checkIn!,
      checkOut: provider.checkOut!,
      existingBookings: provider.existingBookings,
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.selected,
    required this.conflicted,
    required this.onTap,
  });

  final Room room;
  final bool selected;
  final bool conflicted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderColor = selected
        ? scheme.primary
        : conflicted
            ? scheme.error.withValues(alpha: 0.5)
            : scheme.outlineVariant;

    return Material(
      color: selected ? scheme.primaryContainer.withValues(alpha: 0.35) : null,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? scheme.primary : scheme.outline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${room.code} · ${room.type}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Max guests: ${room.maxGuests}'
                      '${conflicted ? ' · Booked for selected dates' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: conflicted ? scheme.error : null,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${formatRupees(room.pricePerNight)}/night',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
