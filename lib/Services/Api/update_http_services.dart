import 'dart:convert';

import 'package:http/http.dart';
import 'package:test_project/Models/new_items.dart';

import '../../Models/new_client.dart';
import 'api_url.dart';

class UpdateHttpServices {

  static Future<String> updateClients(String id, NewClient newClient) async {
    String url = Urls.updateClientsApi;

    final response = await put(
      Uri.parse(url + "?Id=$id"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(newClient.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to Update Client.');
    }
  }

  static Future<String> updateItem(String id, NewItem newItem) async {
    String url = Urls.updateItemsApi;

    final response = await put(
      Uri.parse(url + "?Id=$id"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(newItem.toJson()),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to Update Item.');
    }
  }

}
