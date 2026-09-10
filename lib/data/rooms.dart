import '../models/existing_booking.dart';
import '../models/room.dart';

/// Sample rooms from the Raintech coding-test brief.
const List<Room> sampleRooms = [
  Room(
    code: 'R101',
    type: 'Deluxe Room',
    pricePerNight: 3500,
    maxGuests: 2,
  ),
  Room(
    code: 'R102',
    type: 'Deluxe Room',
    pricePerNight: 3500,
    maxGuests: 2,
  ),
  Room(
    code: 'R201',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R202',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R301',
    type: 'Family Room',
    pricePerNight: 4200,
    maxGuests: 4,
  ),
];

/// Hardcoded existing bookings for conflict checks (used in a later step).
final List<ExistingBooking> sampleExistingBookings = [
  ExistingBooking(
    roomCode: 'R101',
    checkIn: DateTime(2026, 9, 15),
    checkOut: DateTime(2026, 9, 18),
  ),
  ExistingBooking(
    roomCode: 'R201',
    checkIn: DateTime(2026, 9, 20),
    checkOut: DateTime(2026, 9, 22),
  ),
];
