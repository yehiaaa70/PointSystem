// To parse this JSON data, do
//
//     final allClientModel = allClientModelFromJson(jsonString);

import 'dart:convert';

AllClientModel allClientModelFromJson(String str) =>
    AllClientModel.fromJson(json.decode(str));

String allClientModelToJson(AllClientModel data) => json.encode(data.toJson());

class AllClientModel {
  AllClientModel({
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
  List<Datum>? data;

  factory AllClientModel.fromJson(Map<String, dynamic> json) => AllClientModel(
        pageNumber: json["PageNumber"],
        pageRowsCount: json["PageRowsCount"],
        lastPage: json["LastPage"],
        pagesCount: json["PagesCount"],
        resultCount: json["ResultCount"],
        totalPersonsCount: json["TotalPersonsCount"],
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
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

  @override
  String toString() {
    return "AllClientModel{data: $data,lastPage:$lastPage ,pageNumber:$pagesCount ,pageRowsCount:$pageRowsCount ,pagesCount:$pagesCount ,resultCount: $resultCount,totalPersonsCount: $totalPersonsCount}";
  }
}

class Datum {
  Datum({
    this.id,
    this.barcode,
    this.no,
    this.clientName,
    this.date,
    this.personsCount,
    this.personQuantity,
    this.personVendorName,
    this.idNumber,
    this.supplyingCard,
    this.branchName,
  });

  String? id;
  String? barcode;
  int? no;
  String? clientName;
  Date? date;
  int? personsCount;
  double? personQuantity;
  String? personVendorName;
  String? idNumber;
  String? supplyingCard;
  BranchName? branchName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["Id"],
        barcode: json["Barcode"],
        no: json["No"],
        clientName: json["ClientName"],
        date: dateValues.map![json["Date"]],
        personsCount: json["PersonsCount"],
        personQuantity: json["PersonQuantity"],
        personVendorName: json["PersonVendorName"],
        idNumber: json["IdNumber"],
        supplyingCard: json["SupplyingCard"],
        branchName: branchNameValues.map![json["BranchName"]],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Barcode": barcode,
        "No": no,
        "ClientName": clientName,
        "Date": dateValues.reverse![date],
        "PersonsCount": personsCount,
        "PersonQuantity": personQuantity,
        "PersonVendorName": personVendorName,
        "IdNumber": idNumber,
        "SupplyingCard": supplyingCardValues.reverse![supplyingCard],
        "BranchName": branchNameValues.reverse![branchName],
      };
  @override
  String toString() {
    return "Datum{id:$id ,barcode:$barcode ,clientName:$clientName ,personsCount:$personsCount ,personQuantity:$personQuantity ,personVendorName:$personVendorName }";
  }
}

enum BranchName { EMPTY }

final branchNameValues = EnumValues({"مخبز حسام سعيد": BranchName.EMPTY});

enum Date { THE_202112110000_AM }

final dateValues =
    EnumValues({"2021/12/11 - 00:00:AM": Date.THE_202112110000_AM});

enum SupplyingCard { EMPTY, SUPPLYING_CARD, PURPLE }

final supplyingCardValues = EnumValues({
  "": SupplyingCard.EMPTY,
  "تعديل": SupplyingCard.PURPLE,
  "تعديل ": SupplyingCard.SUPPLYING_CARD
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }

}
