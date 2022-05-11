// To parse this JSON data, do
//
//     final itemsUnits = itemsUnitsFromJson(jsonString);

import 'dart:convert';

List<ItemsUnits> itemsUnitsFromJson(String str) => List<ItemsUnits>.from(json.decode(str).map((x) => ItemsUnits.fromJson(x)));

String itemsUnitsToJson(List<ItemsUnits> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemsUnits {
  ItemsUnits({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory ItemsUnits.fromJson(Map<String, dynamic> json) => ItemsUnits(
    id: json["Id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
  };
}
