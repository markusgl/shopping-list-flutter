import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';
import 'package:shopping_list/httpconn.dart';
import 'package:shopping_list/shoppinglist.dart';

/// Integration tests
void main() {
  test('http client sends a get request', () async {
    final httpClient = IOClient();
    final httpConn = HttpConn();

    expect(await httpConn.getList('601454bee471ee4fbc0ae1cd', httpClient), isA<ShoppingList>());
  });

  test('http client sends a post request', () async {
    final httpClient = IOClient();
    final httpConn = HttpConn();

    expect(await httpConn.createNewList('testlist', ["Tomaten", "Gurke"]), isA<ShoppingList>());
  });
}
