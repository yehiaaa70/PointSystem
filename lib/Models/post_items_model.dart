// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

PostItemsBillsModel clientModelFromJson(String str) => PostItemsBillsModel.fromJson(json.decode(str));

String clientModelToJson(PostItemsBillsModel data) => json.encode(data.toJson());

class PostItemsBillsModel {
  PostItemsBillsModel({
    this.clientId,
    this.total,
    this.details,
  });

  String? clientId;
  int? total;
  List<Detail>? details;

  factory PostItemsBillsModel.fromJson(Map<String, dynamic> json) => PostItemsBillsModel(
    clientId: json["ClientId"],
    total: json["Total"],
    details: List<Detail>.from(json["Details"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "Total": total,
    "Details": List<dynamic>.from(details!.map((x) => x.toJson())),
  };
  @override
  String toString() {
    return 'PostItemsBillsModel{ Id: $clientId, total: $total, Details: $details}';
  }

}

class Detail {
  Detail({
    this.itemId,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
  });

  String? itemId;
  int? quantity;
  int? unitPrice;
  int? totalPrice;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    itemId: json["ItemId"],
    quantity: json["Quantity"],
    unitPrice: json["UnitPrice"],
    totalPrice: json["TotalPrice"],
  );

  Map<String, dynamic> toJson() => {
    "ItemId": itemId,
    "Quantity": quantity,
    "UnitPrice": unitPrice,
    "TotalPrice": totalPrice,
  };
  @override
  String toString() {
    // TODO: implement toString
    return "Details{ id: $itemId ,Quantity: $quantity ,UnitPrice: $unitPrice ,TotalPrice: $totalPrice }";
  }

}
