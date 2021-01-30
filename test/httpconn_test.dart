import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';
import 'package:shopping_list/httpconn.dart';

/// Integration tests
void main() {
  test('http client sends a get request', () {
    final httpClient = IOClient();
    final client = HttpConn();
    expect(() => client.getList('601454bee471ee4fbc0ae1cd', httpClient), returnsNormally);
  });

  test('send a post request', () {
    final client = HttpConn();
    var result = client.createNewList("blub", ["Tomaten", "Gurke"]);
    print(result);
  });
}
