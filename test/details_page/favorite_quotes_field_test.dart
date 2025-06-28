import 'package:book_path/details_page/favorite_quotes_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'FavoriteQuotesField displays quotes and handles add/edit/toggle',
    (WidgetTester tester) async {
      final quotes = ['Quote 1', 'Quote 2', 'Quote 3'];
      bool addCalled = false;
      bool toggleCalled = false;
      String? editedQuote;
      int? editedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteQuotesField(
              quotes: quotes,
              showAllQuotes: false,
              onAddQuote: () {
                addCalled = true;
              },
              onToggleShowAll: () {
                toggleCalled = true;
              },
              onEditQuote: ({required String initial, required int index}) {
                editedQuote = initial;
                editedIndex = index;
              },
            ),
          ),
        ),
      );

      // Should display only first two quotes
      expect(find.text('Quote 1'), findsOneWidget);
      expect(find.text('Quote 2'), findsOneWidget);
      expect(find.text('Quote 3'), findsNothing);

      // Tap Add button
      await tester.tap(find.byTooltip('Add Quote'));
      expect(addCalled, isTrue);

      // Tap Show All button
      await tester.tap(find.widgetWithText(TextButton, 'Show All'));
      expect(toggleCalled, isTrue);

      // Tap on a quote card to edit
      await tester.tap(find.text('Quote 1'));
      expect(editedQuote, 'Quote 1');
      expect(editedIndex, 0);
    },
  );

  testWidgets(
    'FavoriteQuotesField shows all quotes when showAllQuotes is true',
    (WidgetTester tester) async {
      final quotes = ['Quote 1', 'Quote 2', 'Quote 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteQuotesField(
              quotes: quotes,
              showAllQuotes: true,
              onAddQuote: () {},
              onToggleShowAll: () {},
              onEditQuote: ({required String initial, required int index}) {},
            ),
          ),
        ),
      );

      expect(find.text('Quote 1'), findsOneWidget);
      expect(find.text('Quote 2'), findsOneWidget);
      expect(find.text('Quote 3'), findsOneWidget);

      // Show Less button should be visible
      expect(find.widgetWithText(TextButton, 'Show Less'), findsOneWidget);
    },
  );

  testWidgets('FavoriteQuotesField shows empty state when no quotes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteQuotesField(
            quotes: [],
            showAllQuotes: false,
            onAddQuote: () {},
            onToggleShowAll: () {},
            onEditQuote: ({required String initial, required int index}) {},
          ),
        ),
      ),
    );

    expect(find.text('No quotes yet.'), findsOneWidget);
  });
}
