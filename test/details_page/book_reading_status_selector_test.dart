import 'package:book_path/details_page/book_reading_status_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final statuses = [
    {"status": "Not Started", "color": Colors.grey},
    {"status": "In Progress", "color": Colors.blue},
    {"status": "Completed", "color": Colors.green},
  ];

  testWidgets('BookReadingStatusSelector displays current status', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookReadingStatusSelector(
            statusIndex: 1,
            statuses: statuses,
            onStatusChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('In Progress'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets(
    'BookReadingStatusSelector calls onStatusChanged when left/right icons tapped',
    (WidgetTester tester) async {
      int? changedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookReadingStatusSelector(
              statusIndex: 0,
              statuses: statuses,
              onStatusChanged: (i) {
                changedIndex = i;
              },
            ),
          ),
        ),
      );

      // Tap right icon (should go to index 1)
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      expect(changedIndex, 1);

      // Tap left icon (should wrap to last index)
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();
      expect(changedIndex, 2);
    },
  );
}
