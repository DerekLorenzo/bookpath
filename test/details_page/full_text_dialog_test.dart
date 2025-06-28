import 'package:book_path/details_page/full_text_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FullTextDialog displays title, text field, and handles Save', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();
    String? savedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (_) => FullTextDialog(
                    controller: controller,
                    title: 'Edit Summary',
                    onSave: (value) {
                      savedValue = value;
                    },
                  ),
                );
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Summary'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Enter text and tap Save
    await tester.enterText(find.byType(TextField), 'This is the full summary.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(savedValue, 'This is the full summary.');
  });

  testWidgets('FullTextDialog handles Cancel', (WidgetTester tester) async {
    final controller = TextEditingController(text: 'Initial text');
    bool saveCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (_) => FullTextDialog(
                    controller: controller,
                    title: 'Edit Review',
                    onSave: (_) {
                      saveCalled = true;
                    },
                  ),
                );
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Review'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(saveCalled, isFalse);
  });
}
