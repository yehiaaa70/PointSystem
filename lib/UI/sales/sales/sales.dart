import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test_project/UI/sales/points_bills/point_bills.dart';
import 'dart:math';

import '../../../Models/statistical_model.dart';
import '../../../cubit/Home/sales_cubit.dart';
import '../../widgets/end_drawer_home.dart';
import '../category/category.dart';
import '../../widgets/circular_percent_indicator.dart';
import '../../widgets/dot_line.dart';
import '../../widgets/widget_card_item.dart';
import '../bread/spend_bread.dart';
import '../flour/flour.dart';
import 'manual_barcode.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String? _kinds;
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String bluetoothMac = "";
  int _groupValue = 0;
  SharedPreferences? prefs;
  @override
  void initState() {
    getIPPrinterWifi();
    super.initState();
  }
  getIPPrinterWifi() async {
    prefs = await _prefs;
    setState(() {
      bluetoothMac = prefs!.getString('printerMac')!;
      _groupValue = prefs!.getInt('chooseType') ?? 0;
    });
  }

  @override
  Widget build(BuildContext mainContext) {
    return BlocProvider(
        create: (context) => SalesCubit()..getStatistical(),
        child: BlocConsumer<SalesCubit, SalesState>(
          listener: (context, state) {},
          builder: (context, state) {
            SalesCubit salesCubit = SalesCubit.get(context);

            if (state is MonthlyLoading) {
              Fluttertoast.showToast(
                  msg: "برجاء الانتظار",
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.amber,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return showLoadingIndicator();
            } else if (state is MonthlySuccess) {
              Fluttertoast.showToast(
                  msg: "تم انشاء الحصه الشهريه بنجاح",
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return SalesScreen();
            } else if (state is MonthlyField) {
              Fluttertoast.showToast(
                  msg: "ثمت خطأ فى انشاء الحصه الشهريه",
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }

            if (state is ClientMainLoading) {
              return showLoadingIndicator();
            } else if (state is ClientMainSuccess) {
              salesCubit.finishPrint();
              condition(salesCubit);
            } else if (state is ClientMainField) {
              Fluttertoast.showToast(
                  msg: "الباركود غير موجود",
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              salesCubit.finishPrint();
            }
            if (state is PointsLoadingState) {
              setConnect();
              return showLoadingIndicator();
            } else if (state is PointsSuccessState) {
              return screen(salesCubit);
            } else {
              return Center(child: Lottie.asset("assets/images/data.json"));
            }
          },
        ));
  }

  Widget showLoadingIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );

  Future<void> setConnect() async {
    print("aaaa");
    final String? result =
        await BluetoothThermalPrinter.connect("bluetoothMac");
    print("state connected 00000 $result");
    if (result == "true") {
      setState(() {
        print("true");
      });
    }
  }

  condition(SalesCubit salesCubit) {
    if (_kinds == "Points") {
      print("points");

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PointBills(data: salesCubit.clientModel)));
      });
    } else if (_kinds == "Items") {
      print("items");

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Category(data: salesCubit.clientModel)));
      });
    } else if (_kinds == "Flowers") {
      print("flowers");
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FlourScreen(data: salesCubit.clientModel)));
      });
    } else if (_kinds == "Bread") {
      print("bread");
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SpendingBread(data: salesCubit.clientModel)));
      });
    }
  }

  Widget screen(SalesCubit salesCubit) => Scaffold(
        endDrawerEnableOpenDragGesture: false,
        key: _scaffold,
        endDrawer: MainDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        width: 30,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(5.0),
                          height: 80,
                          child: Image.asset(
                            'assets/images/logo.png',
                            alignment: Alignment.topCenter,
                            height: 80,
                            width: 80,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          _scaffold.currentState!.openEndDrawer();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Image.asset("assets/images/menu.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 30.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Welcome",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text(
                                " Hossam :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.blueAccent),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.only(right: 20.0, bottom: 20.0),
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              ' ${salesCubit.date}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.only(right: 20.0, bottom: 20.0),
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              ' ${salesCubit.allTimeFormatted}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: cardItem(
                              icon: "assets/images/wallet.png",
                              name: "استبدال النقاط",
                              pressFunction: () async {
                                String scanResult0 =
                                    await FlutterBarcodeScanner.scanBarcode(
                                  "#ff6666",
                                  "ادخال يدوى",
                                  true,
                                  ScanMode.BARCODE,
                                );
                                if (scanResult0 != "-1") {
                                  _kinds = 'Points';
                                  salesCubit.getClientByBarcode(scanResult0);
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ManualBarcode(
                                            kind: 'Points',
                                          )));
                                }
                              })),
                      Expanded(
                          child: cardItem(
                        pressFunction: () async {
                          String scanResult0 =
                              await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666",
                            "ادخال يدوى",
                            true,
                            ScanMode.BARCODE,
                          );
                          print(scanResult0);
                          if (scanResult0 != "-1") {
                            _kinds = 'Items';
                            salesCubit.getClientByBarcode(scanResult0);
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ManualBarcode(
                                      kind: 'Items',
                                    )));
                          }
                        },
                        icon: "assets/images/products.png",
                        name: "صرف سلعة",
                      )),
                      Expanded(
                          child: cardItem(
                              icon: "assets/images/wheat.png",
                              name: "صرف دقيق",
                              pressFunction: () async {
                                String scanResult0 =
                                    await FlutterBarcodeScanner.scanBarcode(
                                  "#ff6666",
                                  "ادخال يدوى",
                                  true,
                                  ScanMode.BARCODE,
                                );

                                if (scanResult0 != "-1") {
                                  _kinds = 'Flowers';
                                  salesCubit.getClientByBarcode(scanResult0);
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ManualBarcode(
                                            kind: 'Flowers',
                                          )));
                                }
                              })),
                      Expanded(
                          child: cardItem(
                              icon: "assets/images/breead.png",
                              name: "صرف خبز",
                              pressFunction: () async {
                                String scanResult0 =
                                    await FlutterBarcodeScanner.scanBarcode(
                                  "#ff6666",
                                  "ادخال يدوى",
                                  true,
                                  ScanMode.BARCODE,
                                );
                                print("scanResult0");
                                print(scanResult0);

                                if (scanResult0 != "-1") {
                                  _kinds = 'Bread';
                                  salesCubit.getClientByBarcode(scanResult0);
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ManualBarcode(
                                            kind: 'Bread',
                                          )));
                                }
                              })),
                    ],
                  ),
                ),
                dotLine(),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20.0),
                  width: double.infinity,
                  child: const Text(
                    " : عدد النقاط المستهلكة اليوم",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 30.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: salesCubit.maxGraph.reduce(max).toDouble()+1000,
                            interval: 20),
                        tooltipBehavior: salesCubit.tooltip,
                        series: <ChartSeries<Graph, dynamic>>[
                          ColumnSeries<Graph, dynamic>(
                              dataSource: salesCubit.myGraph,
                              xValueMapper: (Graph graph, _) => graph.dayName,
                              yValueMapper: (Graph graph, _) =>
                                  graph.pointsCount,
                              name: 'عدد النقاط المستهلكة ليوم',
                              color: const Color.fromRGBO(14, 113, 179, 1.0))
                        ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    circularPercentIndicator(
                      fotterText: "إجمالي رصيد الشهر",
                      centerText: salesCubit.statisticalModel.monthTotalBalance
                          .toString(),
                    ),
                    circularPercentIndicator(
                        fotterText: "عدد العملاء",
                        centerText:
                            salesCubit.statisticalModel.clientsCount.toString(),
                        percent: 100),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    circularPercentIndicator(
                        fotterText: "مجموع النقاط المنفقة اليوم",
                        centerText: salesCubit
                            .statisticalModel.totalSpentPointsToday
                            .toString(),
                        //int.parse(1.toString().padRight(salesCubit.statisticalModel.totalSpentPointsToday.toString().length-2, '0'))
                        percent: 100),
                    circularPercentIndicator(
                        fotterText: "إجمالي الرصيد المستهلك",
                        centerText: salesCubit.statisticalModel.balanceCarried
                            .toString(),
                        percent: 100),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    circularPercentIndicator(
                        fotterText: "الرصيد في المخبز",
                        centerText: salesCubit.statisticalModel.moneyInTheBakery
                            .toString(),
                        percent: 100),
                    circularPercentIndicator(
                        fotterText: "النقاط المستهلك هذا الشهر",
                        centerText: salesCubit
                            .statisticalModel.totalSpentPointsThisMonth
                            .toString(),
                        percent: 100),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.asset("assets/images/calendar.png"),
                    label: const Text('انشاء الحصه الشهريه'),
                    onPressed: () {
                      salesCubit.postMonthBalance();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      );
}
