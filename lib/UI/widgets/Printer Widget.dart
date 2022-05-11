import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;

import '../../Models/pdfItems.dart';
import '../../Printer/item.dart';

Widget Amir( PdfItemsModel? model,double aspectRatio){
  ScreenshotController screenshotController = ScreenshotController();
  double width=7;
  double containerWidth=170;
  //
  // if (aspectRatio <= 0.45) {
  //   width = 7;
  //   containerWidth = 170;
  // } else if (aspectRatio > 0.45 && aspectRatio < 0.47) {
  //   width = 9;
  //   containerWidth = 250;
  // } else if (aspectRatio < 0.47 && aspectRatio < 0.49) {
  //   width = 12;
  //   containerWidth = 350;
  // } else {
  //   width = 13;
  //   containerWidth = 380;
  // }
  return Opacity(
    opacity: 1,
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
              IconButton(onPressed: (){

              }, icon: Icon(Icons.print)),
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
                        textDirection: ui.TextDirection.ltr,
                        child: Row(
                          children: [
                            Container(
                              color: Colors.white,
                              width: containerWidth,
                              child: Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Text(
                                          "مخبز حسام سعيد",
                                          style: TextStyle(
                                              fontSize: width,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "عملية بيع ناجحة",
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
                                                    "رقم: ${model!.no}",
                                                    style: TextStyle(
                                                        fontSize: width,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Text(
                                                    "${model.machineName}",
                                                    style: TextStyle(
                                                        fontSize: width,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    " تاريخ : ${DateFormat.yMMMd().format(model.date!)}",
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
                                                    " ${model.time}",
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
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
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
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
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
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
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
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          Text(
                                            "الصنف",
                                            style: TextStyle(
                                                fontSize: width,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "الكميه",
                                            style: TextStyle(
                                                fontSize: width,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "الاجمالي",
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
                                        model.details!.length,
                                        physics:
                                        const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return orderItem(
                                              " ${model.details![index].name}",
                                              "${model.details![index].quantity}",
                                              "${model.details![index].totalPoints}",
                                              width);
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
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
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
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
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
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          Text(
                                            "المبلغ المدفوع",
                                            style: TextStyle(
                                                fontSize: width,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${model.money} ج م",
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