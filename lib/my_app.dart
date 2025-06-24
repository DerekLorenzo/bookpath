import 'package:book_path/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_path/my_home_page.dart';

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
  Set<BookJournal> bookList = <BookJournal>{};
  BookJournal? _currentBook;

  BookJournal? get currentBook => _currentBook;

  List<BookJournal> get sortedBookList {
    final list = bookList.toList();
    _sortBookList(list);
    return list;
  }

  void addBook([BookJournal? book]) {
    if (book != null && !bookList.contains(book)) {
      bookList.add(book);
      _currentBook ??= book;
    }
    notifyListeners();
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
}
