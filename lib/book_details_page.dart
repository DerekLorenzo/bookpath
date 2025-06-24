import 'package:book_path/book_details_form.dart';
import 'package:book_path/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_path/my_app.dart';

class BookDetailsPage extends StatefulWidget {
  final VoidCallback? onBookUpdated;

  const BookDetailsPage({super.key, this.onBookUpdated});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    BookJournal? currentBook = appState.currentBook;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              (currentBook?.book != null)
                  ? Row(
                      children: [
                        (currentBook?.book.coverUrl != null)
                            ? Image.network(
                                currentBook!.book.coverUrl,
                                width: MediaQuery.of(context).size.width * 0.33,
                              )
                            : Image.asset("assets/no_cover_found.png"),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  Text(
                                    currentBook!.book.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  ...currentBook.book.authors.map(
                                    (author) => Text(
                                      author,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    currentBook.book.yearPublished,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "No book selected",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
              if (currentBook != null)
                Expanded(
                  child: BookDetailsForm(
                    currentBook: currentBook,
                    onBookUpdated: widget.onBookUpdated,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
