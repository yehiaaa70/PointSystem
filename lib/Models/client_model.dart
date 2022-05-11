// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
  ClientModel({
    this.id,
    this.no,
    this.name,
    this.barcode,
    this.personsCount,
    this.personQuantity,
    this.defaultBalance,
    this.pointFromLastMonth,
    this.pointsConsumedToNow,
    this.breadBalance,
    this.openedRest,
    this.breadPriceByPoint,
    this.precisePriceByPoint,
    this.pointByMoney,
  });

  String? id;
  int? no;
  String? name;
  String? barcode;
  int? personsCount;
  int? personQuantity;
  int? defaultBalance;
  int? pointFromLastMonth;
  int? pointsConsumedToNow;
  String? breadBalance;
  String? openedRest;
  double? breadPriceByPoint;
  double? precisePriceByPoint;
  double? pointByMoney;

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    id: json["Id"],
    no: json["No"],
    name: json["Name"],
    barcode: json["Barcode"],
    personsCount: json["PersonsCount"],
    personQuantity: json["PersonQuantity"],
    defaultBalance: json["DefaultBalance"],
    pointFromLastMonth: json["PointFromLastMonth"],
    pointsConsumedToNow: json["PointsConsumedToNow"],
    breadBalance: json["BreadBalance"],
    openedRest: json["OpenedRest"],
    breadPriceByPoint: json["BreadPriceByPoint"],
    precisePriceByPoint: json["PrecisePriceByPoint"],
    pointByMoney: json["PointByMoney"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "No": no,
    "Name": name,
    "Barcode": barcode,
    "PersonsCount": personsCount,
    "PersonQuantity": personQuantity,
    "DefaultBalance": defaultBalance,
    "PointFromLastMonth": pointFromLastMonth,
    "PointsConsumedToNow": pointsConsumedToNow,
    "BreadBalance": breadBalance,
    "OpenedRest": openedRest,
    "BreadPriceByPoint": breadPriceByPoint,
    "PrecisePriceByPoint": precisePriceByPoint,
    "PointByMoney": pointByMoney,
  };
}
