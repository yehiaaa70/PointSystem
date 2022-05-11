// To parse this JSON data, do
//
//     final machineModel = machineModelFromJson(jsonString);

import 'dart:convert';

MachineModel machineModelFromJson(String str) => MachineModel.fromJson(json.decode(str));

String machineModelToJson(MachineModel data) => json.encode(data.toJson());
class MachineModel {
  int? id;
  int? no;
  String? clientName;
  String? date;
  String? time;
  String? itemTypeName;
  double? totalPoints;
  String? branchName;
  List<Details>? details;

  MachineModel(
      {this.id,
        this.no,
        this.clientName,
        this.date,
        this.time,
        this.itemTypeName,
        this.totalPoints,
        this.branchName,
        this.details});

  MachineModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    no = json['No'];
    clientName = json['ClientName'];
    date = json['Date'];
    time = json['Time'];
    itemTypeName = json['ItemTypeName'];
    totalPoints = json['TotalPoints'];
    branchName = json['BranchName'];
    if (json['Details'] != null) {
      details = <Details>[];
      json['Details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['No'] = no;
    data['ClientName'] = clientName;
    data['Date'] = date;
    data['Time'] = time;
    data['ItemTypeName'] = itemTypeName;
    data['TotalPoints'] = totalPoints;
    data['BranchName'] = branchName;
    if (details != null) {
      data['Details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? itemId;
  String? itemBarcode;
  String? itemName;
  double? quantity;
  int? pricePerPoint;
  int? total;

  Details(
      {this.itemId,
        this.itemBarcode,
        this.itemName,
        this.quantity,
        this.pricePerPoint,
        this.total});

  Details.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    itemBarcode = json['ItemBarcode'];
    itemName = json['ItemName'];
    quantity = json['Quantity'];
    pricePerPoint = json['PricePerPoint'];
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemId'] = itemId;
    data['ItemBarcode'] = itemBarcode;
    data['ItemName'] = itemName;
    data['Quantity'] = quantity;
    data['PricePerPoint'] = pricePerPoint;
    data['Total'] = total;
    return data;
  }
}

