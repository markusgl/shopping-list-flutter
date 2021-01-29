import 'dart:convert';
import 'dart:io';

class HttpConn {
  HttpClient client = new HttpClient();
  String baseUri = 'http://localhost:3000/api';

  void getList(docId) {
    print('sending request to ' + "http://localhost:3000/api/get-list/${docId}");
    client
        .getUrl(Uri.parse("$baseUri/get-list/$docId"))
        .then((HttpClientRequest request) {
          return request.close();
        })
        .then((HttpClientResponse response) {
          print(response);
          return response;
    });
  }

  Future<String> saveNewList(String title, List<String> items) async {
    Map<String, dynamic> jsonMap = {
      'name': title,
      'items': items
    };
    print(json.encode(jsonMap));
    HttpClientRequest request = await client.postUrl(Uri.parse("$baseUri/create-list"));
    // request.headers.set('content-type', 'application/json');
    // request.add(jsonMap); // TODO set body


    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    client.close();
    return reply;
  }

  void updateList(){

  }
}
