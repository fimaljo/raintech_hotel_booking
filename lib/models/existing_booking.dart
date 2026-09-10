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
