import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_project/Models/client_model.dart';

import '../../../cubit/Client/client_cubit.dart';
import '../bread/spend_bread.dart';
import '../category/category.dart';
import '../flour/flour.dart';
import '../points_bills/point_bills.dart';

class ManualBarcode extends StatefulWidget {
  ManualBarcode({Key? key, required this.kind}) : super(key: key);
  final String kind;


  @override
  State<ManualBarcode> createState() => _ManualBarcodeState();
}

class _ManualBarcodeState extends State<ManualBarcode> {
  var barcodeControl = TextEditingController();
  late ClientCubit customersCubit;
  ClientModel? clientModel;


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "باركود يدوى",
              style: (TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => ClientCubit(),
          child: BlocConsumer<ClientCubit, ClientState>(
            listener: (context, state) {},
            builder: (context, state) {
              customersCubit = ClientCubit.get(context);

              if (state is ClientLoading) {
                return showLoadingIndicator();
              } else if (state is ClientSuccess) {
                if (widget.kind == 'Bread') {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            SpendingBread(data: customersCubit.clientModel,)));
                  });
                } else if (widget.kind == 'Items') {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            Category(data: customersCubit.clientModel)));
                  });
                } else if (widget.kind == 'Flowers') {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            FlourScreen(data: customersCubit.clientModel)));
                  });
                } else if (widget.kind == 'Points') {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            PointBills(data: customersCubit.clientModel)));
                  });
                }
              } else if (state is ClientField) {
                Fluttertoast.showToast(
                    msg: "الباركود غير موجود",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: barcodeControl,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.qr_code),
                            labelText: "الباركود",
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
                                    label: const Text("عرض البيانات",
                                        style: TextStyle(fontSize: 20)),
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
                                                borderRadius:
                                                BorderRadius.circular(25),
                                                side: const BorderSide(
                                                    color: Colors.white)))),
                                    onPressed: () async {
                                      chickData(context);
                                    },
                                    icon: const Icon(
                                      Icons.search,
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
                                                borderRadius:
                                                BorderRadius.circular(25),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget showLoadingIndicator() =>
      const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );

  chickData(context) {
    if (barcodeControl.text.isNotEmpty) {
      saveData(context);
    } else {
      Fluttertoast.showToast(
          msg: "برجاء ادخال الباركود",
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.amber,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  clearData() {
    barcodeControl.clear();
  }

  saveData(context) async {
    customersCubit.getClientByBarcode(barcodeControl.text);
  }
}
