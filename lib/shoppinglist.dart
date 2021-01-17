import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<String> _items = [];
  List<String> _completedItems = [];
  TextEditingController inputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _items = prefs.getStringList("items") ?? [];
      _completedItems = prefs.getStringList("completedItems") ?? [];
    });
  }

  void _addItem() {
    String item = inputController.text;
    if (item.length > 0) {
      setState(() {
        _items.add(item);
        inputController.text = "";
      });
      _saveData();
    } else {
      Fluttertoast.showToast(msg: "Keinen Artikel angegeben");
    }
  }

  void _clearCompletedItems() {
    if (_completedItems.length > 0) {
      setState(() {
        _completedItems.clear();
      });
      _saveData();
    } else {
      Fluttertoast.showToast(msg: "Keine erledigten Artikel vorhanden");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return AlertDialog(
                        title: new Text("Alle erledigten Artikel löschen?"),
                        actions: <Widget>[
                          new FlatButton(
                              onPressed: () {
                                _clearCompletedItems();
                                Navigator.of(context).pop();
                              },
                              child: new Text('Ja')
                          ),
                          new FlatButton(
                              onPressed: Navigator.of(context).pop,
                              child: new Text('Nein')
                          )
                        ],
                      );
                    }
                );
              }
          )
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            child: buildList(),
          ),
          Positioned(
              bottom: 0.0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
              )
          )
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
                            onSubmitted: (dynamic x) => {_addItem(), Navigator.of(context).pop()},
                            decoration: InputDecoration(
                                labelText: "Artikel eingeben",
                                hintText: "z. B. Bananen"),
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
            return buildListItem(index, _items[index]);
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
        onTap: () => _completeItem(itemIndex));
  }

  Widget _buildCompletedListItem(int itemIndex, String text) {
    return new ListTile(
      title: new Text(text,
          style: TextStyle(
              color: Colors.grey,
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
    _saveData();
  }

  void _uncompleteItem(int index) {
    setState(() {
      _items.add(_completedItems.removeAt(index));
    });
    _saveData();
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("items", _items);
    prefs.setStringList("completedItems", _completedItems);
  }
}