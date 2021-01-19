import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_list/main.dart';

void main() {
  testWidgets('Add Item Button opens dialog', (WidgetTester tester) async {
    await tester.pumpWidget(Home());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.tap(find.byType(AlertDialog));

    expect(find.text('Artikel eingeben'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FlatButton), findsWidgets);
    expect(find.text('Speichern'), findsOneWidget);
    expect(find.text('Schließen'), findsOneWidget);
  });

  testWidgets('Adds a new Item to the list', (WidgetTester tester) async {
    await tester.pumpWidget(Home());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    await tester.tap(find.byType(AlertDialog));
    await tester.enterText(find.byType(TextField), "Bananen");
    await tester.tap(find.byKey(Key("save_item")));
    await tester.pump();
    expect(find.text('Bananen'), findsOneWidget);
  });

  testWidgets('Deletes all items', (WidgetTester tester) async {
    await tester.pumpWidget(Home());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    await tester.tap(find.byType(AlertDialog));
    await tester.enterText(find.byType(TextField), "Bananen");
    await tester.tap(find.byKey(Key("save_item")));
    await tester.pump();
    expect(find.text('Bananen'), findsOneWidget);

    await tester.tap(find.byKey(Key("delete_all")));
    await tester.pump();
    await tester.tap(find.byKey(Key("confirm")));
    await tester.pump();
    expect(find.text('Bananen'), findsNothing);
  });

  testWidgets('Deletes all completed items', (WidgetTester tester) async {
    await tester.pumpWidget(Home());

    // Add item 'Bananen'
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextField), "Bananen");
    await tester.tap(find.byKey(Key("save_item")));
    await tester.pump();
    expect(find.text('Bananen'), findsOneWidget);

    // Add item 'Äpfel'
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextField), "Äpfel");
    await tester.tap(find.byKey(Key("save_item")));
    await tester.pump();
    expect(find.text('Äpfel'), findsOneWidget);

    // Check item 'Bananen'
    await tester.tap(find.text('Bananen'));

    // Only item 'Bananen' should have been removed
    await tester.tap(find.byKey(Key("delete_completed")));
    await tester.pump();
    await tester.tap(find.byKey(Key("confirm")));
    await tester.pump();
    expect(find.text('Bananen'), findsNothing);
    expect(find.text('Äpfel'), findsOneWidget);
  });


  testWidgets('Remove Completed Items does not show dialog if no completed items are present', (WidgetTester tester) async {
    await tester.pumpWidget(Home());
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Remove All Items button does not show dialog if no completed items are present', (WidgetTester tester) async {
    await tester.pumpWidget(Home());
    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
  });

}
