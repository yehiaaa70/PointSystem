import 'package:flutter/material.dart';

class MyWidget {
  Widget myText(String data1, double size1, String data2, double size2,{color}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            data2,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: size2,color: color),
          ),
        ),
        Expanded(
          child: Text(
            data1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: size1),
          ),
        ),
      ],
    );
  }

  Widget myCostomText(String data1, String data2, double size, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white),),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                data2,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                data1,
                maxLines: 1,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: size),
              ),
            ),
          ],
        ),
      ),
    );
  }

 static Widget openDialog(){
    return  SingleChildScrollView(
      child: Column(
          children: [
            const SizedBox(height: 8,),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                autofocus: true,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(),
                  hintText: '?????? ????????????',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: '?????? ????????????',
                  labelStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                autofocus: true,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(),
                  hintText: '?????? ??????????????',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: '?????? ??????????????',
                  labelStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                autofocus: true,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(),
                  hintText: '?????? ??????????',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: '?????? ??????????',
                  labelStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                autofocus: true,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(),
                  hintText: '???????????? ?????????? ????',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: '???????????? ?????????? ????',
                  labelStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                autofocus: true,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(),
                  hintText: '?????????????? ??????????????',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: '?????????????? ??????????????',
                  labelStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                autofocus: true,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(),
                  hintText: '?????????? ??????????????',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: '?????????? ??????????????',
                  labelStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ],
        ),
    );
  }
}
