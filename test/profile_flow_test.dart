import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_4/edit_profile_page.dart';
import 'package:flutter_application_4/my_address_page.dart';
import 'package:flutter_application_4/profile_page.dart';
import 'package:flutter_application_4/account_store.dart';

void main() {
  group('MyAddressPage', () {
    testWidgets('renders the address list and dispatch banner',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyAddressPage()));
      await tester.pumpAndSettle();

      expect(find.text('Expedition Drop Points'), findsOneWidget);
      expect(find.text('All (3)'), findsOneWidget);
      expect(find.text('Home & Office'), findsOneWidget);
      expect(find.text('Trailhead Lockers'), findsOneWidget);
      expect(find.text('Alex Morgan'), findsWidgets);
      expect(find.text('Default'), findsOneWidget);
      expect(find.text('Add New Address'), findsOneWidget);
    });

    testWidgets('opens the add-address drawer and saves', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyAddressPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add New Address'));
      await tester.pumpAndSettle();

      expect(find.text('Add New Address'), findsWidgets);
      expect(find.text('Save Address'), findsOneWidget);
      expect(find.text('Set as primary address'), findsOneWidget);

      await tester.tap(find.text('Save Address'));
      await tester.pumpAndSettle();
      expect(find.text('Address saved to trail gear profile'), findsOneWidget);
    });
  });

  group('EditProfilePage', () {
    testWidgets('renders identity fields and sizing selectors',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('FULL NAME'), findsOneWidget);
      expect(find.text('EMAIL ADDRESS'), findsOneWidget);
      expect(find.text('PHONE NUMBER'), findsOneWidget);
      expect(find.text('Alpine Expedition Data'), findsOneWidget);
      expect(find.text('BASECAMP LIAISON / EMERGENCY'), findsOneWidget);
      expect(find.text('GEAR SIZING & ERGONOMIC FIT'), findsOneWidget);
      expect(find.text('Backpack Torso Length'), findsOneWidget);
      expect(find.text('Mountaineering Boot Size'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Member Status'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Member Status'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Save Changes'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('save shows the success toast', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Save Changes'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Save Changes'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      expect(find.text('Profile updated successfully!'), findsOneWidget);
    });
  });

  group('ProfilePage navigation', () {
    testWidgets('My Address menu item opens MyAddressPage', (tester) async {
      const account = LocalAccount(
        name: 'Alex Morgan',
        email: 'alexmorgan@email.com',
        phone: '+62 812 3456 7890',
        password: 'x',
      );
      await tester.pumpWidget(
        const MaterialApp(home: ProfilePage(account: account)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('My Address'));
      await tester.pumpAndSettle();

      expect(find.text('Expedition Drop Points'), findsOneWidget);
    });
  });
}
