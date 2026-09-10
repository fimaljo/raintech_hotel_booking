import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:raintech_hotel_booking/models/room.dart';
import 'package:raintech_hotel_booking/pages/booking_page.dart';
import 'package:raintech_hotel_booking/providers/booking_provider.dart';

void main() {
  testWidgets('shows booking summary when dates and room are valid',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final now = DateTime(2026, 9, 10);
    const room = Room(
      code: 'R101',
      type: 'Deluxe Room',
      pricePerNight: 3500,
      maxGuests: 2,
    );

    final provider = BookingProvider(
      rooms: const [room],
      existingBookings: const [],
      clock: () => now,
    )
      ..setCheckIn(DateTime(2026, 9, 12))
      ..setCheckOut(DateTime(2026, 9, 14))
      ..selectRoom(room);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: BookingPage()),
      ),
    );

    expect(find.text('Booking summary'), findsOneWidget);
    expect(find.text('₹7000'), findsOneWidget);
  });

  testWidgets('shows clear error for invalid date range', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final now = DateTime(2026, 9, 10);
    const room = Room(
      code: 'R101',
      type: 'Deluxe Room',
      pricePerNight: 3500,
      maxGuests: 2,
    );

    final provider = BookingProvider(
      rooms: const [room],
      existingBookings: const [],
      clock: () => now,
    )
      ..setCheckIn(DateTime(2026, 9, 12))
      ..setCheckOut(DateTime(2026, 9, 12));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: BookingPage()),
      ),
    );

    expect(find.text('Check-out must be after check-in.'), findsOneWidget);
    expect(find.text('Booking summary'), findsNothing);
  });
}
