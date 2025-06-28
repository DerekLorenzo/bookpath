import 'package:flutter_test/flutter_test.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:book_path/models/book.dart';
import 'package:book_path/models/audit.dart';

void main() {
  group('BookJournal', () {
    final book = Book('Title', ['Author'], '123', '2020');
    final audit = Audit();

    test('constructor and equality', () {
      final journal1 = BookJournal(
        book: book,
        rating: 4.5,
        summary: 'A',
        review: 'B',
        quotes: ['Q'],
        characters: ['C'],
        audit: audit,
      );
      final journal2 = BookJournal(
        book: book,
        rating: 4.5,
        summary: 'A',
        review: 'B',
        quotes: ['Q'],
        characters: ['C'],
        audit: audit,
      );
      expect(journal1, equals(journal2));
      expect(journal1.hashCode, equals(journal2.hashCode));
    });

    test('copyWith returns a modified copy', () {
      final journal = BookJournal(book: book, rating: 3.0);
      final copy = journal.copyWith(rating: 5.0, summary: 'Updated');
      expect(copy.rating, 5.0);
      expect(copy.summary, 'Updated');
      expect(copy.book, book);
    });

    test('toJson and fromJson roundtrip', () {
      final journal = BookJournal(
        book: book,
        readingStatus: BookReadingStatus.completed,
        coverImageAsset: 'asset.png',
        rating: 4.0,
        summary: 'Summary',
        review: 'Review',
        quotes: ['Q1', 'Q2'],
        characters: ['C1', 'C2'],
        audit: audit,
      );
      final json = journal.toJson();
      final fromJson = BookJournal.fromJson(json);
      expect(fromJson, equals(journal));
    });

    test('toString contains key fields', () {
      final journal = BookJournal(
        book: book,
        rating: 2.0,
        summary: 'S',
        review: 'R',
      );
      final str = journal.toString();
      expect(str, contains('book:'));
      expect(str, contains('rating: 2.0'));
      expect(str, contains('summary: S'));
      expect(str, contains('review: R'));
    });

    test('BookReadingStatus compareTo works as expected', () {
      expect(
        BookReadingStatus.notStarted.compareTo(BookReadingStatus.notStarted),
        0,
      );
      expect(
        BookReadingStatus.inProgress.compareTo(BookReadingStatus.completed),
        -1,
      );
      expect(
        BookReadingStatus.completed.compareTo(BookReadingStatus.notStarted),
        1,
      );
    });
  });
}
