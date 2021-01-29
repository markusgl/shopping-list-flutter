import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list/shoppinglist.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoppey',
      theme: ThemeData(
        // primarySwatch: Colors.teal,  // Material color
        primaryColor: Color.fromARGB(255, 85, 196, 180),
        primaryIconTheme: IconThemeData(
          color: Colors.white // Icons in heading color
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: GoogleFonts.caveat().fontFamily,
            fontSize: 36,
            // fontWeight: FontWeight.bold,
            color: Colors.white  // Heading color
          )
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShoppingList(
          title: 'Shoppey'
      ),
    );
  }
}
