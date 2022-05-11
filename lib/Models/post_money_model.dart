// To parse this JSON data, do
//
//     final postMoneyModel = postMoneyModelFromJson(jsonString);

import 'dart:convert';

PostMoneyModel postMoneyModelFromJson(String str) => PostMoneyModel.fromJson(json.decode(str));

String postMoneyModelToJson(PostMoneyModel data) => json.encode(data.toJson());

class PostMoneyModel {
  PostMoneyModel({
    this.clientId,
    this.pointsQuantity,
  });

  String? clientId;
  int? pointsQuantity;

  factory PostMoneyModel.fromJson(Map<String, dynamic> json) => PostMoneyModel(
    clientId: json["ClientId"],
    pointsQuantity: json["PointsQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "PointsQuantity": pointsQuantity,
  };
}
