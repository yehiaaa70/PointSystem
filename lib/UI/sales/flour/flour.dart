import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Models/post_flowers_model.dart';
import 'package:intl/intl.dart' as intl;

import '../../../Models/client_model.dart';
import '../../../Models/pdfItems.dart';
import '../../../Printer/item.dart';
import '../../../cubit/Client/client_cubit.dart';

class FlourScreen extends StatefulWidget {
  const FlourScreen({Key? key, required this.data}) : super(key: key);

  final ClientModel data;

  @override
  State<FlourScreen> createState() => _FlourScreenState();
}

class _FlourScreenState extends State<FlourScreen> {
  final myController = TextEditingController();

  String pointNum = "0";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String ipPrinter = "";
  String bluetoothMac = "";
  int _groupValue = 0;
  SharedPreferences? prefs;
  ScreenshotController screenshotController = ScreenshotController();
  BuildContext? dialogContext;
  bool dialog =false;
  String save ="";
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
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "صــرف دقيق بـالـنـقـاطـ",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
      body: BlocProvider(
          create: (context) => ClientCubit()..getIPPrinterWifi(),
          child: BlocConsumer<ClientCubit, ClientState>(
            listener: (context, state) {},
            builder: (context, state) {
              ClientCubit clientCubit = ClientCubit.get(context);

              if (state is PrintingLoading) {
                return showLoadingIndicator();
              } else if (state is PrintingSuccess) {
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
                      clientCubit.testPrint(image!, ipPrinter);
                      Navigator.of(context).pop();
                    }).catchError((onError) {
                      print(onError);
                    });
                  } else if (_groupValue == 1) {
                    screenshotController.capture().then((Uint8List? image) async {
                      clientCubit.printTicket(image!);
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
                  clientCubit.SaveOnly();
                  Navigator.of(context).pop();
                }
                clearData();
              } else if (state is PrintingsField) {
                Fluttertoast.showToast(
                    msg: clientCubit.error.toString().substring(10),
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (state is getIps) {
                bluetoothMac = clientCubit.bluetoothMac;
                setConnect();
              }

              return ConditionalBuilder(
                condition: state is! ClientLoading,
                builder: (context) => screen(clientCubit, state),
                fallback: (context) => showLoadingIndicator(),
              );
            },
          )),
    );
  }

  Widget screen(ClientCubit clientCubit, state) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.white),
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
                                    : Colors.white),
                          )),
                        ),
                      ]),
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
                                    : Colors.white),
                          )),
                        ),
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('الباركود'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(child: Text(widget.data.barcode!)),
                        ),
                      ]),
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
                                    : Colors.white),
                          )),
                        ),
                      ]),
                      TableRow(children: [
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
                                : "${widget.data.personQuantity}",
                            style: TextStyle(
                                color: widget.data.personQuantity == null
                                    ? Colors.red
                                    : Colors.white),
                          )),
                        ),
                      ]),
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
                                    : Colors.white),
                          )),
                        ),
                      ]),
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
                                color: widget.data.pointFromLastMonth == null
                                    ? Colors.red
                                    : Colors.white),
                          )),
                        ),
                      ]),
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
                                  : Colors.white),
                        )),
                      ]),
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
                                  : Colors.white),
                        )),
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('الرصيد السابق المتبقى'),
                        ),
                        Center(
                            child: Text(
                          "${widget.data.openedRest}" == 'null'
                              ? "لا يوجد"
                              : "${widget.data.openedRest}",
                          style: TextStyle(
                              color: widget.data.openedRest == null
                                  ? Colors.red
                                  : Colors.white),
                        )),
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('عدد النقاط'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Text(pointNum == "" ? "0" : pointNum)),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  autofocus: true,
                  onChanged: (_) {
                    setState(() {
                      pointNum = myController.text;
                    });
                  },
                  textAlign: TextAlign.center,
                  controller: myController,
                  textDirection: TextDirection.rtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintTextDirection: TextDirection.rtl,
                    border: OutlineInputBorder(),
                    hintText: 'عدد الارغفه المستهلكه',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'عدد الارغفه المستهلكه',
                    labelStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Image.asset("assets/images/printer.png"),
                      label: const Text('      حفظ وطباعه '),
                      onPressed: () async {
                        save="save & print";

                        if (_groupValue == 0) {
                          if (ipPrinter.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "برجاء اختيار الطابعه اولا ",
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.amber,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            chickData(clientCubit, widget.data.id, state);
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
                              chickData(clientCubit, widget.data.id, state);
                            }else{
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
                  SizedBox(width: 25,),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Image.asset("assets/images/save-only.png",height: 30,width: 30,),
                      label: const Text('     حفظ '),
                      onPressed: () async {
                        save="save only";
                        chickData(clientCubit, widget.data.id, state);
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
              PrintModel(clientCubit.pdfPreciseModel)
            ],
          ),
        ),
      );

  Widget showLoadingIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );

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
                        model.money==0.0? Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black, width: 1)),
                        ):Container(
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
                                "${model.money==0.0?"": "${model.money} ج م   "}",
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

  chickData(ClientCubit clientCubit, id, state) {
    if (myController.text.isNotEmpty) {
      saveData(clientCubit, id, state);
    } else {
      Fluttertoast.showToast(
          msg: "برجاء اكمال باقى البيانات",
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.amber,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  clearData() {
    myController.clear();
  }

  saveData(ClientCubit clientCubit, id, state) async {
    clientCubit.postPreciseBill(
        PostPreciseModel(clientId: id, quantity: int.parse(myController.text)));
  }
}
