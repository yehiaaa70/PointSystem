// To parse this JSON data, do
//
//     final itemsCategories = itemsCategoriesFromJson(jsonString);

import 'dart:convert';

List<ItemsCategories> itemsCategoriesFromJson(String str) => List<ItemsCategories>.from(json.decode(str).map((x) => ItemsCategories.fromJson(x)));

String itemsCategoriesToJson(List<ItemsCategories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemsCategories {
  ItemsCategories({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory ItemsCategories.fromJson(Map<String, dynamic> json) => ItemsCategories(
    id: json["Id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
  };
}
