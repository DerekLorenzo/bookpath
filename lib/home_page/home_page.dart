import 'package:book_path/core/app_state.dart';
import 'package:book_path/home_page/book_search_bar.dart';
import 'package:book_path/home_page/parallax_recipe.dart';
import 'package:book_path/info_page/info_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onBookSelected;

  const HomePage({super.key, this.onBookSelected});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppState appState = context.watch<AppState>();

    return Scaffold(
      appBar: (MediaQuery.of(context).size.width < 450)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0.0,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).hintColor.withOpacity(0.6),
                  ),
                  tooltip: 'Info',
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => InfoPage()));
                  },
                ),
              ],
            )
          : null,
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
            if (MediaQuery.of(context).size.width < 450)
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Image.asset(
                    "assets/images/bookpath_banner_transparent.png",
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
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
      child: Semantics(
        label: 'Add Book Dialog',
        explicitChildNodes: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Add Book',
                        style: Theme.of(context).textTheme.headlineSmall,
                        semanticsLabel: 'Add Book',
                      ),
                      const SizedBox(height: 16),
                      BookSearchBar(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
