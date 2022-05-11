import 'package:flutter/material.dart';

Widget listTile({required String image, required String text, onTabFunction}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: InkWell(
      onTap:onTabFunction ,
      child: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 40.0,
              width: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Text(
                text,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(child: Align(alignment: AlignmentDirectional.centerEnd,child:Icon(Icons.arrow_forward_ios),
            )),

          ],


        ),
      ),
    ),
  );
}
