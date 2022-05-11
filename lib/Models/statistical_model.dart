import 'dart:convert';

StatisticalModel statisticalModelFromJson(String str) =>
    StatisticalModel.fromJson(json.decode(str));

String statisticalModelToJson(StatisticalModel data) =>
    json.encode(data.toJson());

class StatisticalModel {
  StatisticalModel({
    this.graph,
    this.clientsCount,
    this.monthTotalBalance,
    this.balanceCarried,
    this.totalSpentPointsToday,
    this.totalSpentPointsThisMonth,
    this.moneyInTheBakery,
  });

  List<Graph>? graph;
  int? clientsCount;
  int? monthTotalBalance;
  int? balanceCarried;
  double? totalSpentPointsToday;
  double? totalSpentPointsThisMonth;
  double? moneyInTheBakery;

  factory StatisticalModel.fromJson(Map<String, dynamic> json) =>
      StatisticalModel(
        graph: List<Graph>.from(json["Graph"].map((x) => Graph.fromJson(x))),
        clientsCount: json["ClientsCount"],
        monthTotalBalance: json["MonthTotalBalance"],
        balanceCarried: json["BalanceCarried"],
        totalSpentPointsToday: json["TotalSpentPointsToday"],
        totalSpentPointsThisMonth: json["TotalSpentPointsThisMonth"],
        moneyInTheBakery: json["MoneyInTheBakery"],
      );

  Map<String, dynamic> toJson() => {
        "Graph": List<dynamic>.from(graph!.map((x) => x.toJson())),
        "ClientsCount": clientsCount,
        "MonthTotalBalance": monthTotalBalance,
        "BalanceCarried": balanceCarried,
        "TotalSpentPointsToday": totalSpentPointsToday,
        "TotalSpentPointsThisMonth": totalSpentPointsThisMonth,
        "MoneyInTheBakery": moneyInTheBakery,
      };
}

class Graph {
  Graph({
    this.date,
    this.dayName,
    this.pointsCount,
  });

  DateTime? date;
  String? dayName;
  int? pointsCount;

  factory Graph.fromJson(Map<String, dynamic> json) => Graph(
        date: DateTime.parse(json["Date"]),
        dayName: json["DayName"],
        pointsCount: json["PointsCount"],
      );

  Map<String, dynamic> toJson() => {
        "Date": date!.toIso8601String(),
        "DayName": dayName,
        "PointsCount": pointsCount,
      };
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }

}
