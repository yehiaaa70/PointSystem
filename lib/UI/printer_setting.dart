import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:basic_utils/basic_utils.dart';

class PrinterSetting extends StatefulWidget {
  const PrinterSetting({Key? key}) : super(key: key);

  @override
  State<PrinterSetting> createState() => _PrinterSettingState();
}

class _PrinterSettingState extends State<PrinterSetting> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var wifiController = TextEditingController();
  var bluetoothController = TextEditingController();
  SharedPreferences? prefs;

  String wifiIp = "";
  String bluetoothMac = "";
  int _groupValue = 0;

  getIPPrinter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      wifiIp = prefs.getString('printerIp') ?? "لا يوجد طابعه";
      bluetoothMac = prefs.getString('printerMac') ?? "لا يوجد طابعه";
      _groupValue = prefs.getInt('chooseType') ?? 0;
    });
  }

  putIPPrinterWifi() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('printerIp', wifiController.text);
    setState(() {
      getIPPrinter();
    });
    wifiController.clear();
  }

  putIPPrinterBluetooth() async {
    final SharedPreferences prefs = await _prefs;

    String s = StringUtils.addCharAtPosition(bluetoothController.text, ":", 2,
        repeat: true);
    print(s.toUpperCase());
    prefs.setString('printerMac', s.toUpperCase());
    setState(() {
      getIPPrinter();
    });
    bluetoothController.clear();
  }

  chooseType() async {
    prefs = await _prefs;
    prefs!.setInt('chooseType', _groupValue);
    refresh();
  }

  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    getIPPrinter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "أعدادات الطابعة",
            style: TextStyle(fontSize: 18),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Container(
            child: Column(
              children: [
                _myRadioButton(
                    title: "واي فاي",
                    value: 0,
                    onChanged: (newValue) {
                      _groupValue = newValue;
                      chooseType();
                      refresh();
                    }),
                _myRadioButton(
                    title: "بـلـوتـوث",
                    value: 1,
                    onChanged: (newValue) {
                      _groupValue = newValue;
                      chooseType();
                    }),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 25,
                ),
                _groupValue == 0 ? containerOfWiFi() : ContainerOfBluetooth(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myRadioButton({title, value, onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget ContainerOfBluetooth() {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "العنوان الخاص بالطابعة : ",
                  style: TextStyle(fontSize: 19.0),
                ),
                Expanded(
                    child: Center(
                        child: Text(
                  bluetoothMac,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ))),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: bluetoothController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.print),
                labelText: "عنوان الطابعة",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  'حفظ ',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  if (bluetoothController.text.isNotEmpty) {
                    putIPPrinterBluetooth();
                  } else {
                    Fluttertoast.showToast(
                        msg: "برجاء ادخال عنوان الطابعة !!!",
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.amber,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget containerOfWiFi() {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "العنوان الخاص بالطابعة : ",
                  style: TextStyle(fontSize: 19.0),
                ),
                Expanded(
                    child: Center(
                        child: Text(
                  wifiIp,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ))),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: wifiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.print),
                labelText: "عنوان الطابعة",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  'حفظ ',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  if (wifiController.text.isNotEmpty) {
                    putIPPrinterWifi();
                  } else {
                    Fluttertoast.showToast(
                        msg: "برجاء ادخال عنوان الطابعة !!!",
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.amber,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
