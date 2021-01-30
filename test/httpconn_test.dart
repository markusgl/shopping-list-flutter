import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/httpconn.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/shoppinglist.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  // test('http client sends a get request', () {
  //   final client = MockClient();
  //   final docId = '6013f7dae6cc344cec2b4606';
  //
  //   when(client.get('http://localhost:3000/api/get-list/${docId}'))
  //       .thenAnswer((_) async => http.Response('', 200));
  //
  // });

  test('http client sends a get request', () {
    final client = HttpConn();
    expect(() => client.getList('601454bee471ee4fbc0ae1cd'), returnsNormally);
  });

  test('send a post request', () {
    final client = HttpConn();
    var result = client.createNewList("blub", ["Tomaten", "Gurke"]);
    print(result);
  });
}
