import 'package:flutter/material.dart';
import 'package:shopping_list/shoppinglist.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        primaryIconTheme: IconThemeData(
          color: Colors.white
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white
          )
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShoppingList(title: 'Easy Shoppinglist'),
    );
  }
}
