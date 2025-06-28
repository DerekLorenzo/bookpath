import 'package:book_path/core/app_state.dart';
import 'package:book_path/details_page/book_details_page.dart';
import 'package:book_path/details_page/book_details_form.dart';
import 'package:book_path/details_page/book_details_section.dart';
import 'package:book_path/models/book.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:book_path/models/audit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  Widget createTestWidget(Widget child, {BookJournal? currentBook}) {
    return ChangeNotifierProvider<AppState>(
      create: (_) {
        final appState = AppState();
        if (currentBook != null) {
          appState.bookList.add(currentBook);
          appState.setCurrentBook(currentBook);
        }
        return appState;
      },
      child: MaterialApp(home: child),
    );
  }

  final testBookJournal = BookJournal(
    book: Book('Test Title', ['Author'], '123', '2020'),
    audit: Audit(),
  );

  testWidgets(
    'BookDetailsPage shows BookDetailsForm and BookDetailsSection when currentBook is set (narrow screen)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const BookDetailsPage(), currentBook: testBookJournal),
      );

      expect(find.byType(BookDetailsSection), findsOneWidget);
      expect(find.byType(BookDetailsForm), findsOneWidget);
    },
  );

  testWidgets(
    'BookDetailsPage shows only BookDetailsSection when currentBook is null (narrow screen)',
    (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const BookDetailsPage()));

      expect(find.byType(BookDetailsSection), findsOneWidget);
      expect(find.byType(BookDetailsForm), findsNothing);
    },
  );

  testWidgets('BookDetailsPage shows wide layout when screen is wide', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    await tester.pumpWidget(
      createTestWidget(const BookDetailsPage(), currentBook: testBookJournal),
    );

    expect(find.byType(Row), findsWidgets);
    expect(find.byType(BookDetailsSection), findsOneWidget);
    expect(find.byType(BookDetailsForm), findsOneWidget);

    // Reset surface size after test
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('BookDetailsPage calls onBookUpdated callback', (
    WidgetTester tester,
  ) async {
    bool updatedCalled = false;
    await tester.pumpWidget(
      createTestWidget(
        BookDetailsPage(
          onBookUpdated: () {
            updatedCalled = true;
          },
        ),
        currentBook: testBookJournal,
      ),
    );

    // Tap Save button in BookDetailsForm
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();
    expect(updatedCalled, isTrue);
  });
}
