import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shopping_list/httpconn.dart';
import 'package:shopping_list/shoppinglist.dart';

class MockClient extends Mock implements http.Client {}

main() {
  group('getList', () {
    test('http client sends a get request', () async {
      final httpConn = HttpConn();
      final mockClient = MockClient();
      final docId = '6013f7dae6cc344cec2b4606';
      final expectedResult = jsonEncode({
        "id": "601454bee471ee4fbc0ae1cd",
        "name": "testliste",
        "items": [
          "Bananen",
          "Äpfel",
          "Müsli"
        ]
      });

      when(mockClient.get('http://localhost:3000/api/get-list/$docId'))
          .thenAnswer((_) async => http.Response(expectedResult.toString(), 200));

      expect(await httpConn.getList(docId, mockClient), isA<ShoppingList>());
    });
  });
}
