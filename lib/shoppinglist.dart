import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'listitem.dart';

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  static const double _SMALL_FONT_SIZE = 28;
  static const double _LARGE_FONT_SIZE = 40;
  static const double _SMALL_ITEM_EXTENT = 35;
  static const double _LARGE_ITEM_EXTENT = 50;
  List<ListItem> _itemList = [];
  TextEditingController inputController = new TextEditingController();
  double _fontSize = _LARGE_FONT_SIZE;
  double _itemExtent = _LARGE_ITEM_EXTENT;

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
      _itemList.map((item) => item.isChecked=true).toList();
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(image: DecorationImage(image: new AssetImage("images/ruled_paper.png"), fit: BoxFit.cover)),child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.title),
        // backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          IconButton(
            key: Key("font_size"),
            icon: Icon(Icons.format_size),
            onPressed: () => setState(() {
              _fontSize==_LARGE_FONT_SIZE ? _fontSize=_SMALL_FONT_SIZE : _fontSize=_LARGE_FONT_SIZE;
              _itemExtent==_LARGE_ITEM_EXTENT ? _itemExtent=_SMALL_ITEM_EXTENT : _itemExtent=_LARGE_ITEM_EXTENT;
            }),
          ),
          // IconButton(
          //   key: Key("set_complete"),
          //   icon: Icon(Icons.check),
          //   onPressed: () => _showDialogForCompletingAllItems(context),
          // ),
          IconButton(
              key: Key("delete_completed"),
              icon: Icon(Icons.remove_done),
              onPressed: () => _itemList.where((item) => item.isChecked).length > 0
                  ? _showDialogForDeletingCompletedItems(context)
                  : Fluttertoast.showToast(msg: "Keine erledigten Artikel vorhanden"),
          ),
          IconButton(
              key: Key("delete_all"),
              color: Colors.redAccent,
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>  showDialogForAddingItems(context),
        child: Icon(Icons.add, color: Colors.white),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
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
          return showAlertDialog(context, "Alle erledigten Artikel löschen?", _clearCompletedItems);
        }
    );
  }

  void _showAlertDialogForDeletingAllItems(BuildContext context) {
     showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return showAlertDialog(context, "Liste leeren?", _clearAllItems);
        }
    );
  }

  AlertDialog showAlertDialog(BuildContext context, String dialogTitle, Function() methodToCall) {
    return AlertDialog(
          key: Key("delete_all_dialog"),
      title: new Text(dialogTitle),
      actions: <Widget>[
        new FlatButton(
            key: Key("confirm"),
            onPressed: () {
              methodToCall();
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

  Widget buildList() {
    return new ListView.builder(
        itemCount: _itemList.length,
        itemExtent: _itemExtent,
        itemBuilder: (context, index) {
          return buildListItem(index, _itemList[index].text);
        });
  }

  Widget buildListItem(int itemIndex, String text) {
    return new ListTile(
        title: new Text(
            text,
            style: GoogleFonts.caveat(
                textStyle: TextStyle(
                color: _itemList[itemIndex].isChecked ? Colors.black26 : Colors.black,
                fontSize: _fontSize,
                decoration: _itemList[itemIndex].isChecked ? TextDecoration.lineThrough : TextDecoration.none))
            ),
        tileColor: Colors.transparent,
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