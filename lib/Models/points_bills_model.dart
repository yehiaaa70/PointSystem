import 'dart:convert';

PointsBillsModel pointsBillsModelFromJson(String str) =>
    PointsBillsModel.fromJson(json.decode(str));

String pointsBillsModelToJson(PointsBillsModel data) =>
    json.encode(data.toJson());

class PointsBillsModel {
  int? pageNumber;
  int? pageRowsCount;
  int? lastPage;
  int? pagesCount;
  int? resultCount;
  int? totalPersonsCount;
  List<Data>? data;

  PointsBillsModel(
      {this.pageNumber,
      this.pageRowsCount,
      this.lastPage,
      this.pagesCount,
      this.resultCount,
      this.totalPersonsCount,
      this.data});

  PointsBillsModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['PageNumber'];
    pageRowsCount = json['PageRowsCount'];
    lastPage = json['LastPage'];
    pagesCount = json['PagesCount'];
    resultCount = json['ResultCount'];
    totalPersonsCount = json['TotalPersonsCount'];
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PageNumber'] = pageNumber;
    data['PageRowsCount'] = pageRowsCount;
    data['LastPage'] = lastPage;
    data['PagesCount'] = pagesCount;
    data['ResultCount'] = resultCount;
    data['TotalPersonsCount'] = totalPersonsCount;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? no;
  String? clientName;
  String? insertedDate;
  double? totalPoints;
  String? branchName;
  String? typeName;
  String? machineId;
  String? machineName;

  Data(
      {this.id,
      this.no,
      this.clientName,
      this.insertedDate,
      this.totalPoints,
      this.branchName,
      this.typeName,
      this.machineId,
      this.machineName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    no = json['No'];
    clientName = json['ClientName'];
    insertedDate = json['InsertedDate'];
    totalPoints = json['TotalPoints'];
    branchName = json['BranchName'];
    typeName = json['TypeName'];
    machineId = json['MachineId'];
    machineName = json['MachineName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['No'] = no;
    data['ClientName'] = clientName;
    data['InsertedDate'] = insertedDate;
    data['TotalPoints'] = totalPoints;
    data['BranchName'] = branchName;
    data['TypeName'] = typeName;
    data['MachineId'] = machineId;
    data['MachineName'] = machineName;
    return data;
  }
}
