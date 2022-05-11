// To parse this JSON data, do
//
//     final itemTableModle = itemTableModleFromJson(jsonString);

import 'dart:convert';

ItemTableModel itemTableModelFromJson(String str) =>
    ItemTableModel.fromJson(json.decode(str));

String itemTableModelToJson(ItemTableModel data) => json.encode(data.toJson());

class ItemTableModel {
   int? pageNumber;
   int? pageRowsCount;
   int? lastPage;
   int? pagesCount;
   int? resultCount;
   List<DataItem>? data;



  ItemTableModel(
      { this.pageNumber,
      this.pageRowsCount,
      this.lastPage,
      this.pagesCount,
      this.resultCount,
      this.data});

  ItemTableModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['PageNumber'];
    pageRowsCount = json['PageRowsCount'];
    lastPage = json['LastPage'];
    pagesCount = json['PagesCount'];
    resultCount = json['ResultCount'];
    if (json['Data'] != null) {
      data = <DataItem>[];
      json['Data'].forEach((v) {
        data!.add( DataItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['PageNumber'] = pageNumber;
    data['PageRowsCount'] = pageRowsCount;
    data['LastPage'] = lastPage;
    data['PagesCount'] = pagesCount;
    data['ResultCount'] = resultCount;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataItem {
  String? id;
  int? no;
  String? barcode;
  String? categoryName;
  String? itemName;
  String? unitName;
  double? priceByPoint;
  double? priceByCurrency;
  double? purchasePrice;

  DataItem(
      {this.id,
      this.no,
      this.barcode,
      this.categoryName,
      this.itemName,
      this.unitName,
      this.priceByPoint,
      this.priceByCurrency,
      this.purchasePrice});

  DataItem.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    no = json['No'];
    barcode = json['Barcode'];
    categoryName = json['CategoryName'];
    itemName = json['ItemName'];
    unitName = json['UnitName'];
    priceByPoint = json['PriceByPoint'];
    priceByCurrency = json['PriceByCurrency'];
    purchasePrice = json['PurchasePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['No'] = no;
    data['Barcode'] = barcode;
    data['CategoryName'] = categoryName;
    data['ItemName'] = itemName;
    data['UnitName'] = unitName;
    data['PriceByPoint'] = priceByPoint;
    data['PriceByCurrency'] = priceByCurrency;
    data['PurchasePrice'] = purchasePrice;
    return data;
  }
}
