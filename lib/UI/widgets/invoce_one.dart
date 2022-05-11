import 'dart:typed_data';

// import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Models/pdf_month_balance_model.dart';
import '../../Printer/ImagestorByte.dart';
import '../../Printer/printer.dart';
import 'invoice_one_item.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrinterMonthModel extends StatefulWidget {
  PrinterMonthModel({Key? key, required this.model}) : super(key: key);
  final PdfMonthBalanceModel model;

  @override
  State<PrinterMonthModel> createState() => _PrinterMonthModelState();
}

class _PrinterMonthModelState extends State<PrinterMonthModel> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String ipPrinter = '';

  getIPPrinter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      ipPrinter = prefs.getString('printerIp') == ''
          ? "192.168.1.107"
          : prefs.getString('printerIp')!;
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

    final PosPrintResult res = await printer.connect(ipPrinter, port: 9100);
    if (res == PosPrintResult.success) {
      await testReceiptWifi(printer, theimageThatComesfr);
      print(res.msg);
      await Future.delayed(const Duration(seconds: 3), () {
        printer.disconnect();
      });
    }
  }

  ScreenshotController screenshotController = ScreenshotController();

  double? width;

  double? widthPhoto;

  double? containerWidth;

  @override
  Widget build(BuildContext context) {
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

    Future.delayed(const Duration(milliseconds: 700), () {
      screenshotController
          .capture(delay: const Duration(milliseconds: 10))
          .then((capturedImage) async {
        theimageThatComesfromThePrinter = capturedImage!;
        setState(() {
          theimageThatComesfromThePrinter = capturedImage;
          testPrint(theimageThatComesfromThePrinter);
        });
      }).catchError((onError) {
        print("onError");
        print(onError);
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });

    });

    return Opacity(
      opacity: 0.05,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("معاينة الوصل قبل الطباعة "),
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
                                      Center(
                                        child: Text(
                                          "تقرير حصة شهر لعميل",
                                          style: TextStyle(
                                              fontSize: width! + 2,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
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
                                              "${widget.model.month}",
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
                                              "${widget.model.year}",
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
                                        child: Column(
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
                                            Text(
                                              "${widget.model.idNumber}",
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
                                          " عدد الافراد  ${widget.model.personsCount}",
                                          style: TextStyle(
                                              fontSize: width,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
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
                                              "${widget.model.defaultBalance}",
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
                                              "${widget.model.oldBalance}",
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
                                              "${widget.model.totalBalance}      نقطة",
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
                                          itemCount:
                                              widget.model.details!.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return invoiceOneItem(
                                                widget.model.details![index]
                                                    .insertedDate!,
                                                widget.model.details![index]
                                                    .name!,
                                                widget.model.details![index]
                                                    .quantity!,
                                                widget.model.details![index]
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
                                              "${widget.model.totalUse}",
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
                                              "${widget.model.rest}",
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
