import '../models/existing_booking.dart';
import '../models/room.dart';

DateTime dateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

DateTime today({DateTime? now}) {
  final current = now ?? DateTime.now();
  return dateOnly(current);
}

const String pastCheckInMessage = 'Check-in cannot be in the past.';
const String checkoutOrderMessage = 'Check-out must be after check-in.';
const String roomConflictMessage =
    'This room is already booked for the selected dates.';

class BookingQuote {
  const BookingQuote({
    this.error,
    this.nights,
    this.total,
  });

  final String? error;
  final int? nights;
  final int? total;

  bool get canBook => error == null && nights != null && total != null;
}

String? validateDates({
  DateTime? checkIn,
  DateTime? checkOut,
  DateTime? now,
}) {
  if (checkIn == null || checkOut == null) {
    return null;
  }

  final inDate = dateOnly(checkIn);
  final outDate = dateOnly(checkOut);
  final todayDate = today(now: now);

  if (inDate.isBefore(todayDate)) {
    return pastCheckInMessage;
  }

  if (!outDate.isAfter(inDate)) {
    return checkoutOrderMessage;
  }

  return null;
}

int? nightsBetween({
  DateTime? checkIn,
  DateTime? checkOut,
  DateTime? now,
}) {
  if (validateDates(checkIn: checkIn, checkOut: checkOut, now: now) != null) {
    return null;
  }
  if (checkIn == null || checkOut == null) {
    return null;
  }

  final inDate = dateOnly(checkIn);
  final outDate = dateOnly(checkOut);
  return outDate.difference(inDate).inDays;
}

int? calculateTotalPrice({
  DateTime? checkIn,
  DateTime? checkOut,
  Room? room,
  DateTime? now,
}) {
  if (room == null) {
    return null;
  }
  final nights = nightsBetween(checkIn: checkIn, checkOut: checkOut, now: now);
  if (nights == null) {
    return null;
  }
  return nights * room.pricePerNight;
}

BookingQuote computeBookingQuote({
  DateTime? checkIn,
  DateTime? checkOut,
  Room? room,
  List<ExistingBooking> existingBookings = const [],
  DateTime? now,
}) {
  final dateError = validateDates(
    checkIn: checkIn,
    checkOut: checkOut,
    now: now,
  );
  if (dateError != null) {
    return BookingQuote(error: dateError);
  }

  if (checkIn == null || checkOut == null) {
    return const BookingQuote();
  }

  if (room != null &&
      hasBookingConflict(
        roomCode: room.code,
        checkIn: checkIn,
        checkOut: checkOut,
        existingBookings: existingBookings,
      )) {
    return const BookingQuote(error: roomConflictMessage);
  }

  final nights = nightsBetween(
    checkIn: checkIn,
    checkOut: checkOut,
    now: now,
  );
  if (nights == null) {
    return const BookingQuote();
  }

  if (room == null) {
    return BookingQuote(nights: nights);
  }

  return BookingQuote(
    nights: nights,
    total: nights * room.pricePerNight,
  );
}

String formatRupees(int amount) => '₹$amount';

/// Stay ranges are half-open: [checkIn, checkOut). Checkout day frees the room.
bool hasBookingConflict({
  required String roomCode,
  required DateTime checkIn,
  required DateTime checkOut,
  required List<ExistingBooking> existingBookings,
}) {
  final start = dateOnly(checkIn);
  final end = dateOnly(checkOut);

  for (final booking in existingBookings) {
    if (booking.roomCode != roomCode) {
      continue;
    }
    final bookedStart = dateOnly(booking.checkIn);
    final bookedEnd = dateOnly(booking.checkOut);
    if (start.isBefore(bookedEnd) && end.isAfter(bookedStart)) {
      return true;
    }
  }
  return false;
}
