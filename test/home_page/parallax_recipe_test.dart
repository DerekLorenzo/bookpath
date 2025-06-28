import 'package:book_path/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:book_path/core/app_state.dart';
import 'package:book_path/home_page/parallax_recipe.dart';
import 'package:book_path/models/book_journal.dart';

class FakeBook extends BookJournal {
  FakeBook(String title)
    : super(
        book: Book(title, ['Author'], '', ''),
        rating: 4.0,
        readingStatus: BookReadingStatus.completed,
        coverImageAsset: '',
      );
}

void main() {
  group('ParallaxRecipe', () {
    Future<void> pumpRecipe(
      WidgetTester tester,
      List<BookJournal> books,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: MaterialApp(
            home: Scaffold(body: ParallaxRecipe(bookList: books)),
          ),
        ),
      );
    }

    testWidgets('renders empty column when bookList is empty', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: const Size(400, 800)), // width < 600
              child: Scaffold(body: ParallaxRecipe(bookList: [])),
            ),
          ),
        ),
      );
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('renders a list of books as GestureDetector widgets', (
      tester,
    ) async {
      final books = [FakeBook('Book 1'), FakeBook('Book 2')];
      await pumpRecipe(tester, books);
      expect(find.byType(GestureDetector), findsNWidgets(2));
    });

    testWidgets('calls onBookSelected when a book is tapped', (tester) async {
      bool tapped = false;
      final books = [FakeBook('Book 1')];
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: MaterialApp(
            home: Scaffold(
              body: ParallaxRecipe(
                bookList: books,
                onBookSelected: () => tapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, isTrue);
    });
  });
}
