import 'package:book_path/details_page/favorite_characters_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'FavoriteCharactersField displays characters and handles add/edit/toggle',
    (WidgetTester tester) async {
      final characters = ['Frodo', 'Samwise', 'Gandalf'];
      bool addCalled = false;
      bool toggleCalled = false;
      String? editedCharacter;
      int? editedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteCharactersField(
              characters: characters,
              showAllCharacters: false,
              onAddCharacter: () {
                addCalled = true;
              },
              onToggleShowAll: () {
                toggleCalled = true;
              },
              onEditCharacter: ({required String initial, required int index}) {
                editedCharacter = initial;
                editedIndex = index;
              },
            ),
          ),
        ),
      );

      // Should display only first two characters
      expect(find.text('Frodo'), findsOneWidget);
      expect(find.text('Samwise'), findsOneWidget);
      expect(find.text('Gandalf'), findsNothing);

      // Tap Add button
      await tester.tap(find.byTooltip('Add Character'));
      expect(addCalled, isTrue);

      // Tap Show All button
      await tester.tap(find.widgetWithText(TextButton, 'Show All'));
      expect(toggleCalled, isTrue);

      // Tap on a character card to edit
      await tester.tap(find.text('Frodo'));
      expect(editedCharacter, 'Frodo');
      expect(editedIndex, 0);
    },
  );

  testWidgets(
    'FavoriteCharactersField shows all characters when showAllCharacters is true',
    (WidgetTester tester) async {
      final characters = ['Frodo', 'Samwise', 'Gandalf'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteCharactersField(
              characters: characters,
              showAllCharacters: true,
              onAddCharacter: () {},
              onToggleShowAll: () {},
              onEditCharacter:
                  ({required String initial, required int index}) {},
            ),
          ),
        ),
      );

      expect(find.text('Frodo'), findsOneWidget);
      expect(find.text('Samwise'), findsOneWidget);
      expect(find.text('Gandalf'), findsOneWidget);

      // Show Less button should be visible
      expect(find.widgetWithText(TextButton, 'Show Less'), findsOneWidget);
    },
  );

  testWidgets('FavoriteCharactersField shows empty state when no characters', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteCharactersField(
            characters: [],
            showAllCharacters: false,
            onAddCharacter: () {},
            onToggleShowAll: () {},
            onEditCharacter: ({required String initial, required int index}) {},
          ),
        ),
      ),
    );

    expect(find.text('No characters yet.'), findsOneWidget);
  });
}
