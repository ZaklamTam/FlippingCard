// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:e2/flippableCard.dart';
import 'package:e2/main.dart';

void main() {
  testWidgets('Renders a grid of cards', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(FlippableCard), findsWidgets);

    // GridView builds lazily; scroll to ensure the last card exists.
    expect(find.byKey(const ValueKey('card_0')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('card_5')),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.byKey(const ValueKey('card_5')), findsOneWidget);
  });
}
