import 'package:flutter_test/flutter_test.dart';
import 'package:raintech_hotel_booking/models/existing_booking.dart';
import 'package:raintech_hotel_booking/models/room.dart';
import 'package:raintech_hotel_booking/providers/booking_provider.dart';
import 'package:raintech_hotel_booking/utils/booking_calc.dart';

void main() {
  final now = DateTime(2026, 9, 10);
  const deluxe = Room(
    code: 'R101',
    type: 'Deluxe Room',
    pricePerNight: 3500,
    maxGuests: 2,
  );
  const suite = Room(
    code: 'R201',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  );
  const family = Room(
    code: 'R301',
    type: 'Family Room',
    pricePerNight: 4200,
    maxGuests: 4,
  );

  BookingProvider buildProvider({
    List<ExistingBooking> existing = const [],
  }) {
    return BookingProvider(
      rooms: const [deluxe, suite, family],
      existingBookings: existing,
      clock: () => now,
    );
  }

  test('starts with empty selection and guidance', () {
    final provider = buildProvider();

    expect(provider.checkIn, isNull);
    expect(provider.selectedRoom, isNull);
    expect(provider.isReadyToBook, isFalse);
    expect(provider.guidanceMessage, contains('check-in'));
  });

  test('computes nights and total when dates and room are valid', () {
    final provider = buildProvider();

    provider.setCheckIn(DateTime(2026, 9, 12));
    provider.setCheckOut(DateTime(2026, 9, 15));
    provider.selectRoom(deluxe);

    expect(provider.validationError, isNull);
    expect(provider.nights, 3);
    expect(provider.totalPrice, 10500);
    expect(provider.isReadyToBook, isTrue);
  });

  test('surfaces date validation errors', () {
    final provider = buildProvider();

    provider.setCheckIn(DateTime(2026, 9, 12));
    provider.setCheckOut(DateTime(2026, 9, 12));
    provider.selectRoom(deluxe);

    expect(provider.validationError, checkoutOrderMessage);
    expect(provider.nights, isNull);
    expect(provider.isReadyToBook, isFalse);
  });

  test('surfaces booking conflict for selected room and dates', () {
    final provider = buildProvider(
      existing: [
        ExistingBooking(
          roomCode: 'R101',
          checkIn: DateTime(2026, 9, 15),
          checkOut: DateTime(2026, 9, 18),
        ),
      ],
    );

    provider.setCheckIn(DateTime(2026, 9, 16));
    provider.setCheckOut(DateTime(2026, 9, 17));
    provider.selectRoom(deluxe);

    expect(provider.validationError, roomConflictMessage);
    expect(provider.isReadyToBook, isFalse);
  });

  test('filters rooms by guest capacity and clears invalid selection', () {
    final provider = buildProvider();

    provider.selectRoom(deluxe);
    provider.setGuestFilter(3);

    expect(provider.filteredRooms, [suite, family]);
    expect(provider.selectedRoom, isNull);
  });

  test('reset clears all booking state', () {
    final provider = buildProvider()
      ..setCheckIn(DateTime(2026, 9, 12))
      ..setCheckOut(DateTime(2026, 9, 14))
      ..selectRoom(deluxe)
      ..setGuestFilter(2);

    provider.reset();

    expect(provider.checkIn, isNull);
    expect(provider.checkOut, isNull);
    expect(provider.selectedRoom, isNull);
    expect(provider.minGuestsFilter, isNull);
  });
}
