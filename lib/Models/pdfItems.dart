// To parse this JSON data, do
//
//     final pdfItemsModel = pdfItemsModelFromJson(jsonString);

import 'dart:convert';

PdfItemsModel pdfItemsModelFromJson(String str) => PdfItemsModel.fromJson(json.decode(str));

String pdfItemsModelToJson(PdfItemsModel data) => json.encode(data.toJson());

class PdfItemsModel {
  PdfItemsModel({
    this.no,
    this.date,
    this.time,
    this.machineName,
    this.clientName,
    this.personsCount,
    this.defaultBalance,
    this.oldBalance,
    this.totalBalance,
    this.usedBefore,
    this.details,
    this.currentUse,
    this.usedAfter,
    this.restOld,
    this.rest,
    this.money,
  });

  int? no;
  DateTime? date;
  String? time;
  String? machineName;
  String? clientName;
  int? personsCount;
  int? defaultBalance;
  int? oldBalance;
  int? totalBalance;
  int? usedBefore;
  List<PdfDetailItems>? details;
  int? currentUse;
  int? usedAfter;
  int? restOld;
  int? rest;
  double? money;

  factory PdfItemsModel.fromJson(Map<String, dynamic> json) => PdfItemsModel(
    no: json["No"],
    date: DateTime.parse(json["Date"]),
    time: json["Time"],
    machineName: json["MachineName"],
    clientName: json["ClientName"],
    personsCount: json["PersonsCount"],
    defaultBalance: json["DefaultBalance"],
    oldBalance: json["OldBalance"],
    totalBalance: json["TotalBalance"],
    usedBefore: json["UsedBefore"],
    details: List<PdfDetailItems>.from(json["Details"].map((x) => PdfDetailItems.fromJson(x))),
    currentUse: json["CurrentUse"],
    usedAfter: json["UsedAfter"],
    restOld: json["RestOld"],
    rest: json["Rest"],
    money: json["Money"],
  );

  Map<String, dynamic> toJson() => {
    "No": no,
    "Date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "Time": time,
    "MachineName": machineName,
    "ClientName": clientName,
    "PersonsCount": personsCount,
    "DefaultBalance": defaultBalance,
    "OldBalance": oldBalance,
    "TotalBalance": totalBalance,
    "UsedBefore": usedBefore,
    "Details": List<dynamic>.from(details!.map((x) => x.toJson())),
    "CurrentUse": currentUse,
    "UsedAfter": usedAfter,
    "RestOld": restOld,
    "Rest": rest,
    "Money": money,
  };
  @override
  String toString() {
    return super.toString();
  }
}

class PdfDetailItems {
  PdfDetailItems({
    this.name,
    this.quantity,
    this.pricePerPoint,
    this.totalPoints,
  });

  String? name;
  double? quantity;
  int? pricePerPoint;
  int? totalPoints;

  factory PdfDetailItems.fromJson(Map<String, dynamic> json) => PdfDetailItems(
    name: json["Name"],
    quantity: json["Quantity"],
    pricePerPoint: json["PricePerPoint"],
    totalPoints: json["TotalPoints"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Quantity": quantity,
    "PricePerPoint": pricePerPoint,
    "TotalPoints": totalPoints,
  };
}
