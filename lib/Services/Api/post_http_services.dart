import 'dart:convert';

import 'package:http/http.dart';
import 'package:test_project/Models/message_error.dart';
import 'package:test_project/Models/new_client.dart';
import 'package:test_project/Models/pdfItems.dart';
import 'package:test_project/Models/pdf_money_bills.dart';
import 'package:test_project/Models/pdf_month_balance_model.dart';
import 'package:test_project/Models/post_money_model.dart';

import '../../Models/new_items.dart';
import '../../Models/post_bread.dart';
import '../../Models/post_flowers_model.dart';
import '../../Models/post_items_model.dart';
import 'api_url.dart';

class PostHttpServices {

  static Future<String> postClients(NewClient newClient) async {
    String url = Urls.postClientsApi;
    Message message;
    final response = await post(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(newClient.toJson()),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 400) {
        message = messageFromJson(response.body);
        return message.message;
    }else{
      throw Exception('Failed to create Client.');

    }
  }

  static Future<String> postItems(NewItem newItem) async {
    String url = Urls.postItemsApi;
    Message message;
    final response = await post(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(newItem.toJson()),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 400) {
        message = messageFromJson(response.body);
        return message.message;
    }else{
      throw Exception('Failed to create Client.');

    }
  }

  static Future<String> postMonthBalance() async {
    String url = Urls.postMonthBalanceApi;
    final response = await post(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      return "Done";
    } else{
      throw Exception('Failed to create Month Balance .');

    }
  }

  static Future<PdfItemsModel> postBreadBill(PostBread postBread) async {
    String url = Urls.postBreadBillApi;
    final response = await post(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(postBread.toJson())
    );
    if (response.statusCode == 200) {
      PdfItemsModel body = pdfItemsModelFromJson(response.body);
      return body;
    }else if(response.statusCode==400){
      throw Exception('برجاء الانتظار دقيقتين لعمل عمله اخرى لهذا العميل');
    } else{
      throw Exception('Failed to create Bread Bill .');

    }
  }

  static Future<PdfItemsModel> postPreciseBill(PostPreciseModel preciseModel) async {
    String url = Urls.postPreciseBillApi;
    final response = await post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(preciseModel.toJson())
    );
    if (response.statusCode == 200) {
      PdfItemsModel body = pdfItemsModelFromJson(response.body);
      return body;
    } else{
      throw Exception('Failed to create Precise Bill .');

    }
  }

  static Future<PdfMoneyModel> postMoneyBill(PostMoneyModel moneyModel) async {
    String url = Urls.postMoneyBillApi;
    final response = await post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(moneyModel.toJson())
    );
    if (response.statusCode == 200) {
      PdfMoneyModel body = pdfMoneyModelFromJson(response.body);
      return body;
    } else{
      throw Exception('Failed to create Money Bill .');

    }
  }

  static Future<PdfItemsModel> postItemBill(PostItemsBillsModel itemsBillsModel) async {
    String url = Urls.postItemBillApi;
    Response response = await post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(itemsBillsModel.toJson())
    );
    if (response.statusCode == 200) {
      PdfItemsModel body = pdfItemsModelFromJson(response.body);
      return body;
    } else{
      throw Exception(response.body);

    }
  }


  static Future<PdfMonthBalanceModel> postMonthBalancePrint(String id) async {
    String url = Urls.postMonthBalancePrintApi;
    Response response = await post(
        Uri.parse(url+id),
    );
    if (response.statusCode == 200) {
      PdfMonthBalanceModel body = pdfMonthBalanceModelFromJson(response.body);
      return body;
    } else{
      throw Exception(response.body);

    }
  }
}
