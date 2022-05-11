// To parse this JSON data, do
//
//     final pdfMoneyModel = pdfMoneyModelFromJson(jsonString);

import 'dart:convert';

PdfMoneyModel pdfMoneyModelFromJson(String str) => PdfMoneyModel.fromJson(json.decode(str));

String pdfMoneyModelToJson(PdfMoneyModel data) => json.encode(data.toJson());

class PdfMoneyModel {
  PdfMoneyModel({
    this.date,
    this.time,
    this.clientName,
    this.idNumber,
    this.personsCount,
    this.defaultBalance,
    this.oldBalance,
    this.totalBalance,
    this.pointExchanged,
    this.money,
    this.oldRest,
    this.newRest,
  });

  DateTime? date;
  String? time;
  String? clientName;
  String? idNumber;
  int? personsCount;
  int? defaultBalance;
  int? oldBalance;
  int? totalBalance;
  int? pointExchanged;
  double? money;
  int? oldRest;
  int? newRest;

  factory PdfMoneyModel.fromJson(Map<String, dynamic> json) => PdfMoneyModel(
    date: DateTime.parse(json["Date"]),
    time: json["Time"],
    clientName: json["ClientName"],
    idNumber: json["IdNumber"],
    personsCount: json["PersonsCount"],
    defaultBalance: json["DefaultBalance"],
    oldBalance: json["OldBalance"],
    totalBalance: json["TotalBalance"],
    pointExchanged: json["PointExchanged"],
    money: json["Money"],
    oldRest: json["OldRest"],
    newRest: json["NewRest"],
  );

  Map<String, dynamic> toJson() => {
    "Date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "Time": time,
    "ClientName": clientName,
    "IdNumber": idNumber,
    "PersonsCount": personsCount,
    "DefaultBalance": defaultBalance,
    "OldBalance": oldBalance,
    "TotalBalance": totalBalance,
    "PointExchanged": pointExchanged,
    "Money": money,
    "OldRest": oldRest,
    "NewRest": newRest,
  };
}
