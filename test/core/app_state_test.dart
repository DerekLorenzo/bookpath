import 'package:book_path/core/app_state.dart';
import 'package:book_path/models/book.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:book_path/models/audit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppState', () {
    late AppState appState;
    late BookJournal testBookJournal;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      appState = AppState();
      testBookJournal = BookJournal(
        book: Book('Test Title', ['Author'], '123', '2020'),
        audit: Audit(),
      );
    });

    test('addBook adds a book to the list', () async {
      await appState.addBook(testBookJournal);
      expect(appState.bookList.length, 1);
      expect(appState.bookList.first.book.title, 'Test Title');
    });

    test('addBook does not add duplicate books', () async {
      await appState.addBook(testBookJournal);
      await appState.addBook(testBookJournal);
      expect(appState.bookList.length, 1);
    });

    test('removeBook removes a book from the list', () async {
      await appState.addBook(testBookJournal);
      appState.removeBook(testBookJournal);
      expect(appState.bookList.length, 0);
    });

    test('setCurrentBook sets the current book', () async {
      await appState.addBook(testBookJournal);
      appState.setCurrentBook(testBookJournal);
      expect(appState.currentBook, testBookJournal);
    });

    test('updateBook updates a book in the list', () async {
      await appState.addBook(testBookJournal);
      final updated = testBookJournal.copyWith(summary: 'Updated summary');
      appState.updateBook(updated);
      expect(appState.bookList.first.summary, 'Updated summary');
    });

    test('books are saved and loaded from SharedPreferences', () async {
      await appState.addBook(testBookJournal);
      final newAppState = AppState();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(newAppState.bookList.length, 1);
      expect(newAppState.bookList.first.book.title, 'Test Title');
    });
  });
}
