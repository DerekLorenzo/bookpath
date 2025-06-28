import 'package:book_path/core/app.dart';
import 'package:book_path/core/app_state.dart';
import 'package:book_path/core/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App builds and provides AppState', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Check that MaterialApp is present
    expect(find.byType(MaterialApp), findsOneWidget);

    // Check that LandingPage is present
    expect(find.byType(LandingPage), findsOneWidget);

    // Check that AppState is provided
    final BuildContext context = tester.element(find.byType(LandingPage));
    expect(Provider.of<AppState>(context, listen: false), isA<AppState>());
  });
}
