import 'package:book_path/book_journal.dart';
import 'package:book_path/my_app.dart';
import 'package:flutter/material.dart';
import 'package:book_path/book_list_item.dart';
import 'package:provider/provider.dart';

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: constraints.maxWidth);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(
      0.0,
      1.0,
    );

    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect = verticalAlignment.inscribe(
      backgroundSize,
      Offset.zero & listItemSize,
    );

    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(0.0, childRect.top),
      ).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

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
    MyAppState appState = context.watch<MyAppState>();

    return SingleChildScrollView(
      child: Column(
        children: [
          for (final book in bookList)
            GestureDetector(
              onTap: () {
                appState.setCurrentBook(book); // Navigate to BookDetailsPage
                if (onBookSelected != null) onBookSelected!();
              },
              child: BookListItem(
                title: book.book.title,
                author: book.book.authors.join(', '),
                rating: book.rating,
                bookReadingStatus: book.readingStatus,
                coverImageUrl: book.book.coverUrl,
              ),
            ),
        ],
      ),
    );
  }
}
