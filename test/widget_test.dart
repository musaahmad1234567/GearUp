// Smoke test for the GEARUP app shell.
//
// The app starts on the splash screen, which advances to the onboarding
// "Discover" page once its progress bar completes.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_4/main.dart';

void main() {
  testWidgets('app boots into the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GearUpApp());

    expect(find.text('GEARUP'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
  });

  testWidgets('splash NEXT opens the onboarding discover page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GearUpApp());

    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();

    expect(find.text('GEARUP'), findsNothing);
  });
}
