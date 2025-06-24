import 'package:book_path/audit.dart';
import 'package:book_path/book.dart';

class BookJournal {
  final Book book;
  BookReadingStatus readingStatus = BookReadingStatus.notStarted;
  String coverImageAsset;
  double? rating;
  String? summary;
  String? review;
  List<String>? quotes;
  List<String>? characters;
  Audit audit = Audit();

  BookJournal({required this.book, this.coverImageAsset = ''});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookJournal &&
          runtimeType == other.runtimeType &&
          book == other.book;

  @override
  int get hashCode => book.hashCode;

  @override
  String toString() {
    final props = <String>[
      'book: $book',
      'readingStatus: $readingStatus',
      if (rating != null) 'rating: $rating',
      if (summary != null) 'summary: $summary',
      if (review != null) 'review: $review',
      if (quotes != null) 'quotes: $quotes',
      if (characters != null) 'characters: $characters',
      'audit: $audit',
    ];
    return 'BookJournal(${props.join(', ')})';
  }
}

enum BookReadingStatus {
  notStarted,
  inProgress,
  completed;

  int compareTo(BookReadingStatus other) {
    if (this == other) return 0;
    if (this == BookReadingStatus.inProgress) return -1;
    if (other == BookReadingStatus.inProgress) return 1;
    if (this == BookReadingStatus.completed) return 1;
    if (other == BookReadingStatus.completed) return -1;
    return 0;
  }
}
