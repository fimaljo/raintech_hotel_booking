import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/booking_provider.dart';
import '../widgets/booking_summary.dart';
import '../widgets/date_fields.dart';
import '../widgets/room_list.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              Text(
                'Raintech Hotel',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Room Booking',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Pick your dates, choose a room, and review the stay total.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 28),
              Text(
                'Stay dates',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              const DateFields(),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Available rooms',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Text('Guests: '),
                  DropdownButton<int?>(
                    value: provider.minGuestsFilter,
                    hint: const Text('Any'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Any')),
                      DropdownMenuItem(value: 2, child: Text('2+')),
                      DropdownMenuItem(value: 3, child: Text('3+')),
                      DropdownMenuItem(value: 4, child: Text('4+')),
                    ],
                    onChanged: provider.setGuestFilter,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const RoomList(),
              const SizedBox(height: 24),
              const BookingSummary(),
            ],
          ),
        ),
      ),
    );
  }
}
