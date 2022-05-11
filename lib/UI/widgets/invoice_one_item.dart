import 'package:flutter/material.dart';

Widget invoiceOneItem( DateTime time,String name,double quantity,int total,double fontSize) {
  return Container(
    width: 400,
    decoration:
    BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
    child: Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Expanded(
                child: Center(
                    child: Text(
                      "$time",
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold,color: Colors.black),
                    ))),
            Expanded(
                child: Center(
                    child: Text(
                      name,
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold,color: Colors.black),
                    ))),
            Expanded(
                child: Center(
                    child: Text(
                      "$quantity",
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold,color: Colors.black),
                    ))),
            Expanded(
                child: Center(
                    child: Text(
                      "$total",
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold,color: Colors.black),
                    ))),
          ],
        ),
      ),
    ),
  );
}
