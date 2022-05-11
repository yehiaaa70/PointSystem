// To parse this JSON data, do
//
//     final pdfMonthBalanceModel = pdfMonthBalanceModelFromJson(jsonString);

import 'dart:convert';

PdfMonthBalanceModel pdfMonthBalanceModelFromJson(String str) => PdfMonthBalanceModel.fromJson(json.decode(str));

String pdfMonthBalanceModelToJson(PdfMonthBalanceModel data) => json.encode(data.toJson());

class PdfMonthBalanceModel {
  PdfMonthBalanceModel({
    this.month,
    this.year,
    this.clientName,
    this.idNumber,
    this.personsCount,
    this.defaultBalance,
    this.oldBalance,
    this.totalBalance,
    this.details,
    this.totalUse,
    this.rest,
  });

  String? month;
  int? year;
  String? clientName;
  String? idNumber;
  int? personsCount;
  int? defaultBalance;
  int? oldBalance;
  int? totalBalance;
  List<Detail>? details;
  int? totalUse;
  int? rest;

  factory PdfMonthBalanceModel.fromJson(Map<String, dynamic> json) => PdfMonthBalanceModel(
    month: json["Month"],
    year: json["Year"],
    clientName: json["ClientName"],
    idNumber: json["IdNumber"],
    personsCount: json["PersonsCount"],
    defaultBalance: json["DefaultBalance"],
    oldBalance: json["OldBalance"],
    totalBalance: json["TotalBalance"],
    details: List<Detail>.from(json["Details"].map((x) => Detail.fromJson(x))),
    totalUse: json["TotalUse"],
    rest: json["Rest"],
  );

  Map<String, dynamic> toJson() => {
    "Month": month,
    "Year": year,
    "ClientName": clientName,
    "IdNumber": idNumber,
    "PersonsCount": personsCount,
    "DefaultBalance": defaultBalance,
    "OldBalance": oldBalance,
    "TotalBalance": totalBalance,
    "Details": List<dynamic>.from(details!.map((x) => x.toJson())),
    "TotalUse": totalUse,
    "Rest": rest,
  };
}

class Detail {
  Detail({
    this.name,
    this.quantity,
    this.pricePerPoint,
    this.totalPoints,
    this.insertedDate,
  });

  String? name;
  double? quantity;
  int? pricePerPoint;
  int? totalPoints;
  DateTime? insertedDate;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    name: json["Name"],
    quantity: json["Quantity"],
    pricePerPoint: json["PricePerPoint"],
    totalPoints: json["TotalPoints"],
    insertedDate: DateTime.parse(json["InsertedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Quantity": quantity,
    "PricePerPoint": pricePerPoint,
    "TotalPoints": totalPoints,
    "InsertedDate": insertedDate!.toIso8601String(),
  };
}
