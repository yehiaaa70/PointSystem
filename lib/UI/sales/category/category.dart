import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_project/Models/category_model.dart';
import 'package:test_project/Models/post_items_model.dart';
import 'package:test_project/cubit/Items/items_cubit.dart';
import '../../../Models/client_model.dart';
import '../../../Models/pdfItems.dart';
import '../../../Printer/item.dart';
import 'package:intl/intl.dart' as intl;
import '../../widgets/category_item.dart';

class Category extends StatefulWidget {
  const Category({Key? key, required this.data}) : super(key: key);

  final ClientModel data;

  @override
  State<Category> createState() => _CategoryState();
}

List<CategoryModel> paginatedDataSource = [];
String pageNum = "1";

class _CategoryState extends State<Category> {
  BuildContext? contextTable;
  double fixHeight = 0;
  List<CategoryModel> catList = [];
  List<Detail> postList = [];
  int currentNumBasket = 0;
  int totalPrice = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String ipPrinter = "";
  String bluetoothMac = "";
  int _groupValue = 0;
  SharedPreferences? prefs;
  String deviceKind = '';
  ScreenshotController screenshotController = ScreenshotController();
  BuildContext? dialogContext;
  bool dialog = false;
  String save = "";

  OrderInfoDataSource _orderInfoDataSource = OrderInfoDataSource(
    0,
    [],
  );

