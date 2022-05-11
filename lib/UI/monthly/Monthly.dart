import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Models/month_balance.dart';
import '../../Models/pdf_month_balance_model.dart';
import '../../Printer/ImagestorByte.dart';
import '../../Printer/printer.dart';
import '../../cubit/Monthly/monthly_cubit.dart';

// import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../widgets/invoice_one_item.dart';

class Monthly extends StatefulWidget {
  const Monthly({Key? key}) : super(key: key);

  @override
  State<Monthly> createState() => _MonthlyState();
}

final controller = ScrollController();
final _dataGridController = DataGridController();

String pageNum = "1";
List<MonthDatum> paginatedDataSource = [];

class _MonthlyState extends State<Monthly> {
  late OrderInfoDataSource _orderInfoDataSource;

  List<MonthDatum> dataTable = [];
  int x = 0;
  int y = 0;
  int z = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String ipPrinter = "";
  String bluetoothMac = "";
  int _groupValue = 0;
  SharedPreferences? prefs;
  String deviceKind = '';
  ScreenshotController screenshotController = ScreenshotController();
  BuildContext? dialogContext;
  bool dialog =false;

  showAlertDialog(BuildContext context) {
    dialog=true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext=context;
        return AlertDialog(
          title: Center(child: Text("عذرا لا يوجد اتصال بالطابعه")),
          content:
          SizedBox(
            height: 100,
            child: Center(
              child: IconButton(onPressed: (){
                setConnect();
              }, icon: Icon(Icons.refresh)),
            ),
          ),

          actions: [
            TextButton(
              child: Text("اغلاق"),
              onPressed:  () {
                dialog=false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> setConnect() async {
    final String result = await BluetoothThermalPrinter.connect(bluetoothMac)??"لا يوجد اتصال";
    print("state connected $result");
    if (result == "true") {
      setState(() {
        if(dialog==true){
          Navigator.of(dialogContext!).pop();
        }
      });
    }
  }
  getIPPrinterWifi() async {
    prefs = await _prefs;
    setState(() {
      ipPrinter = prefs!.getString('printerIp')!;
      // bluetoothMac = prefs!.getString('printerMac')!;
      _groupValue = prefs!.getInt('chooseType') ?? 0;
    });
  }

  @override
  void initState() {
    getIPPrinterWifi();
    super.initState();
    _orderInfoDataSource = OrderInfoDataSource(z, dataTable);
  }

  BuildContext? monthCubit;
  MonthlyCubit monthlyCubit = MonthlyCubit();

  @override
  Widget build(BuildContext MainContext) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(
                Icons.print,
                color: Colors.blue,
              ),
              onPressed: () async {
                if (_dataGridController.selectedIndex < 0) {
                  Fluttertoast.showToast(
                      msg: "من فضلك اختار المورد!!!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.amber,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  if (_groupValue == 0) {
                    if (ipPrinter.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "برجاء اختيار الطابعه",
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.amber,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      var id = MonthlyCubit.get(monthCubit)
                          .myData[_dataGridController.selectedIndex]
                          .id;
                      MonthlyCubit.get(monthCubit).PostMonthBalancePrint(id!);
                    }
                  } else if (_groupValue == 1) {
                    if (bluetoothMac.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "برجاء اختيار الطابعه اولا ",
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.amber,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      String? isConnected = await BluetoothThermalPrinter.connectionStatus;
                      if(isConnected=="true"){
                        var id = MonthlyCubit.get(monthCubit)
                            .myData[_dataGridController.selectedIndex]
                            .id;
                        MonthlyCubit.get(monthCubit).PostMonthBalancePrint(id!);
                      }else{
                        showAlertDialog(context);
                      }
                    }
                  }
                }
              },
            ),
          ],
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'جدول الحصص الشهريه',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        body: BlocProvider(
            create: (context) => MonthlyCubit()..getMonthBalance(),
            child: BlocConsumer<MonthlyCubit, MonthlyState>(
              listener: (context, state) {},
              builder: (context, state) {
                monthCubit = context;
                monthlyCubit = MonthlyCubit.get(context);

                if (state is PrintingMonthlyLoading) {
                  return showLoadingIndicator();
                } else if (state is PrintingMonthlySuccess) {



                  Fluttertoast.showToast(
                      msg: "تمت العمليه",
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  if (_groupValue == 0) {
                    screenshotController
                        .capture(delay: const Duration(milliseconds: 10))
                        .then((Uint8List? image) async {
                      monthlyCubit.testPrint(image!, ipPrinter);
                      Navigator.of(context).pop();
                    }).catchError((onError) {
                      print(onError);
                    });
                  } else if (_groupValue == 1) {
                    screenshotController.capture().then((Uint8List? image) async {
                      monthlyCubit.printTicket(image!);
                    }).catchError((onError) {
                      print(onError);
                    });
                  }

                } else if (state is PrintingMonthlyField) {
                  Fluttertoast.showToast(
                      msg: monthlyCubit.error.toString().substring(10),
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (state is getIpsMonthly) {
                  bluetoothMac = monthlyCubit.bluetoothMac;
                  setConnect();
                }else if (state is KillFinishMonthly) {
                   monthlyCubit.pdfMonthBalanceModel=PdfMonthBalanceModel();
                }

                _orderInfoDataSource = OrderInfoDataSource(
                  MonthlyCubit.get(context).myData.length,
                  MonthlyCubit.get(context).myData,
                );
                // _orderInfoDataSource.addListener(updateWidget);
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 10,
                          child: ConditionalBuilder(
                            condition: state is! MonthlyLoading,
                            builder: (context) =>
                                LayoutBuilder(builder: (context, constraint) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                          height: constraint.maxHeight,
                                          width: constraint.maxWidth,
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: SfDataGrid(
                                                selectionMode: SelectionMode.single,
                                                navigationMode: GridNavigationMode.row,
                                                controller: _dataGridController,
                                                source: _orderInfoDataSource,
                                                columnWidthMode:
                                                ColumnWidthMode.fitByCellValue,
                                                columns: <GridColumn>[
                                                  GridColumn(
                                                      columnName: 'No',
                                                      label: Container(
                                                          padding:
                                                          const EdgeInsets.all(6.0),
                                                          alignment: Alignment.center,
                                                          child: const Text('العدد'))),
                                                  GridColumn(
                                                      columnName: 'ClientName',
                                                      label: Container(
                                                          padding:
                                                          const EdgeInsets.all(6.0),
                                                          alignment: Alignment.center,
                                                          child: const Text(
                                                            'اسم المورد',
                                                            overflow: TextOverflow.fade,
                                                          ))),
                                                  GridColumn(
                                                      columnWidthMode:
                                                      ColumnWidthMode.auto,
                                                      columnName: 'Month',
                                                      label: Container(
                                                          padding:
                                                          const EdgeInsets.all(6.0),
                                                          alignment: Alignment.center,
                                                          child: const Text(
                                                            'الشهر',
                                                            overflow: TextOverflow.fade,
                                                          ))),
                                                  GridColumn(
                                                      columnWidthMode:
                                                      ColumnWidthMode.auto,
                                                      columnName: 'Year',
                                                      label: Container(
                                                          padding:
                                                          const EdgeInsets.all(6.0),
                                                          alignment: Alignment.center,
                                                          child: const Text(
                                                            'السنه',
                                                            overflow: TextOverflow.fade,
                                                            maxLines: 1,
                                                          ))),
                                                  GridColumn(
                                                      columnWidthMode:
                                                      ColumnWidthMode.auto,
                                                      columnName: 'OpenedBalance',
                                                      label: Container(
                                                          padding:
                                                          const EdgeInsets.all(6.0),
                                                          alignment: Alignment.center,
                                                          child: const Text(
                                                            'الرصيد الافتتاحى',
                                                            overflow: TextOverflow.fade,
                                                            maxLines: 1,
                                                          ))),
                                                  GridColumn(
                                                      columnWidthMode:
                                                      ColumnWidthMode.auto,
                                                      columnName: 'DefaultBalance',
                                                      label: Container(
                                                          padding:
                                                          const EdgeInsets.all(6.0),
                                                          alignment: Alignment.center,
                                                          child: const Text(
                                                            'الرصيد الافتراضي',
                                                            overflow: TextOverflow.fade,
                                                            maxLines: 1,
                                                          ))),
                                                ]),
                                          )),
                                    ],
                                  );
                                }),
                            fallback: (context) {
                              _dataGridController.selectedIndex = -1;
                              return showLoadingIndicator();
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 60,
                                    width: 80,
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            controller.position.animateTo(
                                              controller.position.minScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                              curve: Curves.easeInOut,
                                            );
                                            monthlyCubit.changePage(1);
                                            monthlyCubit.isSelected = 0;
                                          },
                                          icon: const Icon(Icons.first_page)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                      controller: controller,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: monthlyCubit.pageCount,
                                      itemBuilder: (context, position) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              monthlyCubit.changePage(position + 1);
                                              monthlyCubit.isSelected = position;
                                            },
                                            child: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                monthlyCubit.isSelected ==
                                                    position
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                child: Center(
                                                  child: Text(
                                                    "${position + 1}",
                                                    style: const TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 60,
                                    width: 80,
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            final contentSize = controller
                                                .position.viewportDimension +
                                                controller.position.maxScrollExtent;

                                            final target = contentSize;

                                            controller.position.animateTo(
                                              target,
                                              duration:
                                              const Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                            monthlyCubit
                                                .changePage(monthlyCubit.pageCount);
                                            monthlyCubit.isSelected =
                                                monthlyCubit.pageCount - 1;
                                          },
                                          icon: const Icon(Icons.last_page)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child:
                        monthlyCubit.pdfMonthBalanceModel.clientName==null?Container():
                        Container(child: Model(monthlyCubit.pdfMonthBalanceModel,context))
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }

  Widget showLoadingIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );

  DialogMonthly({PdfMonthBalanceModel? model, BuildContext? context}) {
    return showDialog(
        barrierDismissible: false,
        context: context!,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              content: SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Model(model!, context)),
            ));
  }

  Widget Model(PdfMonthBalanceModel model, BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double? width;
    double? containerWidth;
    if (aspectRatio <= 0.45) {
      width = 7;
      containerWidth = 155;
    } else if (aspectRatio > 0.45 && aspectRatio < 0.47) {
      width = 9;
      containerWidth = 250;
    } else if (aspectRatio < 0.47 && aspectRatio < 0.49) {
      width = 12;
      containerWidth = 350;
    } else {
      width = 12;
      containerWidth = 240;
    }
    return Opacity(
      opacity: 0.01,
      child: SingleChildScrollView(
        child: Screenshot(
                controller: screenshotController,
                child: SizedBox(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: containerWidth,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            children: [
                              Container(
                                color: Colors.black54,
                                child: Center(
                                  child: Text(
                                    "تقرير حصة شهر لعميل",
                                    style: TextStyle(
                                        fontSize: width + 2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      " شهر ",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${model.month}",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    const Spacer(),
                                    Text(
                                      " سنة ",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${model.year}",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                "${model.clientName}",
                                                style: TextStyle(
                                                    fontSize: width,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "${model.idNumber}",
                                                style: TextStyle(
                                                    fontSize: width,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            " عدد الافراد  ${model.personsCount}",
                                            style: TextStyle(
                                                fontSize: width,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      "حصة الشهر",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${model.defaultBalance}",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "الرصيد المرحل من الشهر السابق ",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${model.oldBalance}",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      "اجمالي الرصيد",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    const Spacer(),
                                    Text(
                                      "${model.totalBalance}      نقطة",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      "تاريخ العملية",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "الاسم",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "كميه",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "اجمالي",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: model.details!.length,
                                  physics:
                                      const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return invoiceOneItem(
                                        model.details![index]
                                            .insertedDate!,
                                        model.details![index].name!,
                                        model.details![index].quantity!,
                                        model.details![index]
                                            .totalPoints!,
                                        width!);
                                  }),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      "الاجمالي",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${model.totalUse}",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      "الرصيد الباقى ",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${model.rest}",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class OrderInfoDataSource extends DataGridSource {
  int i = 0;
  List<MonthDatum> list = [];
  List<DataGridRow> dataGridRows = [];

  OrderInfoDataSource(this.i, this.list) {
    paginatedDataSource = list.getRange(0, i).toList();
    buildPaginatedDataGridRows();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startRowIndex = newPageIndex * i;
    int endIndex = startRowIndex + i;

    pageNum = "${newPageIndex + 1}";
    notifyListeners();

    if (startRowIndex < list.length && endIndex <= list.length) {
      await Future.delayed(const Duration(milliseconds: 2000));
      paginatedDataSource =
          list.getRange(startRowIndex, endIndex).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      paginatedDataSource = [];
    }
    return true;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor() {
      int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return Colors.white10;
      } else {
        return Colors.black38;
      }
    }

    TextStyle? getSelectionTextStyle() {
      return _dataGridController.selectedRows.contains(row)
          ? const TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.blue,
            )
          : null;
    }

    Decoration? getSelectionBorderStyle() {
      return _dataGridController.selectedRows.contains(row)
          ? BoxDecoration(border: Border.all(color: Colors.blue))
          : null;
    }

    return DataGridRowAdapter(
        color: getBackgroundColor(),
        cells: row.getCells().map<Widget>((e) {
          return Container(
            decoration: getSelectionBorderStyle(),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value.toString(),
              style: getSelectionTextStyle(),
            ),
          );
        }).toList());
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedDataSource.map<DataGridRow>((dataGridRow) {
      notifyListeners();
      return DataGridRow(cells: [
        DataGridCell(columnName: 'No', value: dataGridRow.no),
        DataGridCell(columnName: 'ClientName', value: dataGridRow.clientName),
        DataGridCell(columnName: 'Month', value: dataGridRow.month),
        DataGridCell(columnName: 'Year', value: dataGridRow.year),
        DataGridCell(
            columnName: 'OpenedBalance', value: dataGridRow.openedBalance),
        DataGridCell(
            columnName: 'DefaultBalance', value: dataGridRow.defaultBalance),
      ]);
    }).toList(growable: false);
  }
}
