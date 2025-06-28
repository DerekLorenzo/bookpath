import 'package:flutter_test/flutter_test.dart';
import 'package:book_path/models/book.dart';

void main() {
  group('Book', () {
    test('constructor and toString', () {
      final book = Book('Title', ['Author1', 'Author2'], '123', '2020');
      expect(book.title, 'Title');
      expect(book.authors, ['Author1', 'Author2']);
      expect(book.coverId, '123');
      expect(book.yearPublished, '2020');
      expect(book.toString(), 'Title by Author1, Author2 (2020)');
    });

    test('equality and hashCode', () {
      final book1 = Book('Title', ['A'], '1', '2020');
      final book2 = Book('Title', ['A'], '1', '2020');
      final book3 = Book('Other', ['A'], '1', '2020');
      expect(book1, equals(book2));
      expect(book1.hashCode, equals(book2.hashCode));
      expect(book1, isNot(equals(book3)));
    });

    test('coverUrl returns correct url or empty', () {
      final bookWithCover = Book('T', ['A'], '123', '2020');
      final bookNoCover = Book('T', ['A'], '', '2020');
      expect(
        bookWithCover.coverUrl,
        'https://covers.openlibrary.org/b/id/123-L.jpg',
      );
      expect(bookNoCover.coverUrl, '');
    });

    test('toJson and fromJson roundtrip', () {
      final book = Book('T', ['A', 'B'], 'id', '2021');
      final json = book.toJson();
      final fromJson = Book.fromJson(json);
      expect(fromJson, equals(book));
    });
  });
}
