import 'dart:typed_data';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:test_project/Models/pdf_money_bills.dart';
import 'package:test_project/UI/sales/sales/sales.dart';
import 'package:test_project/cubit/Items/items_cubit.dart';
import '../../Printer/ImagestorByte.dart';
import '../../Printer/printer.dart';

class MoneyPrinterModel extends StatefulWidget {
  MoneyPrinterModel({Key? key,  required this.model})
      : super(key: key);
  final PdfMoneyModel model;


  @override
  State<MoneyPrinterModel> createState() => _MoneyPrinterModelState();
}

class _MoneyPrinterModelState extends State<MoneyPrinterModel> {


  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String ipPrinter='';

  getIPPrinter() async{
    final SharedPreferences prefs = await _prefs;
    setState(() {
      ipPrinter= prefs.getString('printerIp')!;
    });
  }

  @override
  void initState() {
    getIPPrinter();
    super.initState();
  }


  void testPrint(Uint8List theimageThatComesfr) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
    await printer.connect(ipPrinter, port: 9100);
    if (res == PosPrintResult.success) {
      await testReceiptWifi(printer, theimageThatComesfr);
      print(res.msg);
      await Future.delayed(const Duration(seconds: 3), () {
        printer.disconnect();
      });
    }
  }
  ItemsCubit c =ItemsCubit();
  ScreenshotController screenshotController = ScreenshotController();

  double? width;

  double? widthPhoto;

  double? containerWidth;

  @override
  Widget build(BuildContext context) {
    print("?????? ?????????????????????????????? ???? ??????");
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    if (aspectRatio <= 0.45) {
      width = 7;
      widthPhoto = 60;
      containerWidth = 170;
    } else if (aspectRatio > 0.45 && aspectRatio < 0.47) {
      width = 9;
      containerWidth = 250;
      widthPhoto = 75;
    } else if (aspectRatio < 0.47 && aspectRatio < 0.49) {
      width = 12;
      containerWidth = 350;
      widthPhoto = 80;
    } else {
      width = 13;
      containerWidth = 380;
      widthPhoto = 90;
    }

    Future.delayed(const Duration(milliseconds: 250), () {
      screenshotController
          .capture(delay: const Duration(milliseconds: 10))
          .then((capturedImage) async {
        theimageThatComesfromThePrinter = capturedImage!;
        setState(() {
          theimageThatComesfromThePrinter = capturedImage;
          testPrint(theimageThatComesfromThePrinter);
        });
      }).catchError((onError) {
        print(onError);
      });


      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pop(MaterialPageRoute(
            builder: (context) =>
                SalesScreen()));
      });

    });

    return Opacity(
      opacity: 0.5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("???????????? ?????????? ?????? ?????????????? "),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    //color: Colors.grey,
                    child: Screenshot(
                      controller: screenshotController,
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                              Container(
                                color: Colors.white,
                                width: containerWidth,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Spacer(),
                                          Text(
                                            "???????? ???????? ????????",
                                            style: TextStyle(
                                                fontSize: width,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "?????????? ?????????????? ???????? ????????????",
                                            style: TextStyle(
                                                fontSize: width,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                        ],
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
                                            Column(
                                              children: [

                                                Row(
                                                  children: [
                                                    Text(
                                                      " ?????????? : ${intl.DateFormat.yMMMd().format(widget.model.date!)}",
                                                      style: TextStyle(
                                                          fontSize: width,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      " ${widget.model.time}",
                                                      style: TextStyle(
                                                          fontSize: width,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold),
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
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "${widget.model.clientName}",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${widget.model.personsCount}",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "??????",
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
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "?????? ?????????? ???????????? :    ${widget.model.defaultBalance}",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "???????????? ???????????? ???? ?????????? ???????????? : ${widget.model.oldBalance}",
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
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "???????????? ????????????     ${widget.model.totalBalance}      ????????",
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
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "???????????? ??????????????????  ${widget.model.pointExchanged}   ????????",
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
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "???????? ???? ???????????? : ${widget.model.oldRest}",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "???????? ???? ???????????? : ${widget.model.newRest}",
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
                                              "???????????? ??????????????",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${widget.model.money} ?? ??",
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
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
