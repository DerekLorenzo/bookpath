import 'package:book_path/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_path/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'BookPath',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<BookJournal> bookList = <BookJournal>[];
  BookJournal? _currentBook;

  MyAppState() {
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

  void addBook([BookJournal? book]) {
    if (book != null &&
        !bookList.any((bookJournal) => bookJournal.book == book.book)) {
      bookList.add(book);
      _currentBook ??= book;
    }
    notifyListeners();
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
    _currentBook = book;
    notifyListeners();
  }

  void _sortBookList(List<BookJournal> list) {
    list.sort((a, b) {
      if (a.readingStatus == b.readingStatus) {
        print('Sorting by updatedAt');
        return b.audit.updatedAt.compareTo(a.audit.updatedAt);
      }
      print('Sorting by readingStatus');
      return a.readingStatus.compareTo(b.readingStatus);
    });
  }

  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = jsonEncode(bookList.map((b) => b.toJson()).toList());
    await prefs.setString('bookList', booksJson);
  }

  Future<void> _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = prefs.getString('bookList');
    if (booksJson != null) {
      final List decoded = jsonDecode(booksJson);
      bookList = decoded.map((e) => BookJournal.fromJson(e)).toList();
      if (bookList.isNotEmpty) {
        _currentBook = bookList.first;
      }
      notifyListeners();
    }
  }
}
