import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/booking_provider.dart';

class DateFields extends StatelessWidget {
  const DateFields({super.key});

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime? current,
    required ValueChanged<DateTime> onPicked,
    required DateTime firstDate,
  }) async {
    final now = DateTime.now();
    final initial = current ?? firstDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate) ? firstDate : initial,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  String _label(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }
    return '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    return Row(
      children: [
        Expanded(
          child: _DateButton(
            title: 'Check-in',
            value: _label(provider.checkIn),
            onPressed: () => _pickDate(
              context: context,
              current: provider.checkIn,
              firstDate: today,
              onPicked: provider.setCheckIn,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateButton(
            title: 'Check-out',
            value: _label(provider.checkOut),
            onPressed: () => _pickDate(
              context: context,
              current: provider.checkOut,
              firstDate: provider.checkIn != null
                  ? provider.checkIn!.add(const Duration(days: 1))
                  : today.add(const Duration(days: 1)),
              onPicked: provider.setCheckOut,
            ),
          ),
        ),
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.title,
    required this.value,
    required this.onPressed,
  });

  final String title;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        alignment: Alignment.centerLeft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
