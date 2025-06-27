import 'dart:convert';
import 'dart:io';
import 'package:book_path/models/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  List<BookJournal> bookList = <BookJournal>[];
  BookJournal? _currentBook;

  static const String _bookListKey = 'bookList';

  AppState() {
    _loadBooks();
  }

  @override
  void notifyListeners() {
    _saveBooks();
    super.notifyListeners();
  }

  BookJournal? get currentBook => _currentBook;

  List<BookJournal> get sortedBookList {
    final list = bookList.toList();
    _sortBookList(list);
    return list;
  }

  Future<void> addBook([BookJournal? book]) async {
    if (book != null &&
        !bookList.any((bookJournal) => bookJournal.book == book.book)) {
      String? coverImageAsset;
      try {
        if (book.book.coverUrl.isNotEmpty) {
          coverImageAsset = await _downloadAndSaveImage(
            book.book.coverUrl,
            book.book.coverId,
          );
        }
      } catch (e) {
        debugPrint('Failed to download cover image: $e');
      }

      final newBook = book.copyWith(coverImageAsset: coverImageAsset);
      bookList.add(newBook);

      _currentBook ??= newBook;
      notifyListeners();
    }
  }

  void updateBook(BookJournal updatedBook) {
    final index = bookList.indexWhere((b) => b.book == updatedBook.book);
    if (index != -1) {
      bookList[index] = updatedBook;
      if (_currentBook?.book == updatedBook.book) {
        _currentBook = updatedBook;
      }
      notifyListeners();
    }
  }

  void removeBook(BookJournal book) {
    bookList.remove(book);
    if (_currentBook == book) {
      if (bookList.isNotEmpty) {
        _currentBook = bookList.first;
      } else {
        _currentBook = null;
      }
    }
    notifyListeners();
  }

  void setCurrentBook(BookJournal book) {
    if (bookList.contains(book)) {
      _currentBook = book;
      notifyListeners();
    }
  }

  void _sortBookList(List<BookJournal> list) {
    list.sort((a, b) {
      if (a.readingStatus == b.readingStatus) {
        return b.audit.updatedAt.compareTo(a.audit.updatedAt);
      }
      return a.readingStatus.compareTo(b.readingStatus);
    });
  }

  Future<void> _saveBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = jsonEncode(bookList.map((b) => b.toJson()).toList());
      await prefs.setString(_bookListKey, booksJson);
    } catch (e) {
      debugPrint('Error saving books: $e');
    }
  }

  Future<void> _loadBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final booksJson = prefs.getString(_bookListKey);
      if (booksJson != null) {
        final decoded = jsonDecode(booksJson);
        if (decoded is List) {
          bookList = decoded
              .where((e) => e is Map<String, dynamic> || e is Map)
              .map((e) => BookJournal.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          if (bookList.isNotEmpty) {
            _currentBook = bookList.first;
          }
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading books: $e');
    }
  }

  Future<String> _downloadAndSaveImage(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
      rethrow;
    }
  }
}
