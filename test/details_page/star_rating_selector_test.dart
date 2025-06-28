import 'package:book_path/details_page/star_rating_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'StarRatingSelector displays correct number of stars and rating',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRatingSelector(rating: 3.5, onRatingChanged: (_) {}),
          ),
        ),
      );

      // Should show 3 full stars, 1 half star, 1 empty star
      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
      expect(icons.where((icon) => icon.icon == Icons.star).length, 3);
      expect(icons.where((icon) => icon.icon == Icons.star_half).length, 1);
      expect(icons.where((icon) => icon.icon == Icons.star_border).length, 1);
    },
  );

  testWidgets('StarRatingSelector calls onRatingChanged when tapped', (
    WidgetTester tester,
  ) async {
    double? newRating;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StarRatingSelector(
            rating: 2.0,
            onRatingChanged: (value) {
              newRating = value;
            },
          ),
        ),
      ),
    );

    // Tap near the right edge (should set rating close to 5)
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(StarRatingSelector)),
    );
    await gesture.moveBy(const Offset(80, 0)); // Move right
    await gesture.up();
    await tester.pump();

    expect(newRating, isNotNull);
    expect(newRating! > 2.0, isTrue);
  });

  testWidgets('StarRatingSelector uses custom color and size', (
    WidgetTester tester,
  ) async {
    const customColor = Colors.red;
    const customSize = 32.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StarRatingSelector(
            rating: 4.0,
            onRatingChanged: (_) {},
            color: customColor,
            starSize: customSize,
          ),
        ),
      ),
    );

    final icons = tester.widgetList<Icon>(find.byType(Icon));
    for (final icon in icons) {
      expect(icon.color, customColor);
      expect(icon.size, customSize);
    }
  });

  testWidgets('StarRatingSelector asserts rating bounds', (
    WidgetTester tester,
  ) async {
    expect(
      () => StarRatingSelector(rating: -1, onRatingChanged: (_) {}),
      throwsAssertionError,
    );
    expect(
      () => StarRatingSelector(rating: 6, onRatingChanged: (_) {}),
      throwsAssertionError,
    );
  });
}
