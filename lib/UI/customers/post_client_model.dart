import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_project/cubit/Customers/customers_cubit.dart';

import '../../Models/new_client.dart';
import 'customers.dart';

class PostClient extends StatefulWidget {
 const PostClient({Key? key}) : super(key: key);

  @override
  State<PostClient> createState() => _PostClientState();
}

class _PostClientState extends State<PostClient> {
  var nameClientControl = TextEditingController();

  var numOfClientControl = TextEditingController();

  var quantityClientControl = TextEditingController();

  var vendorClientControl = TextEditingController();

  var idClientControl = TextEditingController();

  var supplyCardClientControl = TextEditingController();

  late CustomersCubit customersCubit;

  BuildContext? contextDialog;

  @override
  Widget build(BuildContext context) {
    // final data = ModalRoute.of(context)!.settings.arguments as model;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "حاله عميل",
              style: (TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => CustomersCubit(),
          child: BlocConsumer<CustomersCubit, CustomersState>(
            listener: (context, state) {},
            builder: (context, state) {

              customersCubit = CustomersCubit.get(context);

              if(state is PostCustomersLoading){
                return showLoadingIndicator();
              }else if(state is PostCustomersSuccess){
                Fluttertoast.showToast(
                    msg: "تم الحفظ بنجاح",
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CustomersScreen()));
                });
              }else if(state is PostCustomersFrequent){
                Fluttertoast.showToast(
                    msg: "اسم العميل متكرر",
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.amber,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }else if(state is PostCustomersField){
                Fluttertoast.showToast(
                    msg: "هناك مشكله فى حفظ العميل",
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
                        controller: nameClientControl,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_add_rounded),
                          labelText: "اسم العميل",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: numOfClientControl,
                        textInputAction: TextInputAction.next,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.people_rounded),
                          labelText: "عدد الافراد",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: quantityClientControl,
                        textInputAction: TextInputAction.next,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.addchart_outlined),
                          labelText: "حصه الفرد",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: vendorClientControl,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.sell_rounded),
                          labelText: "التاجر الخاص به",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: idClientControl,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.perm_contact_calendar_outlined),
                          labelText: "البطاقه الشخصيه",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: supplyCardClientControl,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.credit_card_outlined),
                          labelText: "بطاقه التموين",
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
                              label: const Text("حفط",
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
                                chickData();

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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget showLoadingIndicator() => const Center(
    child: CircularProgressIndicator(
      color: Colors.blue,
    ),
  );

  chickData() {
    if (nameClientControl.text.isNotEmpty &&
        numOfClientControl.text.isNotEmpty &&
        quantityClientControl.text.isNotEmpty &&
        vendorClientControl.text.isNotEmpty &&
        idClientControl.text.isNotEmpty &&
        supplyCardClientControl.text.isNotEmpty) {
      saveData();
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

  clearData() {
    nameClientControl.clear();
    numOfClientControl.clear();
    quantityClientControl.clear();
    vendorClientControl.clear();
    idClientControl.clear();
    supplyCardClientControl.clear();
  }

  saveData() async {
    NewClient newClient = NewClient(
      name: nameClientControl.text,
      personsCount: int.parse(numOfClientControl.text),
      personQuantity: int.parse(quantityClientControl.text),
      personVendorName: vendorClientControl.text,
      idNumber: idClientControl.text,
      supplyingCard: supplyCardClientControl.text,
    );
    customersCubit.postClient(newClient);
  }
}
