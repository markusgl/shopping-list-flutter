import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/shoppinglist.dart';

void main() {
  testWidgets('ShoppingListWidget has an title', (WidgetTester tester) async {
    await tester.pumpWidget(ShoppingList(title: "testliste"));
    await tester.tap(find.byType(FloatingActionButton));
    // await tester.pump();
    // await tester.tap(find.byType(AlertDialog));

    // expect(find.text('Artikel eingeben'), findsOneWidget);
  });
}
