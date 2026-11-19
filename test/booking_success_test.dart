import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_4/booking_success_page.dart';

void main() {
  group('BookingSuccessPage', () {
    testWidgets('builds with the default (sample) model', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BookingSuccessPage()),
      );
      expect(find.text('Booking Successful!'), findsOneWidget);
      expect(find.text('CONFIRMED & LOCKED'), findsOneWidget);
      expect(find.text('Hiking Backpack 45L'), findsOneWidget);
      expect(find.text('GR-00142'), findsOneWidget);
      expect(find.text('15 Nov – 18 Nov 2026'), findsOneWidget);
      expect(find.text('Rp85.000'), findsOneWidget);
      expect(find.text('Boulder Basecamp'), findsOneWidget);
      expect(find.text('Automated Locker #14'), findsOneWidget);
      expect(find.text('8492'), findsNothing); // PIN is star-wrapped
      expect(find.text('Inspected & Sanitized Alpine Equipment Guarantee'),
          findsOneWidget);
    });

    testWidgets('renders a custom model (pin visible, custom dates)',
        (tester) async {
      final model = BookingSuccessModel(
        bookingId: 'GR-00999',
        bookingName: 'Tent 2P',
        edition: 'Tent Edition',
        category: 'Shelter',
        image: '',
        displayDate: '1 Jan 2027 – 3 Jan 2027',
        days: 3,
        stationName: 'Alpine Station',
        lockerId: 'Automated Locker #9',
        pin: '0000',
        total: 'Rp100.000',
        paymentMethod: 'Paid via Credit Card',
        steps: const [
          StepItem(title: 'Step one', subtitle: 'Sub one'),
          StepItem(title: 'Step two', subtitle: 'Sub two'),
        ],
      );
      await tester.pumpWidget(
        MaterialApp(home: BookingSuccessPage(model: model)),
      );
      expect(find.text('Booking Successful!'), findsOneWidget);
      expect(find.text('GR-00999'), findsOneWidget);
      expect(find.text('Alpine Station'), findsOneWidget);
      expect(find.text('Automated Locker #9'), findsOneWidget);
      // PIN is shown as star characters.
      expect(find.text('••••'), findsOneWidget);
      expect(find.text('0000'), findsNothing);
      expect(find.text('1 Jan 2027 – 3 Jan 2027'), findsOneWidget);
    });
  });
}
