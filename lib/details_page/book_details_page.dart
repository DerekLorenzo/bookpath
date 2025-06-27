import 'package:book_path/core/app_state.dart';
import 'package:book_path/details_page/book_details_form.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class BookDetailsPage extends StatefulWidget {
  final VoidCallback? onBookUpdated;

  const BookDetailsPage({super.key, this.onBookUpdated});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
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
                        (currentBook?.coverImageAsset != null &&
                                currentBook?.coverImageAsset.isNotEmpty == true)
                            ? Image.file(
                                File(currentBook!.coverImageAsset),
                                width: MediaQuery.of(context).size.width * 0.33,
                              )
                            : Image.asset(
                                "assets/images/no_cover_found.png",
                                width: MediaQuery.of(context).size.width * 0.33,
                              ),
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
