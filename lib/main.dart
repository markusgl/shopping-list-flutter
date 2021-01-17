import 'package:flutter/material.dart';
import 'package:shopping_list/shoppinglist.dart';

void main() {
  runApp(MyApp());
  // runApp(ShoppingList(title: 'Simple Checklist'));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShoppingList(title: 'Simple Checklist'),
    );
  }
}
