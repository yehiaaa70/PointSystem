import 'package:http/http.dart';
import 'package:test_project/Models/MachineModel.dart';
import 'package:test_project/Models/all_client_model.dart';
import 'package:test_project/Models/client_model.dart';
import 'package:test_project/Models/item_table_model.dart';
import 'package:test_project/Models/item_units.dart';
import 'package:test_project/Models/month_balance.dart';
import 'package:test_project/Models/one_item_model.dart';
import '../../Models/category_model.dart';
import '../../Models/items_categories.dart';
import '../../Models/points_bills_model.dart';
import '../../Models/statistical_model.dart';
import 'api_url.dart';
import 'dart:convert' as cnv;

class GetHttpServices {
  // Bills
  static Future<ClientModel> getClientByBarcode(String i) async {
    String url = Urls.getClientByBarcodeApi;

    Response res = await get(Uri.parse(url + "/$i"));

    if (res.statusCode == 200) {
      ClientModel body = clientModelFromJson(res.body);
      return body;
    } else {
      throw Exception('Failed to Get Client Barcode .');
    }
  }

  //Clients
  static Future<AllClientModel> getAllClient(String i) async {
    String url = Urls.getAllClientApi;
    Response res = await get(Uri.parse(url + "/$i"));
    if (res.statusCode == 200) {
      AllClientModel body = allClientModelFromJson(res.body);
      return body;
    } else {
      return AllClientModel();
    }
  }

  static Future<AllClientModel> getAllClientSearch(String i,String searchText) async {
    String url = Urls.getAllClientApi;
    Response res = await get(Uri.parse(url + "/$i"+"?SearchText="+searchText));
    if (res.statusCode == 200) {
      AllClientModel body = allClientModelFromJson(res.body);
      return body;
    } else {
      return AllClientModel();
    }
  }

  //Month Balance
  static Future<MonthBalance> getMonthBalance(String i) async {
    String url = Urls.getMonthBalanceApi;
    Response res = await get(Uri.parse(url + "/$i"));
    if (res.statusCode == 200) {
      MonthBalance body = monthBalanceFromJson(res.body);
      return body;
    } else {
      return MonthBalance();
    }
  }

  //Home
  static Future<StatisticalModel> getStatistical() async {
    String url = Urls.getStatisticalApi;
    Response res = await get(Uri.parse(url));
    StatisticalModel myStatisticalData = statisticalModelFromJson(res.body);
    return myStatisticalData;
  }

  //Points Bills
  static Future<PointsBillsModel> getPointsBills(String page) async {
    String url = Urls.getPointsBillsApi;
    Response res = await get(Uri.parse(url + page));
    if (res.statusCode == 200) {
      PointsBillsModel body = pointsBillsModelFromJson(res.body);
      return body;
    } else {
      return PointsBillsModel();
    }
  }

  static Future<MachineModel> getMachineId(String id, String machineId) async {
    String url = Urls.getMachineIdApi;
    Response res = await get(Uri.parse(url + id + "/$machineId"));
    if (res.statusCode == 200) {
      MachineModel body = machineModelFromJson(res.body);
      return body;
    } else {
      return MachineModel();
    }
  }

  // Items
  static Future<dynamic> getItems() async {
    String url = Urls.getItemsForSalesApi;
    Response res = await get(Uri.parse(url));
    List<dynamic> body = cnv.jsonDecode(res.body);
    List<CategoryModel> myDataModel =
        body.map((dynamic item) => CategoryModel.fromJson(item)).toList();
    return myDataModel;
  }

  static Future<ItemTableModel> getAllItems(String i) async {
    String url = Urls.getItemsTableApi;
    Response res = await get(Uri.parse(url + "/$i"));
    if (res.statusCode == 200) {
      ItemTableModel body = itemTableModelFromJson(res.body);
      return body;
    } else {
      return ItemTableModel();
    }
  }

  static Future<ItemTableModel> getAllItemsSearch(String i,String searchText) async {
    String url = Urls.getItemsTableApi;
    Response res = await get(Uri.parse(url + "/$i?SearchText=$searchText"));
    if (res.statusCode == 200) {
      ItemTableModel body = itemTableModelFromJson(res.body);
      return body;
    } else {
      return ItemTableModel();
    }
  }

  static Future<OneItem> getOneItems(String i) async {
    String url = Urls.getOneItemsApi;
    Response res = await get(Uri.parse(url + "/$i"));
    if (res.statusCode == 200) {
      OneItem body = oneItemFromJson(res.body);
      return body;
    } else {
      return OneItem();
    }
  }

  static Future<List<ItemsUnits>> getItemsUnits() async {
    String url = Urls.getItemsUnitsApi;
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      List<ItemsUnits> body = itemsUnitsFromJson(res.body);
      return body;
    } else {
      return [];
    }
  }

  static Future<List<ItemsCategories>> getItemsCategories() async {
    String url = Urls.getItemsCategoriesApi;
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      List<ItemsCategories> body = itemsCategoriesFromJson(res.body);
      return body;
    } else {
      return [];
    }
  }


}
