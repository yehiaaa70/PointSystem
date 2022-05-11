// To parse this JSON data, do
//
//     final postBread = postBreadFromJson(jsonString);

import 'dart:convert';

PostBread postBreadFromJson(String str) => PostBread.fromJson(json.decode(str));

String postBreadToJson(PostBread data) => json.encode(data.toJson());

class PostBread {
  PostBread({
    this.clientId,
    this.breadQuantity,
  });

  String? clientId;
  int? breadQuantity;

  factory PostBread.fromJson(Map<String, dynamic> json) => PostBread(
    clientId: json["ClientId"],
    breadQuantity: json["BreadQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "BreadQuantity": breadQuantity,
  };
}
