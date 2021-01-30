import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_list/shoppinglist.dart';

class HttpConn {
  String baseUri = 'http://localhost:3000/api';

  Future<ShoppingList> getList(docId, http.Client client) async {
    final response = await client.get("$baseUri/get-list/$docId");

    if (response.statusCode == 200) {
      print(response.body);
      return ShoppingList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<ShoppingList> createNewList(String title, List<String> items) async {
    final http.Response response = await http.post(
      this.baseUri+'/create-list',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(<String, dynamic> {
        'name': title,
        'items': items,
      }),
    );
    if (response.statusCode == 201) {
      return ShoppingList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Saving list failed');
    }
  }

  void updateList(){

  }
}
