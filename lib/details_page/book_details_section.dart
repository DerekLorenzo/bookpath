import 'dart:io';
import 'package:book_path/models/book_journal.dart';
import 'package:flutter/material.dart';

class BookDetailsSection extends StatelessWidget {
  final BookJournal? currentBook;
  final bool isWide;

  const BookDetailsSection({
    super.key,
    required this.currentBook,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    if (currentBook?.book == null) {
      return Center(
        child: Text(
          "No book selected",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    if (isWide) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (currentBook?.coverImageAsset != null &&
                  currentBook?.coverImageAsset.isNotEmpty == true)
              ? Image.file(File(currentBook!.coverImageAsset), width: 120)
              : Image.asset("assets/images/no_cover_found.png", width: 120),
          const SizedBox(height: 24),
          Text(
            currentBook!.book.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          ...currentBook!.book.authors.map(
            (author) => Text(
              author,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            currentBook!.book.yearPublished,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    ...currentBook!.book.authors.map(
                      (author) => Text(
                        author,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      currentBook!.book.yearPublished,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
