import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raintech_hotel_booking/app.dart';

void main() {
  testWidgets('booking page loads with room list', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const RaintechHotelApp());

    expect(find.text('Raintech Hotel'), findsOneWidget);
    expect(find.text('Room Booking'), findsOneWidget);
    expect(find.textContaining('R101'), findsOneWidget);
    expect(
      find.text('Select check-in and check-out dates to see pricing.'),
      findsOneWidget,
    );
  });
}
