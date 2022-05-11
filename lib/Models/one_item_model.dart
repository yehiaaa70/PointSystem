// To parse this JSON data, do
//
//     final oneItem = oneItemFromJson(jsonString);

import 'dart:convert';

OneItem oneItemFromJson(String str) => OneItem.fromJson(json.decode(str));

String oneItemToJson(OneItem data) => json.encode(data.toJson());

class OneItem {
  OneItem({
    this.id,
    this.no,
    this.quantity,
    this.total,
    this.barcode,
    this.name,
    this.categoryId,
    this.categoryName,
    this.insertedDate,
    this.lastModifiedDate,
    this.openBalance,
    this.priceByCurrency,
    this.priceByPoint,
    this.purchasePrice,
    this.unitId,
    this.unitName,
  });

  String? id;
  int? no;
  int? quantity;
  double? total;
  String? barcode;
  String? name;
  String? categoryId;
  String? categoryName;
  DateTime? insertedDate;
  dynamic lastModifiedDate;
  double? openBalance;
  double? priceByCurrency;
  double? priceByPoint;
  double? purchasePrice;
  String? unitId;
  String? unitName;

  factory OneItem.fromJson(Map<String, dynamic> json) => OneItem(
    id: json["Id"],
    no: json["No"],
    quantity: json["Quantity"],
    total: json["Total"],
    barcode: json["Barcode"],
    name: json["Name"],
    categoryId: json["CategoryId"],
    categoryName: json["CategoryName"],
    insertedDate: DateTime.parse(json["InsertedDate"]),
    lastModifiedDate: json["LastModifiedDate"],
    openBalance: json["OpenBalance"],
    priceByCurrency: json["PriceByCurrency"],
    priceByPoint: json["PriceByPoint"],
    purchasePrice: json["PurchasePrice"],
    unitId: json["UnitId"],
    unitName: json["UnitName"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "No": no,
    "Quantity": quantity,
    "Total": total,
    "Barcode": barcode,
    "Name": name,
    "CategoryId": categoryId,
    "CategoryName": categoryName,
    "InsertedDate": insertedDate!.toIso8601String(),
    "LastModifiedDate": lastModifiedDate,
    "OpenBalance": openBalance,
    "PriceByCurrency": priceByCurrency,
    "PriceByPoint": priceByPoint,
    "PurchasePrice": purchasePrice,
    "UnitId": unitId,
    "UnitName": unitName,
  };
}
