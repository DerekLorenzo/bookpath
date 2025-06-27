import 'package:book_path/core/app_state.dart';
import 'package:book_path/home_page/book_list_item.dart';
import 'package:book_path/models/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({
    super.key,
    required this.bookList,
    this.onBookSelected,
  });

  final VoidCallback? onBookSelected;
  final List<BookJournal> bookList;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (MediaQuery.of(context).size.width < 600) {
            return Column(
              children: [
                for (final book in bookList)
                  GestureDetector(
                    onTap: () {
                      appState.setCurrentBook(
                        book,
                      ); // Navigate to BookDetailsPage
                      if (onBookSelected != null) onBookSelected!();
                    },
                    child: BookListItem(
                      title: book.book.title,
                      author: book.book.authors.join(', '),
                      rating: book.rating,
                      bookReadingStatus: book.readingStatus,
                      coverImageAsset: book.coverImageAsset,
                    ),
                  ),
              ],
            );
          } else {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                final book = bookList[index];
                return GestureDetector(
                  onTap: () {
                    appState.setCurrentBook(book);
                    if (onBookSelected != null) onBookSelected!();
                  },
                  child: BookListItem(
                    title: book.book.title,
                    author: book.book.authors.join(', '),
                    rating: book.rating,
                    bookReadingStatus: book.readingStatus,
                    coverImageAsset: book.coverImageAsset,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
