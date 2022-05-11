// To parse this JSON data, do
//
//     final postPreciseModel = postPreciseModelFromJson(jsonString);

import 'dart:convert';

PostPreciseModel postPreciseModelFromJson(String str) => PostPreciseModel.fromJson(json.decode(str));

String postPreciseModelToJson(PostPreciseModel data) => json.encode(data.toJson());
class PostPreciseModel {
  String? clientId;
  int? quantity;

  PostPreciseModel({this.clientId, this.quantity});

  PostPreciseModel.fromJson(Map<String, dynamic> json) {
    clientId = json['ClientId'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClientId'] = this.clientId;
    data['Quantity'] = this.quantity;
    return data;
  }
}
