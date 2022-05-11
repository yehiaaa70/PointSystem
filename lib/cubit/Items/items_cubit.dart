import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Models/item_table_model.dart';
import 'package:test_project/Models/items_categories.dart';
import 'package:test_project/Models/new_items.dart';
import 'package:test_project/Models/one_item_model.dart';
import 'package:test_project/Models/post_items_model.dart';
import 'package:image/image.dart' as im;
import 'package:esc_pos_printer/esc_pos_printer.dart' as wifi;

import '../../Models/category_model.dart';
import '../../Models/client_model.dart';
import '../../Models/item_units.dart';
import '../../Models/pdfItems.dart';
import '../../Printer/printer.dart';
import '../../Services/Api/delete_http_services.dart';
import '../../Services/Api/get_http_services.dart';
import '../../Services/Api/post_http_services.dart';
import '../../Services/Api/update_http_services.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  static ItemsCubit get(context) => BlocProvider.of(context);

  ItemTableModel? itemTableModel;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String ipPrinter = "";
  String bluetoothMac = "";
  SharedPreferences? prefs;


  List<DataItem> myData = [];
  List<DataItem> myDataSearch = [];
  List<OneItem> oneItemList = [];
  OneItem oneItem = OneItem();
  int pageCount = 0;
  int numberOfPage = 1;
  int isSelected = 0;
  late List<String> unitString;
  late List<String> categoriesString;
  String added = '';
  dynamic error;
  List<ItemsUnits> unitsModel = [];
  List<ItemsCategories> categoriesModel = [];
  List<CategoryModel> categoryModel = [];
  ClientModel clientModel = ClientModel();
  PdfItemsModel pdfItemsModel = PdfItemsModel();

  changePageSearch(int position, search) {
    numberOfPage = position;
    getAllItemsSearch(search);
  }

  void changePage(int position) {
    numberOfPage = position;
    getAllItems();
  }

  void incrementPage() {
    numberOfPage++;
    getAllItems();
  }

  void decrementPage() {
    numberOfPage--;
    if (numberOfPage < 1) {
      numberOfPage = 1;
      getAllItems();
    } else {
      getAllItems();
    }
  }

  void getCategoryItems() {
    emit(ItemsLoading());
    GetHttpServices.getItems().then((value) {
      categoryModel = value;
      emit(ItemsSuccess());
      getIPPrinterWifi();
    }).catchError((onError) {
      emit(ItemsField());
    });
  }

  void getAllItems() {
    emit(ItemsLoading());
    GetHttpServices.getAllItems("$numberOfPage").then((value) {
      itemTableModel = value;
      pageCount = value.pagesCount!;
      myData = value.data!;
      emit(ItemsSuccess());
    }).catchError((onError) {
      emit(ItemsField());
    });
  }

  void getAllItemsSearch(String search) {
    emit(ItemsLoading());
    GetHttpServices.getAllItemsSearch("$numberOfPage", search).then((value) {
      itemTableModel = value;
      pageCount = value.pagesCount!;
      myDataSearch = value.data!;
      emit(ItemsSuccess());
    }).catchError((onError) {
      emit(ItemsField());
    });
  }

  void getOneItems(String id) {
    emit(GetOneItemsLoading());
    GetHttpServices.getOneItems(id).then((value) {
      oneItem = value;
      oneItemList.add(value);
      emit(GetOneItemsSuccess());
    }).catchError((onError) {
      emit(GetOneItemsField());
    });
  }

  void getItemsUnits() {
    emit(ItemsLoading());
    GetHttpServices.getItemsUnits().then((value) {
      unitsModel = value;
      emit(ItemsSuccess());
    }).catchError((onError) {
      emit(ItemsField());
    });
  }

  void getItemsCategories() {
    emit(ItemsLoading());
    GetHttpServices.getItemsCategories().then((value) {
      categoriesModel = value;
      emit(ItemsSuccess());
    }).catchError((onError) {
      emit(ItemsField());
    });
  }

  void postItem(NewItem newItem) {
    emit(PostItemsLoading());
    PostHttpServices.postItems(newItem).then((value) {
      if (value == "اسم الصنف متكرر") {
        added = value;
        emit(PostItemsFrequent());
      } else if (value == "الباركود متكرر") {
        added = value;
        emit(BarcodeItemsFrequent());
      } else {
        added = "";
        getAllItems();
        emit(PostItemsSuccess());
      }
    }).catchError((onError) {
      emit(PostItemsField());
    });
  }

  void deleteItem(String id) {
    emit(DeleteItemsLoading());
    DeleteHttpServices.deleteItem(id).then((value) {
      getAllItems();
      emit(DeleteItemsSuccess());
    }).catchError((onError) {
      emit(DeleteItemsField());
    });
  }

  void updateItem(String id, NewItem item) {
    emit(UpdateItemsLoading());
    UpdateHttpServices.updateItem(id, item).then((value) {
      print("باشا وربنا انا هنا");
      getAllItems();
      emit(UpdateItemsSuccess());
    }).catchError((onError) {
      emit(UpdateItemsField());
    });
  }


  void postItemBill(PostItemsBillsModel itemsBillsModel) {
    emit(PrintingLoadingItem());
    PostHttpServices.postItemBill(itemsBillsModel).then((value) {
      pdfItemsModel = value;
      emit(PrintingSuccessItem());
    }).catchError((onError) {
      error = onError;
      print(onError);
      emit(PrintingFieldItem());
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
    emit(PrintingFinishItem());
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(_imageFile);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      emit(KillFinishItem());
      print("Print $result");
    } else {
      emit(KillFinishErrorItem());
      print("Print Error");
    }
  }

  getIPPrinterWifi() async {
    prefs = await _prefs;
    ipPrinter = prefs!.getString('printerIp')!;
    bluetoothMac = prefs!.getString('printerMac')!;
    emit(getIpsItem());
  }

  void testPrint(Uint8List theimageThatComesfr, String ipPrinter) async {
    emit(PrintingFinishItem());
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    print("ipPrinter");
    print(ipPrinter);
    final wifi.PosPrintResult res =
    await printer.connect(ipPrinter, port: 9100);
    if (res == wifi.PosPrintResult.success) {
      await testReceiptWifi(printer, theimageThatComesfr);
      emit(KillFinishItem());
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
    emit(KillFinishItem());
  }
}