  showAlertDialog(BuildContext context) {
    dialog = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          title: Center(child: Text("عذرا لا يوجد اتصال بالطابعه")),
          content: SizedBox(
            height: 100,
            child: Center(
              child: IconButton(
                  onPressed: () {
                    setConnect();
                  },
                  icon: Icon(Icons.refresh)),
            ),
          ),
          actions: [
            TextButton(
              child: Text("اغلاق"),
              onPressed: () {
                dialog = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> setConnect() async {
    final String result =
        await BluetoothThermalPrinter.connect(bluetoothMac) ?? "لا يوجد اتصال";
    print("state connected $result");
    if (result == "true") {
      setState(() {
        if (dialog == true) {
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

  updateWidget() {
    setState(() {});
  }

  Widget showLoadingIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );

  @override
  void initState() {
    super.initState();
    getIPPrinterWifi();
    _orderInfoDataSource.addListener(updateWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ItemsCubit()..getCategoryItems(),
        child: BlocConsumer<ItemsCubit, ItemsState>(
            listener: (context, state) {},
            builder: (context, state) {
              ItemsCubit itemsCubit = ItemsCubit.get(context);

              if (state is PrintingLoadingItem) {
                return showLoadingIndicator();
              } else if (state is PrintingSuccessItem) {
                if(save=="save & print"){
                  Fluttertoast.showToast(
                      msg: "تم الحفظ والطباعه",
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  if (_groupValue == 0) {
                    screenshotController
                        .capture(delay: const Duration(milliseconds: 10))
                        .then((Uint8List? image) async {
                      itemsCubit.testPrint(image!, ipPrinter);
                      Navigator.of(context).pop();
                    }).catchError((onError) {
                      print(onError);
                    });
                  } else if (_groupValue == 1) {
                    screenshotController.capture().then((Uint8List? image) async {
                      itemsCubit.printTicket(image!);
                      Navigator.of(context).pop();
                    }).catchError((onError) {
                      print(onError);
                    });
                  }
                }else if(save=="save only"){
                  Fluttertoast.showToast(
                      msg: "تم الحفظ",
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  itemsCubit.SaveOnly();
                  Navigator.of(context).pop();                }
              } else if (state is PrintingFieldItem) {
                Fluttertoast.showToast(
                    msg: itemsCubit.error.toString().substring(10),
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (state is getIpsItem) {
                bluetoothMac = itemsCubit.bluetoothMac;
                setConnect();
              }

              return Scaffold(
                appBar: AppBar(
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Center(
                          child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                "$totalPrice",
                                style: const TextStyle(color: Colors.white),
                              ))),
                    ),
                  ],
                  title: const Center(
                    child: Text("صـرف سلعة تمونية بالنـقاط",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
                body: screen(widget.data, itemsCubit, context),
              );
            }));
  }

  Widget screen(
      ClientModel? model, ItemsCubit itemsCubit, BuildContext contextItems) {
    contextTable = contextItems;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                child: Table(
                  border: TableBorder.all(
                    color: Colors.grey,
                  ),
                  children: [
                    TableRow(children: [
                      Table(
                        border: TableBorder.all(
                          color: Colors.grey,
                        ),
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('رقم العميل'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "${widget.data.no}" == "null"
                                    ? "لا يوجد"
                                    : "${widget.data.no}",
                                style: TextStyle(
                                    color: widget.data.no == null
                                        ? Colors.red
                                        : Colors.blue),
                              )),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('الباركود'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(widget.data.barcode!,
                                      style:
                                          const TextStyle(color: Colors.blue))),
                            ),
                          ])
                        ],
                      ),
                    ]),
                    TableRow(children: [
                      Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('اسم العميل'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "${widget.data.name}" == "null"
                                    ? "لا يوجد"
                                    : "${widget.data.name}",
                                style: TextStyle(
                                    color: widget.data.name == null
                                        ? Colors.red
                                        : Colors.blue),
                              )),
                            ),
                          ])
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Table(
                        border: TableBorder.all(
                          color: Colors.grey,
                        ),
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('عدد الافراد'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "${widget.data.personsCount}" == "null"
                                    ? "لا يوجد"
                                    : "${widget.data.personsCount}",
                                style: TextStyle(
                                    color: widget.data.personsCount == null
                                        ? Colors.red
                                        : Colors.blue),
                              )),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('حصه الفرد'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "${widget.data.personQuantity}" == "null"
                                    ? "لا يوجد"
                                    : "${widget.data.personQuantity!.toInt()}",
                                style: TextStyle(
                                    color: widget.data.personQuantity == null
                                        ? Colors.red
                                        : Colors.blue),
                              )),
                            ),
                          ])
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('الحصه الشهريه'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "${widget.data.defaultBalance}" == "null"
                                    ? "لا يوجد"
                                    : "${widget.data.defaultBalance}",
                                style: TextStyle(
                                    color: widget.data.defaultBalance == null
                                        ? Colors.red
                                        : Colors.blue),
                              )),
                            ),
                          ])
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('النقاط المرحله من الشهر السابق'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "${widget.data.pointFromLastMonth}" == "null"
                                    ? "لا يوجد"
                                    : "${widget.data.pointFromLastMonth}",
                                style: TextStyle(
                                    color:
                                        widget.data.pointFromLastMonth == null
                                            ? Colors.red
                                            : Colors.blue),
                              )),
                            ),
                          ])
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('عدد النقاط المستهلكه حتى الان'),
                            ),
                            Center(
                                child: Text(
                              "${widget.data.pointsConsumedToNow}" == "null"
                                  ? "لا يوجد"
                                  : "${widget.data.pointsConsumedToNow}",
                              style: TextStyle(
                                  color: widget.data.pointsConsumedToNow == null
                                      ? Colors.red
                                      : Colors.blue),
                            )),
                          ])
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('رصيد الخبز المتبقى'),
                            ),
                            Center(
                                child: Text(
                              "${widget.data.breadBalance}" == 'null'
                                  ? "لا يوجد"
                                  : "${widget.data.breadBalance}",
                              style: TextStyle(
                                  color: widget.data.breadBalance == null
                                      ? Colors.red
                                      : Colors.blue),
                            )),
                          ])
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('الرصيد السابق المتبقى'),
                            ),
                            Center(
                                child: Text(
                              "${widget.data.openedRest}" == "null"
                                  ? "لا يوجد"
                                  : "${widget.data.openedRest}",
                              style: TextStyle(
                                  color: widget.data.openedRest == null
                                      ? Colors.red
                                      : Colors.blue),
                            )),
                          ])
                        ],
                      )
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              child: tableOfItems(catList, model!.id, itemsCubit),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 25,
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 4 / 5,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: itemsCubit.categoryModel.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () async {
                    if (catList.isEmpty) {
                      catList.add(itemsCubit.categoryModel[index]);
                      setState(() {
                        fixHeight = fixHeight + 50;
                      });
                      totalPrice = totalPrice +
                          itemsCubit.categoryModel[index].priceByPoint!.toInt();
                      _orderInfoDataSource = OrderInfoDataSource(
                        catList.length,
                        catList,
                      );
                      _orderInfoDataSource.addListener(updateWidget);
                    } else {
                      bool containsItem = catList.any((element) =>
                          element.name == itemsCubit.categoryModel[index].name);

                      if (containsItem == true) {
                        Fluttertoast.showToast(
                            msg: "السلعه موجوده بالفعل",
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.amber,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        catList.add(itemsCubit.categoryModel[index]);
                        setState(() {
                          fixHeight = fixHeight + 50;
                        });
                        totalPrice = totalPrice +
                            itemsCubit.categoryModel[index].priceByPoint!
                                .toInt();
                        _orderInfoDataSource = OrderInfoDataSource(
                          catList.length,
                          catList,
                        );
                        _orderInfoDataSource.addListener(updateWidget);
                      }
                    }
                  },
                  child: CategoryItem(
                    categoryModel: itemsCubit.categoryModel[index],
                  ),
                );
              },
            ),
            PrintModel(itemsCubit.pdfItemsModel),
          ],
        ),
      ),
    );
  }

  Widget PrintModel(PdfItemsModel model) {
    if (model.clientName == null) {
      return Container();
    } else {
      double? width;
      double? containerWidth;
      double aspectRatio = MediaQuery.of(context).size.aspectRatio;
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
        child: Screenshot(
            controller: screenshotController,
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
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                "مخبز حسام سعيد",
                                style: TextStyle(
                                    fontSize: width,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                "عملية بيع ناجحة",
                                style: TextStyle(
                                    fontSize: width,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "رقم: ${model.no}",
                                        style: TextStyle(
                                            fontSize: width,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        "${model.machineName}",
                                        style: TextStyle(
                                            fontSize: width,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        " تاريخ : ${intl.DateFormat.yMMMd().format(model.date!)}",
                                        style: TextStyle(
                                            fontSize: width,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        " ${model.time}",
                                        style: TextStyle(
                                            fontSize: width,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Row(
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
                              const Spacer(),
                              Text(
                                "${model.personsCount}",
                                style: TextStyle(
                                    fontSize: width,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                "فرد",
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
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "حصة الشهر :    ${model.defaultBalance}",
                                style: TextStyle(
                                    fontSize: width,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                "رصيد سابق : ${model.oldBalance}",
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
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "المجموع     ${model.totalBalance}      نقطة",
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
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "مستهلك قبل العملية  ${model.usedBefore}   نقطة",
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
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "الصنف",
                                    style: TextStyle(
                                        fontSize: width,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "الكميه",
                                    style: TextStyle(
                                        fontSize: width,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "الاجمالي",
                                    style: TextStyle(
                                        fontSize: width,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: model.details!.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return orderItem(
                                  " ${model.details![index].name}",
                                  "${model.details![index].quantity}",
                                  "${model.details![index].totalPoints}",
                                  width);
                            }),
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1)),
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
                                "${model.currentUse}",
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
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "مستهلك بعد العملية  ${model.usedAfter}   نقطة",
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
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "باقي من السابق : ${model.restOld}",
                                style: TextStyle(
                                    fontSize: width,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                "باقي من الحالي : ${model.rest}",
                                style: TextStyle(
                                    fontSize: width,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        model.money == 0.0
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                              )
                            : Container(
                                color: Colors.black,
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      "المبلغ المدفوع",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${model.money == 0.0 ? "" : "${model.money} ج م   "}",
                                      style: TextStyle(
                                          fontSize: width,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
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
            )),
      );
    }
  }

  Widget tableOfItems(List<CategoryModel> list, id, ItemsCubit itemsCubit) {
    if (list.isEmpty) {
      return Container();
    } else {
      return Column(
        children: [
          SizedBox(
              height: 58 + fixHeight,
              width: MediaQuery.of(context).size.width,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SfDataGrid(
                    onCellTap: (details) async {
                      if (details.rowColumnIndex.columnIndex == 1) {
                        int newQuantity =
                            catList[details.rowColumnIndex.rowIndex - 1]
                                    .quantity ??
                                1;
                        newQuantity++;
                        catList[details.rowColumnIndex.rowIndex - 1].quantity =
                            newQuantity;
                        catList[details.rowColumnIndex.rowIndex - 1].total =
                            (catList[details.rowColumnIndex.rowIndex - 1]
                                        .priceByPoint! *
                                    newQuantity.toInt())
                                .toInt();
                        totalPrice = totalPrice +
                            catList[details.rowColumnIndex.rowIndex - 1]
                                .priceByPoint!
                                .toInt();
                        setState(() {});

                        _orderInfoDataSource = OrderInfoDataSource(
                          catList.length,
                          catList,
                        );
                      } else if (details.rowColumnIndex.columnIndex == 3) {
                        if ((catList[details.rowColumnIndex.rowIndex - 1]
                                    .quantity ??
                                1) <=
                            1) {
                          Fluttertoast.showToast(
                              msg: "لا يمكن تقليل اكثر من هذا",
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.amber,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          int newQuantity =
                              catList[details.rowColumnIndex.rowIndex - 1]
                                      .quantity ??
                                  1;
                          newQuantity--;
                          catList[details.rowColumnIndex.rowIndex - 1]
                              .quantity = newQuantity;
                          catList[details.rowColumnIndex.rowIndex - 1].total =
                              (catList[details.rowColumnIndex.rowIndex - 1]
                                          .priceByPoint! *
                                      newQuantity)
                                  .toInt();

                          totalPrice = totalPrice -
                              catList[details.rowColumnIndex.rowIndex - 1]
                                  .priceByPoint!
                                  .toInt();
                          setState(() {});

                          _orderInfoDataSource = OrderInfoDataSource(
                            catList.length,
                            catList,
                          );
                        }
                      } else if (details.rowColumnIndex.columnIndex == 6) {
                        setState(() {
                          totalPrice = totalPrice -
                              ((catList[details.rowColumnIndex.rowIndex - 1]
                                          .quantity ??
                                      1) *
                                  (catList[details.rowColumnIndex.rowIndex - 1]
                                      .priceByPoint!
                                      .toInt()));
                        });
                        catList[details.rowColumnIndex.rowIndex - 1].quantity =
                            1;
                        catList[details.rowColumnIndex.rowIndex - 1].total =
                            (catList[details.rowColumnIndex.rowIndex - 1]
                                    .priceByPoint)!
                                .toInt();

                        _orderInfoDataSource.list
                            .removeAt(details.rowColumnIndex.rowIndex - 1);
                        _orderInfoDataSource = OrderInfoDataSource(
                          catList.length,
                          catList,
                        );

                        await Future.delayed(const Duration(milliseconds: 50),
                            () {
                          setState(() {
                            fixHeight = fixHeight - 50;
                          });
                        });
                      }
                    },
                    verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                    source: _orderInfoDataSource,
                    columnWidthMode: ColumnWidthMode.fitByCellValue,
                    columns: <GridColumn>[
                      GridColumn(
                          columnWidthMode: ColumnWidthMode.auto,
                          columnName: 'ItemName',
                          label: Container(
                              color: Colors.blueGrey,
                              padding: const EdgeInsets.all(6.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'اسم الصنف',
                                overflow: TextOverflow.fade,
                              ))),
                      GridColumn(
                          columnName: 'Plus',
                          label: Container(
                              color: Colors.blueGrey,
                              alignment: Alignment.center,
                              child: const Text(
                                '',
                                overflow: TextOverflow.fade,
                              ))),
                      GridColumn(
                          columnName: 'Quantity',
                          label: Container(
                              color: Colors.blueGrey,
                              alignment: Alignment.center,
                              child: const Text(
                                'الكمية',
                                overflow: TextOverflow.fade,
                              ))),
                      GridColumn(
                          columnName: 'Minus',
                          label: Container(
                              color: Colors.blueGrey,
                              alignment: Alignment.center,
                              child: const Text(
                                '',
                                overflow: TextOverflow.fade,
                              ))),
                      GridColumn(
                          columnWidthMode: ColumnWidthMode.fill,
                          columnName: 'PriceByPoint',
                          label: Container(
                              color: Colors.blueGrey,
                              alignment: Alignment.center,
                              child: const Text(
                                'السعر بالنقط',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ))),
                      GridColumn(
                          columnWidthMode: ColumnWidthMode.fill,
                          columnName: 'TotalPrice',
                          label: Container(
                              color: Colors.blueGrey,
                              alignment: Alignment.center,
                              child: const Text(
                                'السعر الكلى',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ))),
                      GridColumn(
                          columnName: 'Delete',
                          label: Container(
                              color: Colors.blueGrey,
                              alignment: Alignment.center,
                              child: const Text(
                                '',
                              ))),
                    ]),
              )),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Image.asset("assets/images/printer.png"),
                  label: const Text('      حفظ وطباعه '),
                  onPressed: () async {
                    if (_groupValue == 0) {
                      if (ipPrinter.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "برجاء ادخال عنوان الطابعه",
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.amber,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        for (int i = 0; i < catList.length; i++) {
                          postList.add(Detail(
                              itemId: catList[i].id,
                              quantity: catList[i].quantity ?? 1,
                              totalPrice: (catList[i].quantity ?? 1) *
                                  (catList[i].priceByPoint!.toInt()),
                              unitPrice: catList[i].priceByPoint!.toInt()));
                        }
                        PostItemsBillsModel _model = PostItemsBillsModel(
                            clientId: id, total: totalPrice, details: postList);
                        print(_model.details!.length);
                        print(_model.details);
                        print(_model);
                        itemsCubit.postItemBill(_model);
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
                        String? isConnected =
                            await BluetoothThermalPrinter.connectionStatus;
                        if (isConnected == "true") {
                          for (int i = 0; i < catList.length; i++) {
                            postList.add(Detail(
                                itemId: catList[i].id,
                                quantity: catList[i].quantity ?? 1,
                                totalPrice: (catList[i].quantity ?? 1) *
                                    (catList[i].priceByPoint!.toInt()),
                                unitPrice: catList[i].priceByPoint!.toInt()));
                          }
                          PostItemsBillsModel _model = PostItemsBillsModel(
                              clientId: id,
                              total: totalPrice,
                              details: postList);
                          print(_model.details!.length);
                          print(_model.details);
                          print(_model);
                          itemsCubit.postItemBill(_model);
                        } else {
                          showAlertDialog(context);
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Image.asset(
                    "assets/images/save-only.png",
                    height: 30,
                    width: 30,
                  ),
                  label: const Text('     حفظ '),
                  onPressed: () async {
                    save = "save only";
                    for (int i = 0; i < catList.length; i++) {
                      postList.add(Detail(
                          itemId: catList[i].id,
                          quantity: catList[i].quantity ?? 1,
                          totalPrice: (catList[i].quantity ?? 1) *
                              (catList[i].priceByPoint!.toInt()),
                          unitPrice: catList[i].priceByPoint!.toInt()));
                    }
                    PostItemsBillsModel _model = PostItemsBillsModel(
                        clientId: id, total: totalPrice, details: postList);
                    print(_model.details!.length);
                    print(_model.details);
                    print(_model);
                    itemsCubit.postItemBill(_model);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

class OrderInfoDataSource extends DataGridSource {
  int i = 0;
  List<CategoryModel> list = [];
  List<DataGridRow> dataGridRows = [];

  OrderInfoDataSource(this.i, this.list) {
    paginatedDataSource = list.getRange(0, i).toList();
    buildPaginatedDataGridRows();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

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

    return DataGridRowAdapter(color: getBackgroundColor(), cells: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(row.getCells()[0].value.toString()),
      ),
      const Center(
          child: Icon(
        Icons.add_circle,
        color: Colors.green,
      )),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[1].value.toString()),
      ),
      const Center(
          child: Icon(
        Icons.remove_circle,
        color: Colors.amber,
      )),
      Container(
        alignment: Alignment.center,
        child: Text(row.getCells()[2].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(row.getCells()[3].value.toString()),
      ),
      Container(
          alignment: Alignment.center,
          child: const Center(
              child: Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ]);
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedDataSource.map<DataGridRow>((dataGridRow) {
      notifyListeners();
      return DataGridRow(cells: [
        DataGridCell(columnName: 'ItemName', value: dataGridRow.name),
        DataGridCell(
            columnName: 'Quantity', value: dataGridRow.quantity ?? 1.toInt()),
        DataGridCell(
            columnName: 'PriceByPoint',
            value: dataGridRow.priceByPoint!.toInt()),
        DataGridCell(
            columnName: 'TotalPrice',
            value:
                dataGridRow.total ?? dataGridRow.priceByPoint!.toInt().toInt()),
      ]);
    }).toList(growable: false);
  }
}
