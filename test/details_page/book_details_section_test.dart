import 'package:book_path/details_page/book_details_section.dart';
import 'package:book_path/models/book.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:book_path/models/audit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testBookJournal = BookJournal(
    book: Book('Test Title', ['Author One', 'Author Two'], '123', '2020'),
    audit: Audit(),
  );

  testWidgets(
    'BookDetailsSection shows "No book selected" when currentBook is null',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookDetailsSection(currentBook: null, isWide: false),
          ),
        ),
      );
      expect(find.text('No book selected'), findsOneWidget);
    },
  );

  testWidgets('BookDetailsSection shows book info in wide layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookDetailsSection(currentBook: testBookJournal, isWide: true),
        ),
      ),
    );
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Author One'), findsOneWidget);
    expect(find.text('Author Two'), findsOneWidget);
    expect(find.text('2020'), findsOneWidget);
    // Should use a Column in wide layout
    expect(find.byType(Column), findsWidgets);
  });

  testWidgets('BookDetailsSection shows book info in narrow layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookDetailsSection(currentBook: testBookJournal, isWide: false),
        ),
      ),
    );
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Author One'), findsOneWidget);
    expect(find.text('Author Two'), findsOneWidget);
    expect(find.text('2020'), findsOneWidget);
    // Should use a Row in narrow layout
    expect(find.byType(Row), findsWidgets);
  });
}
