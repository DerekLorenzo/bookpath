import 'dart:convert';

import 'package:book_path/core/app_state.dart';
import 'package:book_path/models/book.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BookSearchBar extends StatefulWidget {
  const BookSearchBar({super.key});

  @override
  _BookSearchBarState createState() => _BookSearchBarState();
}

class _BookSearchBarState extends State<BookSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Set<Book> _books = <Book>{};
  Book? selectedBook;

  Future<void> _getBooks() async {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      final response = await http.get(
        Uri.parse('https://openlibrary.org/search.json?q=$query'),
      );

      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
        final books = bodyJson['docs'] as List<dynamic>;

        setState(() {
          _books.clear();
          for (final book in books) {
            _books.add(
              Book(
                book['title'] as String,
                List<String>.from(book['author_name'] ?? []),
                book['cover_i']?.toString() ?? '',
                book['first_publish_year']?.toString() ?? '',
              ),
            );
            if (_books.length >= 10) {
              break; // Limit to 10 books
            }
          }
        });
        print(_books);
      }
    }
  }

  bool _isSelectedBookNull(Book? selectedBook) {
    print('Checking if selected book is null: $selectedBook');
    return selectedBook == null;
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 64,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Search for books',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _getBooks(),
                  ),
                ),
              ),
              IconButton(icon: Icon(Icons.search), onPressed: _getBooks),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books.elementAt(index);
                final isSelected = selectedBook == book;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBook = book;
                      print('Selected book: $selectedBook');
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.08)
                          : Colors.transparent,
                    ),
                    child: ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.authors.join(', ')),
                      leading: book.coverId.isNotEmpty
                          ? Image.network(
                              book.coverUrl,
                              width: 50,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: theme.colorScheme.primary,
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                            )
                          : Image.asset(
                              'assets/images/no_cover_found.png',
                              width: 50,
                            ),
                      onTap: () {
                        setState(() {
                          selectedBook = book;
                          print('Selected book: $selectedBook');
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 64,
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      disabledBackgroundColor: Colors.grey[600],
                      disabledForegroundColor: Colors.grey[300],
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isSelectedBookNull(selectedBook)
                        ? null
                        : () {
                            appState.addBook(BookJournal(book: selectedBook!));
                            Navigator.pop(context);
                          },
                    child: const Text('Submit'),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
