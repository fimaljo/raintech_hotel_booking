# Raintech Hotel Booking

Flutter **web** coding exercise for Raintech Software Limited: a single-page hotel room booking UI with date validation, room selection, and nights × price calculation.

## Stack

- Flutter (web)
- Dart
- [provider](https://pub.dev/packages/provider) for state management
- Material 3

## Features

- Hardcoded sample rooms from the brief
- Check-in / check-out date pickers
- Single room selection
- Nights and total price (`nights × price per night`)
- Clear validation errors (past check-in, checkout not after check-in)
- Guest capacity filter (bonus)
- Warn when selected dates conflict with hardcoded existing bookings (bonus)
- Unit tests for calculation and provider; widget tests for summary/errors

## Project structure

```
lib/
  data/rooms.dart                 # sample rooms + existing bookings
  models/                         # Room, ExistingBooking
  utils/booking_calc.dart         # pure validation / nights / total
  providers/booking_provider.dart # ChangeNotifier state
  widgets/                        # date fields, room list, summary
  pages/booking_page.dart
  app.dart / main.dart
test/
  booking_calc_test.dart
  booking_provider_test.dart
  booking_page_test.dart
  widget_test.dart
```

## How to run

```bash
flutter pub get
flutter run -d chrome
```

Optional web build:

```bash
flutter build web
```

## How to test

```bash
flutter test
```

## Notes

- Pricing and date rules live in pure functions (`booking_calc.dart`) so they are easy to unit test without UI.
- `BookingProvider` owns UI state and delegates rules to those functions.
- Widgets use `Selector` so only sections that need updates rebuild.

## What I'd improve with more time

- Better UI/UX: clearer visual hierarchy and feedback
- A couple more edge-case unit tests around date boundaries

These stay inside the current single-page, hardcoded-data design — the brief asked not to add auth, payments, or persistence.

## License

Submitted as a take-home coding exercise.
