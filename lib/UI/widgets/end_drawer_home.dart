import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../cubit/Home/sales_cubit.dart';
import '../Items/item_table.dart';
import '../customers/customers.dart';
import '../monthly/Monthly.dart';
import '../printer_setting.dart';
import '../sales/bread/spend_bread.dart';
import '../sales/category/category.dart';
import '../sales/flour/flour.dart';
import '../sales/points_bills/point_bills.dart';
import '../sales/points_bills/points_bills_table.dart';
import '../sales/sales/manual_barcode.dart';
import 'dot_line.dart';
import 'listtile.dart';

class MainDrawer extends StatefulWidget {
   MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String? _kinds;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SalesCubit(),
        child: BlocConsumer<SalesCubit, SalesState>(
          listener: (context, state) {},
          builder: (context, state) {
            SalesCubit salesCubit = SalesCubit.get(context);

            if (state is ClientMainLoading) {
              salesCubit.finishPrint();
              return showLoadingIndicator();
            } else if (state is ClientMainSuccess) {
              salesCubit.finishPrint();
              condition(salesCubit);
            } else if (state is ClientMainField) {
              Fluttertoast.showToast(
                  msg: "الباركود غير موجود",
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              salesCubit.finishPrint();
            }

            return  SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Drawer(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 50.0),
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 140,
                            width: 140,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        child: listTile(
                            image: 'assets/images/breead.png',
                            text: "صرف خبز",
                            onTabFunction: () async {
                              String scanResult0 =
                              await FlutterBarcodeScanner.scanBarcode(
                                "#ff6666",
                                "ادخال يدوى",
                                true,
                                ScanMode.BARCODE,
                              );
                              print("scanResult0");
                              print(scanResult0);

                              if (scanResult0 != "-1") {
                                _kinds = 'Bread';
                                salesCubit.getClientByBarcode(scanResult0);
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ManualBarcode(
                                      kind: 'Bread',
                                    )));
                              }
                            }),
                      ),
                      dotLine(),
                      listTile(
                          image: 'assets/images/wheat.png',
                          text: "صرف دقيق",
                          onTabFunction: () async {
                            String scanResult0 =
                            await FlutterBarcodeScanner.scanBarcode(
                              "#ff6666",
                              "ادخال يدوى",
                              true,
                              ScanMode.BARCODE,
                            );

                            if (scanResult0 != "-1") {
                              _kinds = 'Flowers';
                              salesCubit.getClientByBarcode(scanResult0);
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ManualBarcode(
                                    kind: 'Flowers',
                                  )));
                            }
                          }),
                      dotLine(),
                      listTile(
                          image: "assets/images/products.png",
                          text: "صرف سلعة",
                          onTabFunction: () async {
                            String scanResult0 =
                            await FlutterBarcodeScanner.scanBarcode(
                              "#ff6666",
                              "ادخال يدوى",
                              true,
                              ScanMode.BARCODE,
                            );
                            print(scanResult0);
                            if (scanResult0 != "-1") {
                              _kinds = 'Items';
                              salesCubit.getClientByBarcode(scanResult0);
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ManualBarcode(
                                    kind: 'Items',
                                  )));
                            }
                          }),
                      dotLine(),
                      listTile(
                          image: "assets/images/wallet.png",
                          text: "صرف استبدال النقاط",
                          onTabFunction: () async {
                            String scanResult0 =
                            await FlutterBarcodeScanner.scanBarcode(
                              "#ff6666",
                              "ادخال يدوى",
                              true,
                              ScanMode.BARCODE,
                            );
                            if (scanResult0 != "-1") {
                              _kinds = 'Points';
                              salesCubit.getClientByBarcode(scanResult0);
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ManualBarcode(
                                    kind: 'Points',
                                  )));
                            }
                          }),
                      dotLine(),
                      listTile(
                          image: "assets/images/shopping.png",
                          text: " جدول العملاء",
                          onTabFunction: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CustomersScreen()))),
                      dotLine(),
                      listTile(
                          image: "assets/images/calendar.png",
                          text: "جدول الحصص الشهرية",
                          onTabFunction: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Monthly()))),
                      dotLine(),
                      listTile(
                          image: "assets/images/item.png",
                          text: "جدول السلع",
                          onTabFunction: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Items()))),
                      dotLine(),
                      listTile(
                          image: "assets/images/wallet.png",
                          text: "جدول العمليات",
                          onTabFunction: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PointsBillsTable()))),
                      dotLine(),
                      listTile(
                          image: "assets/images/printer-setting.png",
                          text: "اعدادات الطابعه",
                          onTabFunction: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PrinterSetting()))),
                    ],
                  ),
                ));
          },
        ));
  }

  Widget showLoadingIndicator() => const Center(
    child: CircularProgressIndicator(
      color: Colors.blue,
    ),
  );

  condition(SalesCubit salesCubit) {
    if (_kinds == "Points") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PointBills(data: salesCubit.clientModel)));
    } else if (_kinds == "Items") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Category(data: salesCubit.clientModel)));
    } else if (_kinds == "Flower") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FlourScreen(data: salesCubit.clientModel)));
    } else if (_kinds == "Bread") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SpendingBread(data: salesCubit.clientModel)));
    }
  }
}
