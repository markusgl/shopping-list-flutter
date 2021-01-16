import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController inputController = new TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _loadData();
  // }
  //
  // void _loadData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _items = prefs.getStringList("items") ?? [];
  //     _completedItems = prefs.getStringList("completedItems") ?? [];
  //   });
  // }

  void _addItem() {
    String item = inputController.text;
    // print("adding item " + item);
    setState(() {
      _items.add(item);
      inputController.text = "";
    });
    // _saveData();
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
                      ))
                    ],
                  ),
                  // content: Text(inputController.text),
                  actions: <Widget>[
                    new FlatButton(
                        child: new Text("Schließen"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    new FlatButton(
                      child: new Text("Speichern"),
                      onPressed: () {
                        _addItem();
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

  Widget buildList() {
    return new ListView.builder(
        itemCount: _items.length + _completedItems.length,
        itemBuilder: (context, index) {
          if (index < _items.length) {
            return buildListItem(index,_items[index]);
          } else {
            int completedIndex = index - _items.length;
            return _buildCompletedListItem(
                completedIndex, _completedItems[completedIndex]);
          }
        });
  }

  Widget buildListItem(int itemIndex, String text) {
    return new ListTile(
      title:
          new Text(text, style: TextStyle(color: Colors.black, fontSize: 22)),
      tileColor: Colors.black12,
      onTap: () => _completeItem(itemIndex)
    );
  }

  Widget _buildCompletedListItem(int itemIndex, String text) {
    return new ListTile(
      title: new Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              decoration: TextDecoration.lineThrough)),
      tileColor: Colors.black12,
      onTap: () => _uncompleteItem(itemIndex),
    );
  }

  void _completeItem(int index) {
    setState(() {
      _completedItems.insert(0, _items.removeAt(index));
    });
    // _saveData();
  }

  void _uncompleteItem(int index) {
    setState(() {
      _items.add(_completedItems.removeAt(index));
    });
    // _saveData();
  }

  // void _saveData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList("items", _items);
  //   prefs.setStringList("completedItems", _completedItems);
  // }
}
