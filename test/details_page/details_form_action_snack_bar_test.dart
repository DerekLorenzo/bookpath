import 'package:book_path/details_page/details_form_action_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DetailsFormActionSnackBar displays message and styles', (
    WidgetTester tester,
  ) async {
    const message = 'Action completed!';
    const bgColor = Colors.green;
    const textColor = Colors.white;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    DetailsFormActionSnackBar(
                      context: context,
                      message: message,
                      backgroundColor: bgColor,
                      textColor: textColor,
                    ),
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        ),
      ),
    );

    // Tap the button to show the SnackBar
    await tester.tap(find.text('Show SnackBar'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(milliseconds: 100)); // Let SnackBar appear

    // Check that the SnackBar message is shown
    expect(find.text(message), findsOneWidget);

    // Check that the SnackBar uses the correct background color and text color
    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, bgColor);

    final textWidget = tester.widget<Text>(find.text(message));
    expect(textWidget.style?.color, textColor);

    // Wait for SnackBar to disappear (duration is 1 second, but allow extra time for animation)
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text(message), findsNothing);
  });
}
