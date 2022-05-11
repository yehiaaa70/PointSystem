import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Models/client_model.dart';
import 'package:test_project/Models/pdf_money_bills.dart';
import 'package:test_project/Models/post_bread.dart';
import 'package:test_project/Models/post_money_model.dart';
import 'package:image/image.dart' as im;
import 'package:esc_pos_printer/esc_pos_printer.dart' as wifi;

import '../../Models/pdfItems.dart';
import '../../Models/post_flowers_model.dart';
import '../../Models/post_items_model.dart';
import '../../Printer/printer.dart';
import '../../Services/Api/get_http_services.dart';
import '../../Services/Api/post_http_services.dart';

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientCubit() : super(ClientInitial());

  static ClientCubit get(context) => BlocProvider.of(context);

  String? pdfUrl;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String ipPrinter = "";
  String bluetoothMac = "";
  int _groupValue = 0;
  SharedPreferences? prefs;

  ClientModel clientModel = ClientModel();
  PdfItemsModel pdfBreadModel = PdfItemsModel();
  PdfItemsModel pdfPreciseModel = PdfItemsModel();
  PdfMoneyModel pdfMoneyModel = PdfMoneyModel();
  PdfItemsModel pdfItemsModel = PdfItemsModel();

  void getClientByBarcode(String page) {
    emit(ClientLoading());
    GetHttpServices.getClientByBarcode(page).then((value) {
      clientModel = value;
      print("clientModel.name");
      print(clientModel.name);
      emit(ClientSuccess());
    }).catchError((onError) {
      print("onError");
      print(onError);
      emit(ClientField());
    });
  }

  dynamic error;

  void postBreadBills(PostBread postBread) {
    emit(PrintingLoading());
    PostHttpServices.postBreadBill(postBread).then((value) {
      pdfBreadModel = value;
      print(pdfBreadModel);
      emit(PrintingSuccess());
    }).catchError((onError) {
      error = onError;
      print(onError);
      emit(PrintingsField());
      Future.delayed(Duration(seconds: 1), () {
        emit(PrintingFinish());
      });
    });
  }

  void postPreciseBill(PostPreciseModel preciseModel) {
    emit(PrintingLoading());
    PostHttpServices.postPreciseBill(preciseModel).then((value) {
      pdfPreciseModel = value;
      print("pdfUrl postPreciseBill");
      print(pdfPreciseModel);
      emit(PrintingSuccess());
    }).catchError((onError) {
      print(onError);
      emit(PrintingsField());
    });
  }

  void postMoneyBill(PostMoneyModel moneyModel) {
    emit(PrintingLoading());
    PostHttpServices.postMoneyBill(moneyModel).then((value) {
      pdfMoneyModel = value;
      print("الريسبونس تمم ");
      print(pdfMoneyModel);
      emit(PrintingSuccess());
    }).catchError((onError) {
      print(onError);
      emit(PrintingsField());
    });
  }

  void postItemBill(PostItemsBillsModel itemsBillsModel) {
    emit(PrintingLoading());
    PostHttpServices.postItemBill(itemsBillsModel).then((value) {
      pdfItemsModel = value;
      emit(PrintingSuccess());
    }).catchError((onError) {
      print(onError);
      emit(PrintingsField());
    });
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
    emit(PrintingFinish());
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(_imageFile);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      emit(KillFinish());
      print("Print $result");
    } else {
      emit(KillFinishError());
      print("Print Error");
    }
  }

  getIPPrinterWifi() async {
    prefs = await _prefs;
    ipPrinter = prefs!.getString('printerIp')!;
    bluetoothMac = prefs!.getString('printerMac')!;
    _groupValue = prefs!.getInt('chooseType') ?? 0;
    emit(getIps());
  }

  void testPrint(Uint8List theimageThatComesfr, String ipPrinter) async {
    emit(PrintingFinish());
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    print("ipPrinter");
    print(ipPrinter);
    final wifi.PosPrintResult res =
        await printer.connect(ipPrinter, port: 9100);
    if (res == wifi.PosPrintResult.success) {
      await testReceiptWifi(printer, theimageThatComesfr);
      emit(KillFinish());
      print(res.msg);
      await Future.delayed(const Duration(seconds: 1), () {
        printer.disconnect();
      });
    } else {
      print("res.msg");
      print(res.msg);
    }
  }
  SaveOnly(){
    emit(KillFinish());
  }
}
