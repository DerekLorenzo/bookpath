import 'package:book_path/core/app_state.dart';
import 'package:book_path/details_page/book_details_form_action_buttons.dart';
import 'package:book_path/details_page/book_reading_status_selector.dart';
import 'package:book_path/details_page/character_dialog.dart';
import 'package:book_path/details_page/delete_confirmation_dialog.dart';
import 'package:book_path/details_page/details_form_action_snack_bar.dart';
import 'package:book_path/details_page/favorite_characters_field.dart';
import 'package:book_path/details_page/favorite_quotes_field.dart';
import 'package:book_path/details_page/full_text_dialog.dart';
import 'package:book_path/details_page/quote_dialog.dart';
import 'package:book_path/details_page/review_field.dart';
import 'package:book_path/details_page/star_rating_selector.dart';
import 'package:book_path/details_page/summary_field.dart';
import 'package:book_path/models/audit.dart';
import 'package:book_path/models/book_journal.dart';
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

  @override
  void dispose() {
    _summaryController.dispose();
    _reviewController.dispose();
    super.dispose();
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
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) =>
          QuoteDialog(controller: controller, initial: initial),
    );

    if (result != null) {
      setState(() {
        if (result['action'] == 'save') {
          if (initial == null) {
            _quotes.add(result['value'] as String);
          } else if (index != null && index >= 0 && index < _quotes.length) {
            _quotes[index] = result['value'] as String;
          }
        } else if (result['action'] == 'delete') {
          _quotes.removeAt(index!);
        }
      });
    }
  }

  Future<void> _showCharacterDialog({String? initial, int? index}) async {
    TextEditingController controller = TextEditingController(
      text: initial ?? '',
    );
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) =>
          CharacterDialog(controller: controller, initial: initial),
    );

    if (result != null) {
      setState(() {
        if (result['action'] == 'save') {
          if (initial == null) {
            _characters.add(result['value'] as String);
          } else if (index != null &&
              index >= 0 &&
              index < _characters.length) {
            _characters[index] = result['value'] as String;
          }
        } else if (result['action'] == 'delete' && index != null) {
          _characters.removeAt(index);
        }
      });
    }
  }

  Future<void> _showFullTextDialog(
    String title,
    String text,
    ValueChanged<String> onSave,
  ) async {
    final controller = TextEditingController(text: text);
    await showDialog(
      context: context,
      builder: (context) =>
          FullTextDialog(controller: controller, title: title, onSave: onSave),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        StarRatingSelector(
                          rating: _rating,
                          onRatingChanged: (newRating) {
                            setState(() {
                              _rating = newRating;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onHorizontalDragEnd: _onHorizontalDrag,
                            child: BookReadingStatusSelector(
                              statusIndex: _statusIndex,
                              statuses: _statuses,
                              onStatusChanged: (newIndex) {
                                setState(() {
                                  _statusIndex = newIndex;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FavoriteQuotesField(
                    quotes: _quotes,
                    showAllQuotes: _showAllQuotes,
                    onAddQuote: () => _showQuoteDialog(),
                    onToggleShowAll: () {
                      setState(() {
                        _showAllQuotes = !_showAllQuotes;
                      });
                    },
                    onEditQuote:
                        ({required String initial, required int index}) =>
                            _showQuoteDialog(initial: initial, index: index),
                  ),
                  FavoriteCharactersField(
                    characters: _characters,
                    showAllCharacters: _showAllCharacters,
                    onAddCharacter: () => _showCharacterDialog(),
                    onToggleShowAll: () {
                      setState(() {
                        _showAllCharacters = !_showAllCharacters;
                      });
                    },
                    onEditCharacter:
                        ({required String initial, required int index}) =>
                            _showCharacterDialog(
                              initial: initial,
                              index: index,
                            ),
                  ),
                  SummaryField(
                    controller: _summaryController,
                    onTap: () => _showFullTextDialog(
                      'Summary',
                      _summaryController.text,
                      (val) {
                        setState(() {
                          _summaryController.text = val;
                        });
                      },
                    ),
                  ),
                  ReviewField(
                    controller: _reviewController,
                    onTap: () => _showFullTextDialog(
                      'Review',
                      _reviewController.text,
                      (val) {
                        setState(() {
                          _reviewController.text = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          BookDetailsFormActionButtons(
            onSave: () {
              final updatedBook = widget.currentBook.copyWith(
                summary: _summaryController.text.isNotEmpty
                    ? _summaryController.text
                    : null,
                review: _reviewController.text.isNotEmpty
                    ? _reviewController.text
                    : null,
                rating: _rating != 0.0 ? _rating : null,
                readingStatus:
                    _statusToReadingStatus[_statuses[_statusIndex]["status"]
                        as String] ??
                    BookReadingStatus.notStarted,
                quotes: _quotes.isNotEmpty ? List<String>.from(_quotes) : null,
                characters: _characters.isNotEmpty
                    ? List<String>.from(_characters)
                    : null,
                audit: Audit(
                  createdAt: widget.currentBook.audit.createdAt,
                  updatedAt: DateTime.timestamp(),
                ),
              );

              final appState = context.read<AppState>();
              appState.updateBook(updatedBook);

              if (widget.onBookUpdated != null) {
                widget.onBookUpdated!();
              }
              final theme = Theme.of(context);
              ScaffoldMessenger.of(context).showSnackBar(
                DetailsFormActionSnackBar(
                  context: context,
                  message: 'Journal updated!',
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.65),
                  textColor: theme.colorScheme.onPrimary,
                ),
              );
            },
            onDelete: () async {
              final theme = Theme.of(context);
              final appState = context.read<AppState>();
              final currentBook = appState.currentBook;
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => const DeleteConfirmationDialog(),
              );

              if (confirmed == true) {
                if (currentBook != null) {
                  appState.removeBook(currentBook);
                }
                if (widget.onBookUpdated != null) {
                  widget.onBookUpdated!();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  DetailsFormActionSnackBar(
                    context: context,
                    message: 'Book deleted!',
                    backgroundColor: theme.colorScheme.error.withOpacity(0.65),
                    textColor: theme.colorScheme.onError,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
