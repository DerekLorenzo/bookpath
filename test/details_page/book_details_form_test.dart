import 'package:book_path/core/app_state.dart';
import 'package:book_path/details_page/book_details_form.dart';
import 'package:book_path/details_page/book_reading_status_selector.dart';
import 'package:book_path/details_page/favorite_characters_field.dart';
import 'package:book_path/details_page/favorite_quotes_field.dart';
import 'package:book_path/details_page/star_rating_selector.dart';
import 'package:book_path/models/book.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:book_path/models/audit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  final testBookJournal = BookJournal(
    book: Book('Test Title', ['Author'], '123', '2020'),
    audit: Audit(),
  );

  testWidgets('BookDetailsForm renders and displays fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(BookDetailsForm(currentBook: testBookJournal)),
    );

    expect(find.byType(BookDetailsForm), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Summary and Review
    expect(find.byType(StarRatingSelector), findsOneWidget);
    expect(find.byType(BookReadingStatusSelector), findsOneWidget);
    expect(find.byType(FavoriteQuotesField), findsOneWidget);
    expect(find.byType(FavoriteCharactersField), findsOneWidget);
  });

  testWidgets('BookDetailsForm calls onBookUpdated on save', (
    WidgetTester tester,
  ) async {
    bool updatedCalled = false;
    await tester.pumpWidget(
      createTestWidget(
        BookDetailsForm(
          currentBook: testBookJournal,
          onBookUpdated: () {
            updatedCalled = true;
          },
        ),
      ),
    );

    // Tap Save button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();
    expect(updatedCalled, isTrue);
    expect(find.text('Journal updated!'), findsOneWidget);
  });

  testWidgets('BookDetailsForm shows delete confirmation and deletes', (
    WidgetTester tester,
  ) async {
    bool updatedCalled = false;
    await tester.pumpWidget(
      createTestWidget(
        BookDetailsForm(
          currentBook: testBookJournal,
          onBookUpdated: () {
            updatedCalled = true;
          },
        ),
      ),
    );

    // Tap Delete button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
    await tester.pumpAndSettle();

    // Confirm delete dialog appears
    expect(find.byType(AlertDialog), findsOneWidget);

    // Confirm deletion
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(updatedCalled, isTrue);
    expect(find.text('Book deleted!'), findsOneWidget);
  });
}
