import 'package:flutter/foundation.dart';

import '../data/rooms.dart';
import '../models/existing_booking.dart';
import '../models/room.dart';
import '../utils/booking_calc.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider({
    List<Room>? rooms,
    List<ExistingBooking>? existingBookings,
    DateTime Function()? clock,
  })  : _rooms = List.unmodifiable(rooms ?? sampleRooms),
        _existingBookings =
            List.unmodifiable(existingBookings ?? sampleExistingBookings),
        _clock = clock ?? DateTime.now;

  final List<Room> _rooms;
  final List<ExistingBooking> _existingBookings;
  final DateTime Function() _clock;

  DateTime? _checkIn;
  DateTime? _checkOut;
  Room? _selectedRoom;
  int? _minGuestsFilter;

  List<Room> get rooms => _rooms;
  List<ExistingBooking> get existingBookings => _existingBookings;

  DateTime? get checkIn => _checkIn;
  DateTime? get checkOut => _checkOut;
  Room? get selectedRoom => _selectedRoom;
  int? get minGuestsFilter => _minGuestsFilter;

  DateTime get _now => _clock();

  List<Room> get filteredRooms {
    final filter = _minGuestsFilter;
    if (filter == null) {
      return _rooms;
    }
    return _rooms.where((room) => room.maxGuests >= filter).toList();
  }

  BookingQuote get quote => computeBookingQuote(
        checkIn: _checkIn,
        checkOut: _checkOut,
        room: _selectedRoom,
        existingBookings: _existingBookings,
        now: _now,
      );

  String? get dateValidationError => validateDates(
        checkIn: _checkIn,
        checkOut: _checkOut,
        now: _now,
      );

  bool get hasConflict {
    if (_selectedRoom == null || _checkIn == null || _checkOut == null) {
      return false;
    }
    if (dateValidationError != null) {
      return false;
    }
    return hasBookingConflict(
      roomCode: _selectedRoom!.code,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
      existingBookings: _existingBookings,
    );
  }

  String? get validationError => quote.error;

  String? get guidanceMessage {
    if (validationError != null) {
      return null;
    }
    if (_checkIn == null || _checkOut == null) {
      return 'Select check-in and check-out dates to see pricing.';
    }
    if (_selectedRoom == null) {
      return 'Select a room to see the total price.';
    }
    return null;
  }

  int? get nights => quote.nights;

  int? get totalPrice => quote.total;

  bool get isReadyToBook => quote.canBook;

  void setCheckIn(DateTime? date) {
    _checkIn = date == null ? null : dateOnly(date);
    _clearSelectionIfFilteredOut();
    notifyListeners();
  }

  void setCheckOut(DateTime? date) {
    _checkOut = date == null ? null : dateOnly(date);
    _clearSelectionIfFilteredOut();
    notifyListeners();
  }

  void selectRoom(Room? room) {
    _selectedRoom = room;
    notifyListeners();
  }

  void setGuestFilter(int? minGuests) {
    _minGuestsFilter = minGuests;
    _clearSelectionIfFilteredOut();
    notifyListeners();
  }

  void clearSelection() {
    _selectedRoom = null;
    notifyListeners();
  }

  void reset() {
    _checkIn = null;
    _checkOut = null;
    _selectedRoom = null;
    _minGuestsFilter = null;
    notifyListeners();
  }

  void _clearSelectionIfFilteredOut() {
    if (_selectedRoom == null) {
      return;
    }
    final stillVisible =
        filteredRooms.any((room) => room.code == _selectedRoom!.code);
    if (!stillVisible) {
      _selectedRoom = null;
    }
  }
}
