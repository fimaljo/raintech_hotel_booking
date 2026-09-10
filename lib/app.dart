import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/booking_page.dart';
import 'providers/booking_provider.dart';

class RaintechHotelApp extends StatelessWidget {
  const RaintechHotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      child: MaterialApp(
        title: 'Raintech Hotel Booking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A365D),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const BookingPage(),
      ),
    );
  }
}
