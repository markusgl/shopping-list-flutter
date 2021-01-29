import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shopping_list/shoppinglist.dart';

class HttpConn {
  HttpClient client = new HttpClient();
  String baseUri = 'http://localhost:3000/api';

  Future<ShoppingList> getList(docId) async {
    final response = await http.get("$baseUri/get-list/$docId");
    if (response.statusCode == 200) {
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
