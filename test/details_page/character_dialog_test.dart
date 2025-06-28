import 'package:book_path/details_page/character_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'CharacterDialog shows Add Character UI and returns value on Save',
    (WidgetTester tester) async {
      final controller = TextEditingController();
      Map<String, dynamic>? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    dialogResult = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (_) => CharacterDialog(controller: controller),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Open the dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Add Character'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter character name and tap Save
      await tester.enterText(find.byType(TextField), 'Frodo');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Assert on the dialog result directly
      expect(dialogResult, isNotNull);
      expect(dialogResult!['action'], 'save');
      expect(dialogResult!['value'], 'Frodo');
    },
  );

  testWidgets('CharacterDialog shows Edit Character UI and handles Delete', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController(text: 'Samwise');
    Map<String, dynamic>? dialogResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  dialogResult = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (_) => CharacterDialog(
                      controller: controller,
                      initial: 'Samwise',
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Character'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap Delete
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Assert on the dialog result directly
    expect(dialogResult, isNotNull);
    expect(dialogResult!['action'], 'delete');
  });

  testWidgets('CharacterDialog handles Cancel', (WidgetTester tester) async {
    final controller = TextEditingController(text: 'Gandalf');
    Map<String, dynamic>? dialogResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  dialogResult = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (_) => CharacterDialog(
                      controller: controller,
                      initial: 'Gandalf',
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Assert on the dialog result directly
    expect(dialogResult, isNull);
  });
}
