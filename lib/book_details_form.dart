import 'package:book_path/book_journal.dart';
import 'package:book_path/my_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsForm extends StatefulWidget {
  final BookJournal currentBook;
  final VoidCallback? onBookUpdated;

  BookDetailsForm({super.key, required this.currentBook, this.onBookUpdated});

  @override
  BookDetailsFormState createState() {
    return BookDetailsFormState();
  }
}

class BookDetailsFormState extends State<BookDetailsForm> {
  double _rating = 0.0;
  int _statusIndex = 0;
  List<String> _quotes = [];
  bool _showAllQuotes = false;
  List<String> _characters = [];
  bool _showAllCharacters = false;

  @override
  void initState() {
    super.initState();
    final book = widget.currentBook;
    _summaryController.text = book.summary ?? '';
    _reviewController.text = book.review ?? '';
    _rating = book.rating ?? 0.0;
    _statusIndex = _readingStatusToStatusIndex[book.readingStatus] ?? 0;
    _quotes = List<String>.from(book.quotes ?? []);
    _characters = List<String>.from(book.characters ?? []);
  }

  final _formKey = GlobalKey<FormState>();
  final _summaryController = TextEditingController();
  final _reviewController = TextEditingController();

  final List<Map<String, Object>> _statuses = [
    {"status": "Not Started", "color": Colors.blueAccent},
    {"status": "Reading", "color": Colors.teal},
    {"status": "Finished", "color": Colors.brown.shade300},
  ];

  final Map<String, BookReadingStatus> _statusToReadingStatus = {
    "Not Started": BookReadingStatus.notStarted,
    "Reading": BookReadingStatus.inProgress,
    "Finished": BookReadingStatus.completed,
  };

  final Map<BookReadingStatus, int> _readingStatusToStatusIndex = {
    BookReadingStatus.notStarted: 0,
    BookReadingStatus.inProgress: 1,
    BookReadingStatus.completed: 2,
  };

  void _updateRating(Offset localPosition, double width) {
    // width is the total width of the stars row
    double percent = localPosition.dx.clamp(0, width) / width;
    double newRating = (percent * 5).clamp(0, 5);
    // Round to nearest 0.5
    newRating = (newRating * 2).round() / 2.0;
    setState(() {
      _rating = newRating;
    });
  }

