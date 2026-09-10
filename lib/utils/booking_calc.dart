import '../models/existing_booking.dart';
import '../models/room.dart';

/// Returns a date with time set to midnight (local).
DateTime dateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Today's date at midnight (local). Injectable [now] keeps tests deterministic.
DateTime today({DateTime? now}) {
  final current = now ?? DateTime.now();
  return dateOnly(current);
}

/// Validates check-in / check-out rules.
///
/// Returns `null` when valid or when dates are incomplete.
/// Returns a human-readable error when the chosen range is invalid.
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
    return 'Check-in cannot be in the past.';
  }

  if (!outDate.isAfter(inDate)) {
    return 'Check-out must be after check-in.';
  }

  return null;
}

/// Number of nights between check-in and check-out (calendar days).
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

/// Total price = nights × room price per night.
int? totalPrice({
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

/// Formats an amount in Indian Rupees.
String formatRupees(int amount) => '₹$amount';

/// True when [checkIn, checkOut) overlaps an existing booking for the same room.
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
