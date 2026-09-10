import 'package:flutter_test/flutter_test.dart';
import 'package:raintech_hotel_booking/models/existing_booking.dart';
import 'package:raintech_hotel_booking/models/room.dart';
import 'package:raintech_hotel_booking/utils/booking_calc.dart';

void main() {
  final now = DateTime(2026, 9, 10);
  const room = Room(
    code: 'R101',
    type: 'Deluxe Room',
    pricePerNight: 3500,
    maxGuests: 2,
  );

  group('validateDates', () {
    test('returns null when dates are incomplete', () {
      expect(
        validateDates(checkIn: DateTime(2026, 9, 12), now: now),
        isNull,
      );
      expect(
        validateDates(checkOut: DateTime(2026, 9, 14), now: now),
        isNull,
      );
    });

    test('rejects past check-in', () {
      expect(
        validateDates(
          checkIn: DateTime(2026, 9, 9),
          checkOut: DateTime(2026, 9, 12),
          now: now,
        ),
        pastCheckInMessage,
      );
    });

    test('allows check-in today', () {
      expect(
        validateDates(
          checkIn: DateTime(2026, 9, 10),
          checkOut: DateTime(2026, 9, 12),
          now: now,
        ),
        isNull,
      );
    });

    test('rejects same-day checkout', () {
      expect(
        validateDates(
          checkIn: DateTime(2026, 9, 12),
          checkOut: DateTime(2026, 9, 12),
          now: now,
        ),
        checkoutOrderMessage,
      );
    });

    test('rejects checkout before check-in', () {
      expect(
        validateDates(
          checkIn: DateTime(2026, 9, 14),
          checkOut: DateTime(2026, 9, 12),
          now: now,
        ),
        checkoutOrderMessage,
      );
    });
  });

  group('nightsBetween and calculateTotalPrice', () {
    test('calculates nights for a valid range', () {
      expect(
        nightsBetween(
          checkIn: DateTime(2026, 9, 12),
          checkOut: DateTime(2026, 9, 15),
          now: now,
        ),
        3,
      );
    });

    test('returns null for invalid ranges', () {
      expect(
        nightsBetween(
          checkIn: DateTime(2026, 9, 12),
          checkOut: DateTime(2026, 9, 12),
          now: now,
        ),
        isNull,
      );
    });

    test('multiplies nights by price per night', () {
      expect(
        calculateTotalPrice(
          checkIn: DateTime(2026, 9, 12),
          checkOut: DateTime(2026, 9, 14),
          room: room,
          now: now,
        ),
        7000,
      );
    });

    test('returns null when room is missing', () {
      expect(
        calculateTotalPrice(
          checkIn: DateTime(2026, 9, 12),
          checkOut: DateTime(2026, 9, 14),
          now: now,
        ),
        isNull,
      );
    });
  });

  group('computeBookingQuote', () {
    test('returns nights and total for a valid room stay', () {
      final quote = computeBookingQuote(
        checkIn: DateTime(2026, 9, 12),
        checkOut: DateTime(2026, 9, 15),
        room: room,
        now: now,
      );

      expect(quote.error, isNull);
      expect(quote.nights, 3);
      expect(quote.total, 10500);
      expect(quote.canBook, isTrue);
    });

    test('returns date validation error', () {
      final quote = computeBookingQuote(
        checkIn: DateTime(2026, 9, 12),
        checkOut: DateTime(2026, 9, 12),
        room: room,
        now: now,
      );

      expect(quote.error, checkoutOrderMessage);
      expect(quote.canBook, isFalse);
    });

    test('returns conflict error when room is already booked', () {
      final quote = computeBookingQuote(
        checkIn: DateTime(2026, 9, 16),
        checkOut: DateTime(2026, 9, 17),
        room: room,
        existingBookings: [
          ExistingBooking(
            roomCode: 'R101',
            checkIn: DateTime(2026, 9, 15),
            checkOut: DateTime(2026, 9, 18),
          ),
        ],
        now: now,
      );

      expect(quote.error, roomConflictMessage);
      expect(quote.canBook, isFalse);
    });
  });

  group('hasBookingConflict', () {
    final bookings = [
      ExistingBooking(
        roomCode: 'R101',
        checkIn: DateTime(2026, 9, 15),
        checkOut: DateTime(2026, 9, 18),
      ),
    ];

    test('detects overlapping stay', () {
      expect(
        hasBookingConflict(
          roomCode: 'R101',
          checkIn: DateTime(2026, 9, 16),
          checkOut: DateTime(2026, 9, 17),
          existingBookings: bookings,
        ),
        isTrue,
      );
    });

    test('allows back-to-back checkout/check-in', () {
      expect(
        hasBookingConflict(
          roomCode: 'R101',
          checkIn: DateTime(2026, 9, 18),
          checkOut: DateTime(2026, 9, 20),
          existingBookings: bookings,
        ),
        isFalse,
      );
    });

    test('ignores other rooms', () {
      expect(
        hasBookingConflict(
          roomCode: 'R102',
          checkIn: DateTime(2026, 9, 16),
          checkOut: DateTime(2026, 9, 17),
          existingBookings: bookings,
        ),
        isFalse,
      );
    });
  });
}
