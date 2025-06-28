import 'package:book_path/details_page/summary_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SummaryField displays label and calls onTap', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController(text: 'Initial summary');
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SummaryField(
            controller: controller,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // Should display the label
    expect(find.text('Summary'), findsOneWidget);

    // Should display the initial text
    expect(find.text('Initial summary'), findsOneWidget);

    // Tap the field (should call onTap)
    await tester.tap(find.byType(GestureDetector));
    expect(tapped, isTrue);
  });

  testWidgets('SummaryField uses validator if provided', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();

    String? validator(String? value) {
      if (value == null || value.isEmpty) return 'Summary required';
      return null;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: SummaryField(
              controller: controller,
              onTap: () {},
              validator: validator,
            ),
          ),
        ),
      ),
    );

    // Trigger validation
    final formState = tester.firstState<FormState>(find.byType(Form));
    formState.validate();
    await tester.pump();

    expect(find.text('Summary required'), findsOneWidget);
  });
}
