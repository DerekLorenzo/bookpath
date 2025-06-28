import 'package:book_path/details_page/book_details_form_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BookDetailsFormActionButtons calls onSave and onDelete', (
    WidgetTester tester,
  ) async {
    bool saveCalled = false;
    bool deleteCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookDetailsFormActionButtons(
            onSave: () {
              saveCalled = true;
            },
            onDelete: () async {
              deleteCalled = true;
            },
          ),
        ),
      ),
    );

    // Tap Save button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pump();
    expect(saveCalled, isTrue);

    // Tap Delete button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
    await tester.pump();
    expect(deleteCalled, isTrue);
  });

  testWidgets('BookDetailsFormActionButtons renders both buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookDetailsFormActionButtons(
            onSave: () {},
            onDelete: () async {},
          ),
        ),
      ),
    );

    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Delete'), findsOneWidget);
  });
}
