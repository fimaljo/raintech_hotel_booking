import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/existing_booking.dart';
import '../models/room.dart';
import '../providers/booking_provider.dart';
import '../utils/booking_calc.dart';

class _RoomListView {
  const _RoomListView({
    required this.rooms,
    required this.selectedCode,
    required this.checkIn,
    required this.checkOut,
    required this.existingBookings,
    required this.dateError,
  });

  final List<Room> rooms;
  final String? selectedCode;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final List<ExistingBooking> existingBookings;
  final String? dateError;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _RoomListView &&
          selectedCode == other.selectedCode &&
          checkIn == other.checkIn &&
          checkOut == other.checkOut &&
          dateError == other.dateError &&
          _sameRooms(rooms, other.rooms);

  @override
  int get hashCode => Object.hash(
        selectedCode,
        checkIn,
        checkOut,
        dateError,
        Object.hashAll(rooms.map((room) => room.code)),
      );

  static bool _sameRooms(List<Room> a, List<Room> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].code != b[i].code) {
        return false;
      }
    }
    return true;
  }
}

class RoomList extends StatelessWidget {
  const RoomList({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BookingProvider, _RoomListView>(
      selector: (_, provider) => _RoomListView(
        rooms: provider.filteredRooms,
        selectedCode: provider.selectedRoom?.code,
        checkIn: provider.checkIn,
        checkOut: provider.checkOut,
        existingBookings: provider.existingBookings,
        dateError: provider.dateValidationError,
      ),
      builder: (context, view, _) {
        if (view.rooms.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No rooms match the selected guest filter.'),
            ),
          );
        }

        return Column(
          children: [
            for (final room in view.rooms) ...[
              _RoomCard(
                room: room,
                selected: view.selectedCode == room.code,
                conflicted: _isConflicted(view, room),
                onTap: () => context.read<BookingProvider>().selectRoom(room),
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }

  bool _isConflicted(_RoomListView view, Room room) {
    if (view.checkIn == null ||
        view.checkOut == null ||
        view.dateError != null) {
      return false;
    }
    return hasBookingConflict(
      roomCode: room.code,
      checkIn: view.checkIn!,
      checkOut: view.checkOut!,
      existingBookings: view.existingBookings,
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
