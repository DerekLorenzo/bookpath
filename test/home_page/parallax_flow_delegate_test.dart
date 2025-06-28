import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_path/home_page/parallax_flow_delegate.dart';

// Minimal fake for ScrollableState that avoids using .position
class FakeScrollableState implements ScrollableState {
  @override
  ScrollPosition get position => _FakeScrollPosition();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _FakeScrollPosition implements ScrollPosition {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ParallaxFlowDelegate', () {
    test('getConstraintsForChild returns tight constraints with maxWidth', () {
      // Use a real ScrollableState for the constructor, but don't call .position
      final delegate = ParallaxFlowDelegate(
        scrollable: FakeScrollableState() as ScrollableState,
        listItemContext: FakeBuildContext(),
        backgroundImageKey: GlobalKey(),
      );
      final constraints = BoxConstraints(maxWidth: 123, maxHeight: 456);
      final childConstraints = delegate.getConstraintsForChild(0, constraints);
      expect(childConstraints.maxWidth, 123);
      expect(childConstraints.maxHeight, double.infinity);
    });

    test('shouldRepaint returns true if any dependency changes', () {
      final scrollable = FakeScrollableState() as ScrollableState;
      final context = FakeBuildContext();
      final key = GlobalKey();
      final delegate1 = ParallaxFlowDelegate(
        scrollable: scrollable,
        listItemContext: context,
        backgroundImageKey: key,
      );
      final delegate2 = ParallaxFlowDelegate(
        scrollable: FakeScrollableState() as ScrollableState,
        listItemContext: context,
        backgroundImageKey: key,
      );
      expect(delegate1.shouldRepaint(delegate2), isTrue);
    });
  });
}
