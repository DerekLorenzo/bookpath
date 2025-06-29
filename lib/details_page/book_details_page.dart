import 'package:book_path/core/app_state.dart';
import 'package:book_path/details_page/book_details_form.dart';
import 'package:book_path/details_page/book_details_section.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final isWide = MediaQuery.of(context).size.width >= 600;

    Widget detailsFormSection = (currentBook != null)
        ? BookDetailsForm(
            currentBook: currentBook,
            onBookUpdated: widget.onBookUpdated,
          )
        : const SizedBox.shrink();

    return Scaffold(
      body: isWide
          ? Row(
              children: [
                Expanded(
                  flex: 3,
                  child: BookDetailsSection(
                    currentBook: currentBook,
                    isWide: isWide,
                  ),
                ),
                VerticalDivider(width: 1),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: detailsFormSection,
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  BookDetailsSection(currentBook: currentBook, isWide: isWide),
                  if (currentBook != null) Expanded(child: detailsFormSection),
                ],
              ),
            ),
    );
  }
}
