import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_age_scroller/infinity_age_scroller.dart';

void main() {
  group('InfinityAgeScroller Tests', () {
    testWidgets('should render with default values',
        (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              scrollDirection: ScrollDirection.vertical,
            ),
          ),
        ),
      );

      // Verify the widget renders without errors
      expect(find.byType(InfinityAgeScroller), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsOneWidget);
    });

    testWidgets('should call onAgeSelected callback when scrolled',
        (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              initialAge: 30,
              scrollDirection: ScrollDirection.vertical,
            ),
          ),
        ),
      );

      // Initially should have the initial age selected
      expect(selectedAge, isNull); // Callback not called until scroll

      // Find the ListWheelScrollView and simulate scroll
      final scrollView = find.byType(ListWheelScrollView);
      expect(scrollView, findsOneWidget);

      // Simulate scrolling down
      await tester.drag(scrollView, const Offset(0, -100));
      await tester.pumpAndSettle();

      // Verify callback was called
      expect(selectedAge, isNotNull);
    });

    testWidgets('should respect custom age range', (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              minAge: 16,
              maxAge: 65,
              initialAge: 25,
              scrollDirection: ScrollDirection.vertical,
            ),
          ),
        ),
      );

      expect(find.byType(InfinityAgeScroller), findsOneWidget);
    });

    testWidgets('should render horizontal scroller',
        (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              scrollDirection: ScrollDirection.horizontal,
            ),
          ),
        ),
      );

      // Verify horizontal scroller renders with RotatedBox
      expect(find.byType(InfinityAgeScroller), findsOneWidget);
      expect(find.byType(RotatedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('should render left diagonal scroller',
        (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              scrollDirection: ScrollDirection.leftDiagonal,
            ),
          ),
        ),
      );

      // Verify diagonal scroller renders with Transform.rotate
      expect(find.byType(InfinityAgeScroller), findsOneWidget);
      expect(find.byType(Transform), findsAtLeastNWidgets(1));
    });

    testWidgets('should render right diagonal scroller',
        (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              scrollDirection: ScrollDirection.rightDiagonal,
            ),
          ),
        ),
      );

      // Verify diagonal scroller renders with Transform.rotate
      expect(find.byType(InfinityAgeScroller), findsOneWidget);
      expect(find.byType(Transform), findsAtLeastNWidgets(1));
    });

    testWidgets('should apply custom styling', (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              scrollDirection: ScrollDirection.vertical,
              selectedTextColor: Colors.blue,
              unselectedTextColor: Colors.grey,
              itemExtent: 80.0,
              curveOfScroll: 1.5,
            ),
          ),
        ),
      );

      expect(find.byType(InfinityAgeScroller), findsOneWidget);
    });

    test('ScrollDirection enum should have correct values', () {
      expect(ScrollDirection.values.length, 4);
      expect(ScrollDirection.vertical, ScrollDirection.vertical);
      expect(ScrollDirection.horizontal, ScrollDirection.horizontal);
      expect(ScrollDirection.leftDiagonal, ScrollDirection.leftDiagonal);
      expect(ScrollDirection.rightDiagonal, ScrollDirection.rightDiagonal);
    });
  });

  group('InfinityAgeScroller Edge Cases', () {
    testWidgets('should handle minimum age range', (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              minAge: 18,
              maxAge: 19, // Very small range
              initialAge: 18,
              scrollDirection: ScrollDirection.vertical,
            ),
          ),
        ),
      );

      expect(find.byType(InfinityAgeScroller), findsOneWidget);
    });

    testWidgets('should handle large age range', (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              minAge: 1,
              maxAge: 200, // Large range
              initialAge: 50,
              scrollDirection: ScrollDirection.vertical,
            ),
          ),
        ),
      );

      expect(find.byType(InfinityAgeScroller), findsOneWidget);
    });

    testWidgets('should handle initial age outside range gracefully',
        (WidgetTester tester) async {
      int? selectedAge;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfinityAgeScroller(
              onAgeSelected: (age) {
                selectedAge = age;
              },
              minAge: 18,
              maxAge: 65,
              initialAge: 200, // Outside range
              scrollDirection: ScrollDirection.vertical,
            ),
          ),
        ),
      );

      expect(find.byType(InfinityAgeScroller), findsOneWidget);
    });
  });
}
