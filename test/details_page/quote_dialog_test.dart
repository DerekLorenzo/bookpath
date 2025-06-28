import 'package:book_path/details_page/quote_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('QuoteDialog shows Add Quote UI and returns value on Save', (
    WidgetTester tester,
  ) async {
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
                    builder: (_) => QuoteDialog(controller: controller),
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

    expect(find.text('Add Quote'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Enter quote and tap Save
    await tester.enterText(
      find.byType(TextField),
      'The road goes ever on and on.',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Assert on the dialog result directly
    expect(dialogResult, isNotNull);
    expect(dialogResult!['action'], 'save');
    expect(dialogResult!['value'], 'The road goes ever on and on.');
  });

  testWidgets('QuoteDialog shows Edit Quote UI and handles Delete', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController(text: 'Old quote');
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
                    builder: (_) => QuoteDialog(
                      controller: controller,
                      initial: 'Old quote',
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

    expect(find.text('Edit Quote'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap Delete
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Assert on the dialog result directly
    expect(dialogResult, isNotNull);
    expect(dialogResult!['action'], 'delete');
  });

  testWidgets('QuoteDialog handles Cancel', (WidgetTester tester) async {
    final controller = TextEditingController(text: 'Some quote');
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
                    builder: (_) => QuoteDialog(
                      controller: controller,
                      initial: 'Some quote',
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
