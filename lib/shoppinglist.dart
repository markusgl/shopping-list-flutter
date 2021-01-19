import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class ListItem {
  String text;
  bool isChecked;
  ListItem(this.text, this.isChecked);

  @override
  toString() {
    return 'text: $text, isChecked: $isChecked';
  }

  Map<String, dynamic> toJson() => {
    'text': this.text, 'isChecked': this.isChecked
  };
  factory ListItem.fromJson(Map<String, dynamic> listItem) =>
      ListItem(listItem['text'], listItem['isChecked']);
}

class _ShoppingListState extends State<ShoppingList> {
  List<ListItem> _itemList = [];
  TextEditingController inputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _addItem() {
    String userInput = inputController.text;
    ListItem listItem = new ListItem(inputController.text, false);

    if (userInput.length > 0) {
      setState(() {
        _itemList.add(listItem);
        inputController.text = "";
      });
      _saveData();
    } else {
      Fluttertoast.showToast(msg: "Keinen Artikel angegeben");
    }
  }

  void _clearCompletedItems() {
    if (_itemList.where((item) => item.isChecked).length > 0){
      setState(() {
        _itemList.removeWhere((item) => item.isChecked);
      });
      _saveData();
    } else {
      Fluttertoast.showToast(msg: "Keine erledigten Artikel vorhanden");
    }
  }

  void _clearAllItems() {
    setState(() {
      _itemList.clear();
    });
    _saveData();
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
              onPressed: () => _itemList.where((item) => item.isChecked).length > 0 ? _showAlertDialogForCompletedItems(context) : Fluttertoast.showToast(msg: "Keine erledigten Artikel vorhanden"),
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _itemList.length > 0 ? _showAlertDialogForAllItems(context) : Fluttertoast.showToast(msg: "Keine Artikel vorhanden"),
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

  void _showAlertDialogForCompletedItems(BuildContext context) {
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

  void _showAlertDialogForAllItems(BuildContext context) {
     showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: new Text("Alle Artikel löschen?"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    _clearAllItems();
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

  Widget buildList() {
    return new ListView.builder(
        itemCount: _itemList.length,
        itemBuilder: (context, index) {
          return buildListItem(index, _itemList[index].text);
        });
  }

  Widget buildListItem(int itemIndex, String text) {
    return new ListTile(
        title: new Text(
            text,
            style: TextStyle(
                color: _itemList[itemIndex].isChecked ? Colors.black12 : Colors.black,
                fontSize: 22,
                decoration: _itemList[itemIndex].isChecked ? TextDecoration.lineThrough : TextDecoration.none)),
        tileColor: Colors.black12,
        onTap: () => setState(() {
          _itemList[itemIndex].isChecked = !_itemList[itemIndex].isChecked;
          _saveData();
        })
    );
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('itemList', json.encode(_itemList));
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // workaround because SharedPreferences can only store Lists of type String
      String storedItems = prefs.getString("itemList");
      if(storedItems?.isEmpty ?? true) return <ListItem>[];
      final items = json.decode(storedItems) as List;
      _itemList = List<ListItem>.from(items.map((x) => ListItem.fromJson(x)));
    });
  }
}