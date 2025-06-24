import 'package:book_path/audit.dart';
import 'package:book_path/book.dart';

class BookJournal {
  final Book book;
  final BookReadingStatus readingStatus;
  final String coverImageAsset;
  final double? rating;
  final String? summary;
  final String? review;
  final List<String>? quotes;
  final List<String>? characters;
  final Audit audit;

  BookJournal({
    required this.book,
    this.readingStatus = BookReadingStatus.notStarted,
    this.coverImageAsset = '',
    this.rating,
    this.summary,
    this.review,
    this.quotes,
    this.characters,
    Audit? audit,
  }) : audit = audit ?? Audit();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookJournal &&
          runtimeType == other.runtimeType &&
          book == other.book &&
          readingStatus == other.readingStatus &&
          coverImageAsset == other.coverImageAsset &&
          rating == other.rating &&
          summary == other.summary &&
          review == other.review &&
          _listEquals(quotes, other.quotes) &&
          _listEquals(characters, other.characters) &&
          audit == other.audit;

  @override
  int get hashCode => Object.hash(
    book,
    readingStatus,
    coverImageAsset,
    rating,
    summary,
    review,
    _listHash(quotes),
    _listHash(characters),
    audit,
  );

  bool _listEquals(List? a, List? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  int _listHash(List? list) {
    if (list == null) return 0;
    return Object.hashAll(list);
  }

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

  BookJournal copyWith({
    Book? book,
    BookReadingStatus? readingStatus,
    String? coverImageAsset,
    double? rating,
    String? summary,
    String? review,
    List<String>? quotes,
    List<String>? characters,
    Audit? audit,
  }) {
    return BookJournal(
      book: book ?? this.book,
      readingStatus: readingStatus ?? this.readingStatus,
      coverImageAsset: coverImageAsset ?? this.coverImageAsset,
      rating: rating ?? this.rating,
      summary: summary ?? this.summary,
      review: review ?? this.review,
      quotes: quotes ?? this.quotes,
      characters: characters ?? this.characters,
      audit: audit ?? this.audit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book.toJson(),
      'readingStatus': readingStatus.name,
      'coverImageAsset': coverImageAsset,
      'rating': rating,
      'summary': summary,
      'review': review,
      'quotes': quotes,
      'characters': characters,
      'audit': audit.toJson(),
    };
  }

  factory BookJournal.fromJson(Map<String, dynamic> json) {
    return BookJournal(
      book: Book.fromJson(json['book']),
      readingStatus: BookReadingStatus.values.byName(
        json['readingStatus'] ?? 'notStarted',
      ),
      coverImageAsset: json['coverImageAsset'] ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      summary: json['summary'] as String?,
      review: json['review'] as String?,
      quotes: (json['quotes'] as List?)?.cast<String>(),
      characters: (json['characters'] as List?)?.cast<String>(),
      audit: json['audit'] != null ? Audit.fromJson(json['audit']) : Audit(),
    );
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
