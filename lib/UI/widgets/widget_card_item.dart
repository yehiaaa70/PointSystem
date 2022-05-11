import 'package:flutter/material.dart';

Widget cardItem({
  required String name,
  required String icon,
  pressFunction,
}) {
  return GestureDetector(
    onTap: pressFunction,
    child: Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Column(
          children: [
            Image.asset(
              icon,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    ),
  );
}
