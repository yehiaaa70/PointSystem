import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Models/month_balance.dart';
import 'package:image/image.dart' as im;
import 'package:esc_pos_printer/esc_pos_printer.dart' as wifi;

import '../../Models/pdf_month_balance_model.dart';
import '../../Printer/printer.dart';
import '../../Services/Api/get_http_services.dart';
import '../../Services/Api/post_http_services.dart';

part 'monthly_state.dart';

class MonthlyCubit extends Cubit<MonthlyState> {
  MonthlyCubit() : super(MonthlyInitial());

  static MonthlyCubit get(context) => BlocProvider.of(context);

  MonthBalance? monthBalance;
  PdfMonthBalanceModel pdfMonthBalanceModel =PdfMonthBalanceModel();
  dynamic error='';
  List<MonthDatum> myData = [];
  int pageCount = 0;
  int numberOfPage = 1;
  int isSelected = 0;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String ipPrinter = "";
  String bluetoothMac = "";
  SharedPreferences? prefs;

  void getMonthBalance() {
    emit(MonthlyLoading());
    GetHttpServices.getMonthBalance("$numberOfPage").then((value) {
      monthBalance = value;
      pageCount = value.pagesCount!;
      myData = value.data!;
      emit(MonthlySuccess());
      getIPPrinterWifi();
    }).catchError((onError) {
      emit(MonthlyField());

    });
  }

  void PostMonthBalancePrint(String id){
    emit(PrintingMonthlyLoading());
    PostHttpServices.postMonthBalancePrint(id).then((value){
      pdfMonthBalanceModel = value;
      emit(PrintingMonthlySuccess());
    }).catchError((onError){
      error=onError;
      print(error);
      emit(PrintingMonthlyField());
    });
  }

  void changePage(int position) {
    numberOfPage = position;
    getMonthBalance();
  }

  void incrementPage() {
    numberOfPage++;
    getMonthBalance();
  }

  void decrementPage() {
    numberOfPage--;
    if (numberOfPage < 1) {
      numberOfPage = 1;
      getMonthBalance();
    } else {
      getMonthBalance();
    }
  }



  Future<List<int>> getTicket(Uint8List _imageFile) async {
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    final im.Image? image = im.decodeImage(_imageFile);
    bytes += generator.image(image!, align: PosAlign.left);
    bytes += generator.feed(5);
    return bytes;
  }

  Future<void> printTicket(Uint8List _imageFile) async {
    print("ميثود الطباعه");
    emit(PrintingFinishMonthly());
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(_imageFile);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      emit(KillFinishMonthly());
      print("Print $result");
    } else {
      emit(KillFinishErrorMonthly());
      print("Print Error");
    }
  }

  getIPPrinterWifi() async {
    prefs = await _prefs;
    ipPrinter = prefs!.getString('printerIp')!;
    bluetoothMac = prefs!.getString('printerMac')!;
    emit(getIpsMonthly());
  }

  void testPrint(Uint8List theimageThatComesfr, String ipPrinter) async {
    emit(PrintingFinishMonthly());
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    print("ipPrinter");
    print(ipPrinter);
    final wifi.PosPrintResult res =
    await printer.connect(ipPrinter, port: 9100);
    if (res == wifi.PosPrintResult.success) {
      await testReceiptWifi(printer, theimageThatComesfr);
      emit(KillFinishMonthly());
      print(res.msg);
      await Future.delayed(const Duration(seconds: 1), () {
        printer.disconnect();
      });
    } else {
      print("res.msg");
      print(res.msg);
    }
  }


}
