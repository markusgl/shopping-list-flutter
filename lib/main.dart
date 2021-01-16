import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      home: ShoppingList(title: 'Shopping List'),
    );
  }
}

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

enum MenuActions { ClearSuggestions }

class _ShoppingListState extends State<ShoppingList> {
  List<String> _items = [];
  List<String> _completedItems = [];
  TextEditingController inputController = TextEditingController();

  void _addItem() {
    String item = inputController.text;
    print("adding item " + item);
    setState(() {
      _items.add(item);
      inputController.text = "";

    });
    // buildList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            child: buildList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _addItem,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return AlertDialog(
                  // title: new Text("hello"),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new TextField(
                            controller: inputController,
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: "Artikel eingeben",
                                hintText: "z. B. Bananen"
                            ),
                          )
                      )
                    ],
                  ),
                  // content: Text(inputController.text)
                  actions: <Widget>[
                    new FlatButton(
                        child: new Text("Schließen"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    new FlatButton(
                      child: new Text("Speichern"),
                      onPressed: () {
                        buildList();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListView buildList() {
    print("building list with item " + inputController.text);
    return new ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return buildListItem(inputController.text);
              });
  }

  Widget buildListItem(String text) {
    return new ListTile(
      // title: new Text(text, style: TextStyle(color: Colors.green, fontSize: 22)),
      title: Text(text),
      tileColor: Colors.green,
      onTap: () => TextDecoration.lineThrough,
    );
  }
}