  void _onHorizontalDrag(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
        // Swiped Left
        _statusIndex = (_statusIndex + 1) % _statuses.length;
      } else if (details.primaryVelocity != null &&
          details.primaryVelocity! > 0) {
        // Swiped Right
        _statusIndex = (_statusIndex - 1 + _statuses.length) % _statuses.length;
      }
    });
  }

  Future<void> _showQuoteDialog({String? initial, int? index}) async {
    final controller = TextEditingController(text: initial ?? '');
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(initial == null ? 'Add Quote' : 'Edit Quote'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Quote'),
            autofocus: true,
          ),
        ),
        actions: [
          if (initial != null)
            TextButton(
              onPressed: () {
                setState(() {
                  _quotes.removeAt(index!);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  if (initial == null) {
                    _quotes.add(text);
                  } else {
                    _quotes[index!] = text;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCharacterDialog({String? initial, int? index}) async {
    final controller = TextEditingController(text: initial ?? '');
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(initial == null ? 'Add Character' : 'Edit Character'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Character'),
            autofocus: true,
          ),
        ),
        actions: [
          if (initial != null)
            TextButton(
              onPressed: () {
                setState(() {
                  _characters.removeAt(index!);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  if (initial == null) {
                    _characters.add(text);
                  } else {
                    _characters[index!] = text;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showFullTextDialog(
    String title,
    String text,
    ValueChanged<String> onSave,
  ) async {
    final controller = TextEditingController(text: text);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: TextField(
            controller: controller,
            minLines: 5,
            maxLines: null,
            decoration: InputDecoration(border: OutlineInputBorder()),
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    ThemeData theme = Theme.of(context);
    BookJournal? currentBook = appState.currentBook;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final starSize = 40.0;
                            final totalWidth = starSize * 5;
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onPanDown: (details) => _updateRating(
                                details.localPosition,
                                totalWidth,
                              ),
                              onPanUpdate: (details) => _updateRating(
                                details.localPosition,
                                totalWidth,
                              ),
                              onTapDown: (details) => _updateRating(
                                details.localPosition,
                                totalWidth,
                              ),
                              child: SizedBox(
                                width: totalWidth,
                                height: starSize,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (index) {
                                    double starValue = index + 1;
                                    IconData icon;
                                    if (_rating >= starValue) {
                                      icon = Icons.star;
                                    } else if (_rating >= starValue - 0.5) {
                                      icon = Icons.star_half;
                                    } else {
                                      icon = Icons.star_border;
                                    }
                                    return Icon(
                                      icon,
                                      size: starSize,
                                      color: theme.colorScheme.primary,
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onHorizontalDragEnd: _onHorizontalDrag,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blueGrey.withOpacity(0.1),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _statusIndex =
                                            (_statusIndex -
                                                1 +
                                                _statuses.length) %
                                            _statuses.length;
                                      });
                                    },
                                    child: Icon(
                                      Icons.chevron_left,
                                      color: Colors.blueGrey,
                                      size: 24,
                                    ),
                                  ),
                                  Text(
                                    _statuses[_statusIndex]["status"] as String,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color:
                                              _statuses[_statusIndex]["color"]
                                                  as Color,
                                        ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _statusIndex =
                                            (_statusIndex + 1) %
                                            _statuses.length;
                                      });
                                    },
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Colors.blueGrey,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Favorite Quotes',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: 'Add Quote',
                              onPressed: () => _showQuoteDialog(),
                            ),
                            if (_quotes.length > 2)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showAllQuotes = !_showAllQuotes;
                                  });
                                },
                                child: Text(
                                  _showAllQuotes ? 'Show Less' : 'Show All',
                                ),
                              ),
                          ],
                        ),
                        ...(_showAllQuotes ? _quotes : _quotes.take(2).toList())
                            .asMap()
                            .entries
                            .map((entry) {
                              final idx = entry.key;
                              final quote = entry.value;
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(quote),
                                  onTap: () => _showQuoteDialog(
                                    initial: quote,
                                    index: idx,
                                  ),
                                ),
                              );
                            }),
                        if (_quotes.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'No quotes yet.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Favorite Characters',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: 'Add Character',
                              onPressed: () => _showCharacterDialog(),
                            ),
                            if (_characters.length > 2)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showAllCharacters = !_showAllCharacters;
                                  });
                                },
                                child: Text(
                                  _showAllCharacters ? 'Show Less' : 'Show All',
                                ),
                              ),
                          ],
                        ),
                        ...(_showAllCharacters
                                ? _characters
                                : _characters.take(2).toList())
                            .asMap()
                            .entries
                            .map((entry) {
                              final idx = entry.key;
                              final character = entry.value;
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(character),
                                  onTap: () => _showCharacterDialog(
                                    initial: character,
                                    index: idx,
                                  ),
                                ),
                              );
                            }),
                        if (_characters.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'No characters yet.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => _showFullTextDialog(
                        'Summary',
                        _summaryController.text,
                        (val) {
                          setState(() {
                            _summaryController.text = val;
                          });
                        },
                      ),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _summaryController,
                          maxLines: 5,
                          minLines: 1,
                          decoration: const InputDecoration(
                            labelText: 'Summary',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => _showFullTextDialog(
                        'Review',
                        _reviewController.text,
                        (val) {
                          setState(() {
                            _reviewController.text = val;
                          });
                        },
                      ),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _reviewController,
                          maxLines: 5,
                          minLines: 1,
                          decoration: const InputDecoration(
                            labelText: 'Review',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      final book = widget.currentBook;
                      book.summary = _summaryController.text.isNotEmpty
                          ? _summaryController.text
                          : null;
                      book.review = _reviewController.text.isNotEmpty
                          ? _reviewController.text
                          : null;
                      book.rating = _rating != 0.0 ? _rating : null;
                      book.readingStatus =
                          _statusToReadingStatus[_statuses[_statusIndex]["status"]
                              as String] ??
                          BookReadingStatus.notStarted;
                      book.quotes = _quotes.isNotEmpty
                          ? List<String>.from(_quotes)
                          : null;
                      book.characters = _characters.isNotEmpty
                          ? List<String>.from(_characters)
                          : null;
                      book.audit.updatedAt = DateTime.timestamp();

                      if (widget.onBookUpdated != null) {
                        widget.onBookUpdated!();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Journal updated!',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.65),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.25,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Book'),
                          content: const Text(
                            'Are you sure you want to delete this book? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );

                      if (confirmed == true) {
                        appState.removeBook(currentBook!);
                        if (widget.onBookUpdated != null) {
                          widget.onBookUpdated!();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Book deleted!',
                              style: TextStyle(
                                color: theme.colorScheme.onError,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: theme.colorScheme.error
                                .withOpacity(0.65),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.25,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 6,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
