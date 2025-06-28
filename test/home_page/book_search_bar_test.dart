import 'package:book_path/home_page/book_search_bar.dart';
import 'package:book_path/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BookSearchBar', () {
    Future<void> pumpSearchBar(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: MaterialApp(home: Scaffold(body: BookSearchBar())),
        ),
      );
    }

    testWidgets('renders search field and buttons', (
      WidgetTester tester,
    ) async {
      await pumpSearchBar(tester);

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Submit'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    });

    testWidgets('disables Submit button when no book is selected', (
      WidgetTester tester,
    ) async {
      await pumpSearchBar(tester);

      final submitButton = find.widgetWithText(TextButton, 'Submit');
      final buttonWidget = tester.widget<TextButton>(submitButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('Cancel button pops the route', (WidgetTester tester) async {
      bool popped = false;
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: BookSearchBar(),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      popped = true;
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(popped, isFalse);
    });
  });
}
