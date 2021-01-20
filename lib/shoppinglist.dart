import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'listitem.dart';

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<ListItem> _itemList = [];
  TextEditingController inputController = new TextEditingController();
  double _fontSize = 22;

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

  void _completeAllItems() {
    setState(() {
      _itemList.map((item) => item.isChecked=!item.isChecked).toList();
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
            key: Key("font_size"),
            icon: Icon(Icons.format_size),
            onPressed: () => setState(() {
              _fontSize==22 ? _fontSize=18 : _fontSize=22;
            }),
          ),
          IconButton(
            key: Key("set_complete"),
            icon: Icon(Icons.check),
            onPressed: () => _completeAllItems(),
          ),
          IconButton(
              key: Key("delete_completed"),
              icon: Icon(Icons.remove_done),
              onPressed: () => _itemList.where((item) => item.isChecked).length > 0
                  ? _showDialogForDeletingCompletedItems(context)
                  : Fluttertoast.showToast(msg: "Keine erledigten Artikel vorhanden"),
          ),
          IconButton(
              key: Key("delete_all"),
              icon: Icon(Icons.delete_forever_outlined),
              onPressed: () => _itemList.length > 0
                  ? _showAlertDialogForDeletingAllItems(context)
                  : Fluttertoast.showToast(msg: "Keine Artikel vorhanden"),
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
        onPressed: () =>  showDialogForAddingItems(context),
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showDialogForAddingItems(BuildContext context) {
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
            actions: <Widget>[
              new FlatButton(
                  key: Key("close_dialog"),
                  child: new Text("Schließen"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              new FlatButton(
                key: Key("save_item"),
                child: new Text("Speichern"),
                onPressed: () {
                  _addItem();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _showDialogForDeletingCompletedItems(BuildContext context) {
     showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            key: Key("delete_completed_dialog"),
            title: new Text("Alle erledigten Artikel löschen?"),
            actions: <Widget>[
              new FlatButton(
                  key: Key("confirm"),
                  onPressed: () {
                    _clearCompletedItems();
                    Navigator.of(context).pop();
                  },
                  child: new Text('Ja')
              ),
              new FlatButton(
                  key: Key("deny"),
                  onPressed: Navigator.of(context).pop,
                  child: new Text('Nein')
              )
            ],
          );
        }
    );
  }

  void _showAlertDialogForDeletingAllItems(BuildContext context) {
     showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            key: Key("delete_all_dialog"),
            title: new Text("Liste leeren?"),
            actions: <Widget>[
              new FlatButton(
                  key: Key("confirm"),
                  onPressed: () {
                    _clearAllItems();
                    Navigator.of(context).pop();
                  },
                  child: new Text('Ja')
              ),
              new FlatButton(
                  key: Key("deny"),
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
                fontSize: _fontSize,
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
      // https://stackoverflow.com/questions/62194868/how-to-add-a-list-with-widgets-to-shared-preferences-in-flutter
      String storedItems = prefs.getString("itemList");
      if(storedItems?.isEmpty ?? true) return <ListItem>[];
      final items = json.decode(storedItems) as List;
      _itemList = List<ListItem>.from(items.map((x) => ListItem.fromJson(x)));
    });
  }
}