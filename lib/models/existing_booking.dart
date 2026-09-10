/// A hardcoded booking used later for date-conflict checks (bonus).
class ExistingBooking {
  const ExistingBooking({
    required this.roomCode,
    required this.checkIn,
    required this.checkOut,
  });

  final String roomCode;
  final DateTime checkIn;
  final DateTime checkOut;
}
