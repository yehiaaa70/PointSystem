import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_project/Models/item_units.dart';
import 'package:test_project/Models/items_categories.dart';
import 'package:test_project/Models/new_items.dart';
import 'package:test_project/Models/one_item_model.dart';
import 'package:test_project/cubit/Items/items_cubit.dart';

import 'item_table.dart';

class PostItems extends StatelessWidget {
  PostItems({Key? key, this.choose, this.item}) : super(key: key);

  BuildContext? contextDialog;
  String? choose;
  OneItem? item;
  NewItem? updateItem;

  var nameItemControl = TextEditingController();
  var barcodeItemControl = TextEditingController();
  var pricePerPointControl = TextEditingController();
  var pricePerCoinControl = TextEditingController();
  var priceSellControl = TextEditingController();
  var openBalanceControl = TextEditingController();

  String? categoryId;
  String? unitId;
  List<ItemsUnits>? units;
  List<ItemsCategories>? categories;
  late ItemsCubit itemsCubit;

  @override
  Widget build(BuildContext context) {
   if(choose=="update"){
     getUpdateData(item!);
   }
    return  Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Center(
                      child: Text(
                        choose=="add"?"اضافه صنف":"تعديل الصنف",
                        style: (const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  body: BlocProvider(
                    create: (context)=> ItemsCubit()..getItemsUnits()..getItemsCategories(),
                    child: BlocConsumer<ItemsCubit,ItemsState>(
                      listener: (context,state) {  },
                      builder: (context,state) {
                        itemsCubit = ItemsCubit.get(context);


                        if(state is PostItemsLoading){
                          return showLoadingIndicator();
                        }else if(state is PostItemsSuccess){
                          Fluttertoast.showToast(
                              msg: "تم الحفظ بنجاح",
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Items()));
                          });
                        }else if(state is PostItemsFrequent){
                          Fluttertoast.showToast(
                              msg: "اسم الصنف متكرر",
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.amber,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }else if(state is BarcodeItemsFrequent){
                          Fluttertoast.showToast(
                              msg: "الباركود متكرر",
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.amber,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }else if(state is PostItemsField){
                          Fluttertoast.showToast(
                              msg: "هناك مشكله فى حفظ الصنف",
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }


                        if(state is UpdateItemsLoading){
                          return showLoadingIndicator();
                        }else if(state is UpdateItemsSuccess){
                          Fluttertoast.showToast(
                              msg: "تم التعديل بنجاح",
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Items()));
                          });
                        }else if(state is UpdateItemsField){
                          Fluttertoast.showToast(
                              msg: "هناك مشكله فى تعديل الصنف",
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 25),
                              TextFormField(
                                controller: nameItemControl,
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.settings_input_composite),
                                  labelText: "اسم الصنف",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: barcodeItemControl,
                                      autofocus: true,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.qr_code_scanner_outlined),
                                        labelText: "الباركود",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        onPressed: () async {
                                          String scanResult0 =
                                          await FlutterBarcodeScanner.scanBarcode(
                                            "#ff6666",
                                            "Cancel",
                                            true,
                                            ScanMode.BARCODE,
                                          );

                                          if (scanResult0 != "-1") {
                                            barcodeItemControl.text = scanResult0;
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.camera_alt,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 18),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: "اختر الصنف / النوع",
                                  border: OutlineInputBorder(),
                                ),
                                value: categoryId,
                                hint: const Text("اختر الصنف / النوع"),
                                items:itemsCubit.categoriesModel
                                    .map((ItemsCategories value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id,
                                    child: Center(child: Text(value.name!)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  categoryId = value;
                                },
                              ),
                              const SizedBox(height: 18),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: "اختر وحدة البيع",
                                  border: OutlineInputBorder(),
                                ),
                                value: unitId,
                                hint: const Text("اختر وحدة البيع"),
                                items: itemsCubit.unitsModel
                                    .map((ItemsUnits value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id,
                                    child: Center(child: Text(value.name!)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  unitId = value;
                                },
                              ),
                              const SizedBox(height: 18),
                              const SizedBox(height: 18),
                              TextFormField(
                                enableInteractiveSelection: false,
                                controller: pricePerPointControl,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.sell_rounded),
                                  labelText: "السعر بالنقاط",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                enableInteractiveSelection: false,
                                controller: pricePerCoinControl,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.perm_contact_calendar_outlined),
                                  labelText: "السعر بالعمله",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                enableInteractiveSelection: false,
                                controller: priceSellControl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.credit_card_outlined),
                                  labelText: "سعر الشراء",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                enableInteractiveSelection: false,
                                controller: openBalanceControl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.credit_card_outlined),
                                  labelText: "الرصيد الافتتاحى",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: ElevatedButton.icon(
                                          label: Text("حفظ".toUpperCase(),
                                              style: const TextStyle(fontSize: 20)),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                              backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25),
                                                      side: const BorderSide(
                                                          color: Colors.white)))),
                                          onPressed: () async {
                                            chickData(context);
                                          },
                                          icon: const Icon(
                                            Icons.save,
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: ElevatedButton.icon(
                                          label: Text("الغاء".toUpperCase(),
                                              style: const TextStyle(fontSize: 20)),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                              backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25),
                                                      side: const BorderSide(
                                                          color: Colors.white)))),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                                msg: "تم الغاء العمليه",
                                                gravity: ToastGravity.SNACKBAR,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            clearData();
                                          },
                                          icon: const Icon(Icons.cancel),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                        },
                    ),
                  )

                    ),
                  );



  }

  chickData(BuildContext context) async {
    if (nameItemControl.text.isNotEmpty &&
        pricePerPointControl.text.isNotEmpty &&
        barcodeItemControl.text.isNotEmpty &&
        pricePerCoinControl.text.isNotEmpty &&
        priceSellControl.text.isNotEmpty &&
        openBalanceControl.text.isNotEmpty &&
        categoryId != null &&
        unitId != null) {
      if (choose == "add") {
        saveData();
      } else if (choose == "update") {
        updateData();
      }
    } else {
      Fluttertoast.showToast(
          msg: "برجاء اكمال باقى البيانات",
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.amber,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget showLoadingIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );

  clearData() {
    nameItemControl.clear();
    barcodeItemControl.clear();
    pricePerPointControl.clear();
    pricePerCoinControl.clear();
    priceSellControl.clear();
    openBalanceControl.clear();
  }

  saveData() {
    NewItem item = NewItem(
        barcode: barcodeItemControl.text,
        name: nameItemControl.text,
        categoryId: categoryId,
        unitId: unitId,
        priceByPoint: double.parse(pricePerPointControl.text),
        purchasePrice: double.parse(priceSellControl.text),
        priceByCurrency: double.parse(pricePerCoinControl.text),
        openBalance: double.parse(openBalanceControl.text));
    itemsCubit.postItem(item);
  }

  getUpdateData(OneItem item) {
    if (item != null) {
      id = item.id;
      nameItemControl.text = item.name!;
      barcodeItemControl.text = item.barcode!;
      pricePerPointControl.text = (item.priceByPoint ?? 0).toString();
      pricePerCoinControl.text = (item.priceByCurrency ?? 0).toString();
      priceSellControl.text = (item.purchasePrice ?? 0).toString();
      openBalanceControl.text = (item.openBalance ?? 0).toString();
      unitId = item.unitId;
      categoryId = item.categoryId;
    } else {
      clearData();
    }
  }

  String? id;

  updateData() {
    NewItem item = NewItem(
        barcode: barcodeItemControl.text,
        name: nameItemControl.text,
        categoryId: categoryId,
        unitId: unitId,
        priceByPoint: double.parse(pricePerPointControl.text),
        purchasePrice: double.parse(priceSellControl.text),
        priceByCurrency: double.parse(pricePerCoinControl.text),
        openBalance: double.parse(openBalanceControl.text));
    itemsCubit.updateItem(id!, item);
  }
}
