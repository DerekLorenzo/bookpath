import 'package:book_path/book_details_page.dart';
import 'package:flutter/material.dart';
import 'package:book_path/book_list_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String bookListPageLabel = 'Home';
    final String bookDetailsPageLabel = 'Book';
    final IconData bookListPageIcon = Icons.home;
    final IconData bookDetailsPageIcon = Icons.menu_book;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 1:
        page = BookDetailsPage(onBookUpdated: () => setSelectedIndex(0));
      default:
        page = BookListPage(onBookSelected: () => setSelectedIndex(1));
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return mainArea;
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(bookListPageIcon),
                        label: Text(bookListPageLabel),
                      ),
                      NavigationRailDestination(
                        icon: Icon(bookDetailsPageIcon),
                        label: Text(bookDetailsPageLabel),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: (MediaQuery.of(context).size.width < 450)
          ? BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(bookListPageIcon),
                  label: bookListPageLabel,
                ),
                BottomNavigationBarItem(
                  icon: Icon(bookDetailsPageIcon),
                  label: bookDetailsPageLabel,
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            )
          : null,
    );
  }
}
