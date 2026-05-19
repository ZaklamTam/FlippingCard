import 'package:e2/flippableCard.dart';
import 'package:e2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renders memory card grid', (WidgetTester tester) async {
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
