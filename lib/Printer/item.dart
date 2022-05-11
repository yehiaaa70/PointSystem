import 'package:flutter/material.dart';

Widget orderItem(name, quantity, total, fontSize) {
  return Container(
    decoration:
    BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
    child: Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: TextStyle(fontSize: fontSize,color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              quantity,
              style: TextStyle(fontSize: fontSize,color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                total,
                style: TextStyle(fontSize: fontSize,color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
