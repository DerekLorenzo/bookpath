import 'package:flutter/material.dart';

class FavoriteQuotesField extends StatelessWidget {
  final List<String> quotes;
  final bool showAllQuotes;
  final VoidCallback onAddQuote;
  final VoidCallback onToggleShowAll;
  final void Function({required String initial, required int index})
  onEditQuote;

  const FavoriteQuotesField({
    super.key,
    required this.quotes,
    required this.showAllQuotes,
    required this.onAddQuote,
    required this.onToggleShowAll,
    required this.onEditQuote,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                onPressed: onAddQuote,
              ),
              if (quotes.length > 2)
                TextButton(
                  onPressed: onToggleShowAll,
                  child: Text(showAllQuotes ? 'Show Less' : 'Show All'),
                ),
            ],
          ),
          ...(showAllQuotes ? quotes : quotes.take(2).toList())
              .asMap()
              .entries
              .map((entry) {
                final idx = entry.key;
                final quote = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(quote),
                    onTap: () => onEditQuote(initial: quote, index: idx),
                  ),
                );
              }),
          if (quotes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No quotes yet.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
