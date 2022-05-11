
import 'package:http/http.dart';

import 'api_url.dart';

class DeleteHttpServices {

  static Future<String> deleteClients(String id) async {
    String url = Urls.deleteClientsApi;

    final response = await delete(Uri.parse(url + "?Id=$id"),);

    if (response.statusCode == 200) {
      return  response.body;
    } else {
      throw Exception('Failed to Delete Client.');
    }
  }

  static Future<String> deleteItem(String id) async {
    String url = Urls.deleteItemApi;

    final response = await delete(Uri.parse(url + "?Id=$id"),);

    if (response.statusCode == 200) {
      return  response.body;
    } else {
      throw Exception('Failed to Delete Client.');
    }
  }

}
