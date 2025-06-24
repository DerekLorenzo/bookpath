import 'package:book_path/book_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:book_path/my_app.dart';
import 'package:provider/provider.dart';
import 'package:book_path/parallax_flow.dart';

class BookListPage extends StatelessWidget {
  final VoidCallback? onBookSelected;

  const BookListPage({super.key, this.onBookSelected});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MyAppState appState = context.watch<MyAppState>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => _addBookDialog(context),
        ),
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/bookpath_banner_transparent.png",
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
            (appState.bookList.isEmpty)
                ? Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    _addBookDialog(context),
                              ),
                              child: Column(
                                children: [
                                  const Text('Add a book'),
                                  const SizedBox(height: 8),
                                  const Icon(Icons.add),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ParallaxRecipe(
                      bookList: appState.sortedBookList,
                      onBookSelected: onBookSelected,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Dialog _addBookDialog(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[const Text('Add Book'), BookSearchBar()],
            );
          },
        ),
      ),
    );
  }
}
