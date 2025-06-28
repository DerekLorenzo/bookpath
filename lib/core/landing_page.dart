import 'package:book_path/details_page/book_details_page.dart';
import 'package:flutter/material.dart';
import 'package:book_path/home_page/home_page.dart';
import 'package:book_path/info_page/info_page.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
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
    final int bottomNavigationBarWidthThreshold = 450;
    final int navigationRailWidthThreshold = 600;
    final double extendedNavigationRailWidth = 144;
    final double navigationRailWidth = 72;

    Widget page;
    switch (selectedIndex) {
      case 1:
        page = BookDetailsPage(onBookUpdated: () => setSelectedIndex(0));
      default:
        page = HomePage(onBookSelected: () => setSelectedIndex(1));
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
          if (constraints.maxWidth < bottomNavigationBarWidthThreshold) {
            return mainArea;
          } else {
            return Row(
              children: [
                SafeArea(
                  child: SizedBox(
                    width: constraints.maxWidth >= navigationRailWidthThreshold
                        ? extendedNavigationRailWidth
                        : navigationRailWidth,
                    child: Column(
                      children: [
                        if (constraints.maxWidth >
                            bottomNavigationBarWidthThreshold)
                          constraints.maxWidth > navigationRailWidthThreshold
                              ? Image.asset(
                                  "assets/images/bookpath_banner_transparent.png",
                                  width: extendedNavigationRailWidth,
                                )
                              : Image.asset(
                                  "assets/images/bookpath_logo_small.png",
                                  width: navigationRailWidth,
                                ),
                        Expanded(
                          child: NavigationRail(
                            extended:
                                constraints.maxWidth >=
                                navigationRailWidthThreshold,
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
                        // Info button at the bottom of the NavigationRail column (wide only)
                        if (constraints.maxWidth >=
                            bottomNavigationBarWidthThreshold)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Theme.of(
                                  context,
                                ).hintColor.withOpacity(0.6),
                              ),
                              tooltip: 'Info',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => InfoPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
      bottomNavigationBar:
          (MediaQuery.of(context).size.width <
              bottomNavigationBarWidthThreshold)
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
