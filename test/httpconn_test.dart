import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/httpconn.dart';
import 'package:http/http.dart' as http;

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
    var expectedResult = json.encode({
      "name": "testliste",
      "items": [
        "Bananen",
        "Äpfel",
        "Müsli",
        "Joghurt"
      ]
    });
    var result = client.getList('6013f7dae6cc344cec2b4606');
    // expect(result, expectedResult);
  });

  test('send a post request', () {
    final client = HttpConn();
    client.saveNewList("blub", ["Tomaten", "Gurke"]);
  });
}
