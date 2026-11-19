import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_4/payment_methods_page.dart';
import 'package:flutter_application_4/settings_page.dart';

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
}

void main() {
  group('SettingsPage', () {
    testWidgets('renders all sections and version info', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Backcountry Tier'), findsOneWidget);
      expect(find.text('alex.morgan@basecamp.io'), findsOneWidget);
      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('Email Notifications'), findsOneWidget);
      expect(find.text('Rental Reminder Alarms'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);

      await _scrollTo(tester, find.text('SUPPORT & ABOUT'));
      expect(find.text('SUPPORT & ABOUT'), findsOneWidget);
      expect(find.text('Help Center & FAQ'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Terms & Conditions'), findsOneWidget);

      await _scrollTo(tester, find.text('v2.4.0 (Build 184)'));
      expect(find.text('v2.4.0 (Build 184)'), findsOneWidget);

      await _scrollTo(tester, find.text('Log Out'));
      expect(find.text('Log Out'), findsOneWidget);
    });

    testWidgets('toggling a switch shows a toast', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      expect(find.text('Push notifications disabled'), findsOneWidget);
    });

    testWidgets('logout button opens the confirmation dialog',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      await tester.pumpAndSettle();

      await _scrollTo(tester, find.text('Log Out'));
      await tester.tap(find.text('Log Out'));
      await tester.pumpAndSettle();

      expect(find.text('Log out of GEARUP?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });

  group('PaymentMethodsPage', () {
    testWidgets('renders the guarantee banner and saved instruments',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PaymentMethodsPage()));
      await tester.pumpAndSettle();

      expect(find.text('GEAR PROTECTION GUARANTEE'), findsOneWidget);
      expect(find.text('SAVED INSTRUMENTS (4)'), findsOneWidget);
      expect(find.text('Mandiri Virtual Account'), findsOneWidget);
      expect(find.text('BCA Virtual Account'), findsOneWidget);
      expect(find.text('GoPay E-Wallet'), findsOneWidget);
      expect(find.text('DEFAULT'), findsOneWidget);
      expect(find.text('LINKED'), findsOneWidget);

      await _scrollTo(tester, find.text('QRIS Stored Credentials'));
      expect(find.text('QRIS Stored Credentials'), findsOneWidget);

      await _scrollTo(tester, find.text('Add Payment Method'));
      expect(find.text('Add Payment Method'), findsOneWidget);
    });

    testWidgets('set as default shows a toast', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PaymentMethodsPage()));
      await tester.pumpAndSettle();

      expect(find.text('DEFAULT'), findsOneWidget);

      await tester.tap(find.text('Set as Default').first);
      await tester.pumpAndSettle();

      expect(find.text('BCA Virtual Account set as primary.'), findsOneWidget);
    });

    testWidgets('add payment method opens the sheet', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PaymentMethodsPage()));
      await tester.pumpAndSettle();

      await _scrollTo(tester, find.text('Add Payment Method'));
      await tester.tap(find.text('Add Payment Method'));
      await tester.pumpAndSettle();

      expect(find.text('Link Payment Method'), findsOneWidget);
      expect(find.text('Bank VA'), findsOneWidget);
      expect(find.text('E-Wallet'), findsOneWidget);
      expect(find.text('Card'), findsOneWidget);
    });
  });
}
