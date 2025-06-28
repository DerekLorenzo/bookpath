import 'package:flutter/foundation.dart';

class Book {
  final String title;
  final List<String> authors;
  final String coverId;
  final String yearPublished;

  Book(this.title, this.authors, this.coverId, this.yearPublished);

  @override
  String toString() => '$title by ${authors.join(', ')} ($yearPublished)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Book) return false;
    return title == other.title &&
        listEquals(authors, other.authors) &&
        yearPublished == other.yearPublished;
  }

  @override
  int get hashCode =>
      Object.hash(title, Object.hashAll(authors), yearPublished);

  String get coverUrl {
    if (coverId.isEmpty) return '';
    return 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'authors': authors,
    'coverId': coverId,
    'yearPublished': yearPublished,
  };

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    json['title'] as String,
    (json['authors'] as List<dynamic>).cast<String>(),
    json['coverId'] as String,
    json['yearPublished'] as String,
  );
}
