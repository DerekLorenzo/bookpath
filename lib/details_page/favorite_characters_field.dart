import 'package:flutter/material.dart';

class FavoriteCharactersField extends StatelessWidget {
  final List<String> characters;
  final bool showAllCharacters;
  final VoidCallback onAddCharacter;
  final VoidCallback onToggleShowAll;
  final void Function({required String initial, required int index})
  onEditCharacter;

  const FavoriteCharactersField({
    super.key,
    required this.characters,
    required this.showAllCharacters,
    required this.onAddCharacter,
    required this.onToggleShowAll,
    required this.onEditCharacter,
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
                'Favorite Characters',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add Character',
                onPressed: onAddCharacter,
              ),
              if (characters.length > 2)
                TextButton(
                  onPressed: onToggleShowAll,
                  child: Text(showAllCharacters ? 'Show Less' : 'Show All'),
                ),
            ],
          ),
          ...(showAllCharacters ? characters : characters.take(2).toList())
              .asMap()
              .entries
              .map((entry) {
                final idx = entry.key;
                final character = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(character),
                    onTap: () =>
                        onEditCharacter(initial: character, index: idx),
                  ),
                );
              }),
          if (characters.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No characters yet.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
