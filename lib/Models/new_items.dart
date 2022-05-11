// To parse this JSON data, do
//
//     final newItem = newItemFromJson(jsonString);

import 'dart:convert';

NewItem newItemFromJson(String str) => NewItem.fromJson(json.decode(str));

String newItemToJson(NewItem data) => json.encode(data.toJson());

class NewItem {
  NewItem({
    this.unitId,
    this.categoryId,
    this.barcode,
    this.name,
    this.priceByPoint,
    this.priceByCurrency,
    this.purchasePrice,
    this.openBalance,
  });

  String? unitId;
  String? categoryId;
  String? barcode;
  String? name;
  double? priceByPoint;
  double? priceByCurrency;
  double? purchasePrice;
  double? openBalance;

  factory NewItem.fromJson(Map<String, dynamic> json) => NewItem(
    unitId: json["UnitId"],
    categoryId: json["CategoryId"],
    barcode: json["Barcode"],
    name: json["Name"],
    priceByPoint: json["PriceByPoint"],
    priceByCurrency: json["PriceByCurrency"],
    purchasePrice: json["PurchasePrice"],
    openBalance: json["OpenBalance"],
  );

  Map<String, dynamic> toJson() => {
    "UnitId": unitId,
    "CategoryId": categoryId,
    "Barcode": barcode,
    "Name": name,
    "PriceByPoint": priceByPoint,
    "PriceByCurrency": priceByCurrency,
    "PurchasePrice": purchasePrice,
    "OpenBalance": openBalance,
  };
}
