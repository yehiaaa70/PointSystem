// To parse this JSON data, do
//
//     final monthBalance = monthBalanceFromJson(jsonString);

import 'dart:convert';

MonthBalance monthBalanceFromJson(String str) => MonthBalance.fromJson(json.decode(str));

String monthBalanceToJson(MonthBalance data) => json.encode(data.toJson());

class MonthBalance {
  MonthBalance({
    this.pageNumber,
    this.pageRowsCount,
    this.lastPage,
    this.pagesCount,
    this.resultCount,
    this.totalPersonsCount,
    this.data,
  });

  int? pageNumber;
  int? pageRowsCount;
  int? lastPage;
  int? pagesCount;
  int? resultCount;
  int? totalPersonsCount;
  List<MonthDatum>? data;

  factory MonthBalance.fromJson(Map<String, dynamic> json) => MonthBalance(
    pageNumber: json["PageNumber"],
    pageRowsCount: json["PageRowsCount"],
    lastPage: json["LastPage"],
    pagesCount: json["PagesCount"],
    resultCount: json["ResultCount"],
    totalPersonsCount: json["TotalPersonsCount"],
    data: List<MonthDatum>.from(json["Data"].map((x) => MonthDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "PageNumber": pageNumber,
    "PageRowsCount": pageRowsCount,
    "LastPage": lastPage,
    "PagesCount": pagesCount,
    "ResultCount": resultCount,
    "TotalPersonsCount": totalPersonsCount,
    "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MonthDatum {
  MonthDatum({
    this.id,
    this.no,
    this.clientName,
    this.month,
    this.year,
    this.openedBalance,
    this.defaultBalance,
  });

  String? id;
  int? no;
  String? clientName;
  int? month;
  int? year;
  double? openedBalance;
  double? defaultBalance;

  factory MonthDatum.fromJson(Map<String, dynamic> json) => MonthDatum(
    id: json["Id"],
    no: json["No"],
    clientName: json["ClientName"],
    month: json["Month"],
    year: json["Year"],
    openedBalance: json["OpenedBalance"],
    defaultBalance: json["DefaultBalance"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "No": no,
    "ClientName": clientName,
    "Month": month,
    "Year": year,
    "OpenedBalance": openedBalance,
    "DefaultBalance": defaultBalance,
  };
}
