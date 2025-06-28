import 'package:book_path/core/app_state.dart';
import 'package:book_path/core/landing_page.dart';
import 'package:book_path/home_page/home_page.dart';
import 'package:book_path/details_page/book_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(home: child),
    );
  }

  testWidgets('LandingPage shows HomePage by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget(LandingPage()));

    // HomePage should be visible by default
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(BookDetailsPage), findsNothing);
  });

  testWidgets(
    'LandingPage switches to BookDetailsPage when navigation changes',
    (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(LandingPage()));

      // Tap the second item in the BottomNavigationBar or NavigationRail
      if (tester.any(find.byType(BottomNavigationBar))) {
        await tester.tap(find.byIcon(Icons.menu_book));
      } else {
        // For wide screens, NavigationRail is used
        await tester.tap(find.byIcon(Icons.menu_book));
      }
      await tester.pumpAndSettle();

      // BookDetailsPage should now be visible
      expect(find.byType(BookDetailsPage), findsOneWidget);
    },
  );

  testWidgets(
    'LandingPage navigation rail and bottom navigation bar respond to taps',
    (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(LandingPage()));

      // Tap the Home icon to ensure HomePage is shown
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      // Tap the Book icon to switch to BookDetailsPage
      await tester.tap(find.byIcon(Icons.menu_book));
      await tester.pumpAndSettle();
      expect(find.byType(BookDetailsPage), findsOneWidget);
    },
  );
}
