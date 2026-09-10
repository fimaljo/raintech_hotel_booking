class Room {
  const Room({
    required this.code,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
  });

  final String code;
  final String type;
  final int pricePerNight;
  final int maxGuests;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Room &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() =>
      'Room($code, $type, ₹$pricePerNight/night, max $maxGuests)';
}
