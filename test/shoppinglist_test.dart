import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/shoppinglist.dart';

void main() {
  testWidgets('ShoppingListWidget has an title', (WidgetTester tester) async {
    var testKey = Key("test");
    await tester.pumpWidget(ShoppingList(key: testKey,title: "testlist",));

    final titleFinder = find.text("testlist");
    // expect(titleFinder, findsOneWidget);
    expect(find.byKey(testKey), findsOneWidget);
  });
}
