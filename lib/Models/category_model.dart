import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
    this.priceByPoint,
    this.quantity,
    this.total,
  });

  String? id;
  String? name;
  double? priceByPoint;
  int? quantity;
  int? total;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["Id"],
        name: json["Name"],
        priceByPoint: json["PriceByPoint"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "PriceByPoint": priceByPoint,
      };

  @override
  String toString() {
    return 'CategoryModel{ Id: $id, Name: $name, PriceByPoint: $priceByPoint}';
  }
}
