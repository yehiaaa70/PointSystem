import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_project/Models/new_client.dart';
import 'package:test_project/UI/customers/post_client_model.dart';
import '../../Models/all_client_model.dart';
import '../../cubit/Customers/customers_cubit.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  _CustomersScreen createState() => _CustomersScreen();
}

final ItemScrollController itemScrollController = ItemScrollController();
final ItemPositionsListener itemPositionsListener =
    ItemPositionsListener.create();
final controller = ScrollController();

int newNumberOfPage = 1;
String? pageNum;
List<Datum> paginatedDataSource = [];
final _dataGridController = DataGridController();

class _CustomersScreen extends State<CustomersScreen> {
  late OrderInfoDataSource _orderInfoDataSource;

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPersonNum = TextEditingController();
  TextEditingController controllerPersonQun = TextEditingController();
  TextEditingController controllerVendor = TextEditingController();
  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerSupplyingCard = TextEditingController();
  NewClient? newClient;
  NewClient? updateClient;
  bool isSave = false;
  BuildContext? contextCubit;

  @override
  void initState() {
    super.initState();
    controllerName.addListener(updateWidget);
    controllerPersonNum.addListener(updateWidget);
    controllerPersonQun.addListener(updateWidget);
    controllerVendor.addListener(updateWidget);
    controllerId.addListener(updateWidget);
    controllerSupplyingCard.addListener(updateWidget);
    _dataGridController.addListener(updateWidget);
  }

  updateWidget() {
    setState(() {});
  }

  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      controller: _searchTextController,
      cursorColor: Colors.blue,
      decoration: const InputDecoration(
        hintText: 'بحث ...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 18),
      onSubmitted: (_) {
        CustomersCubit customer = CustomersCubit.get(contextCubit);
        customer.numberOfPage = 1;
        customer.getAllClientSearch(_searchTextController.text.trim());
        customer.isSelected = 0;
      },
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear, color: Colors.blue),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            if (_dataGridController.selectedIndex < 0) {
              Fluttertoast.showToast(
                  msg: "من فضلك اختار العميل!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.amber,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              var bigModel = CustomersCubit.get(contextCubit)
                  .listSearch[_dataGridController.selectedIndex];
              updateClient = NewClient(
                  name: bigModel.clientName,
                  personsCount: bigModel.personsCount,
                  personQuantity: (bigModel.personQuantity ?? 0).toInt(),
                  personVendorName: bigModel.personVendorName,
                  idNumber: bigModel.idNumber,
                  supplyingCard: bigModel.supplyingCard);
              await updateClientDialog(updateClient!,bigModel.id!);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            if (_dataGridController.selectedIndex < 0) {
              Fluttertoast.showToast(
                  msg: "من فضلك اختار العميل!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.amber,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              var id = CustomersCubit.get(contextCubit)
                  .listSearch[_dataGridController.selectedIndex]
                  .id;

              AlertDialog alert = AlertDialog(
                title: const Text(
                  "حذف عميل",
                  textDirection: TextDirection.rtl,
                ),
                content: const Text(
                  "هل انت متاكد من حذف هذا العميل",
                  textDirection: TextDirection.rtl,
                ),
                actions: [
                  TextButton(
                    child: const Text("الغاء"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("تاكيد"),
                    onPressed: () {
                      CustomersCubit.get(contextCubit).deleteClient(id!);
                      Navigator.of(context).pop();;
                    },
                  ),
                ],
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const PostClient()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            if (_dataGridController.selectedIndex < 0) {
              Fluttertoast.showToast(
                  msg: "من فضلك اختار العميل!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.amber,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              var bigModel = CustomersCubit.get(contextCubit)
                  .list[_dataGridController.selectedIndex];
              updateClient = NewClient(
                  name: bigModel.clientName,
                  personsCount: bigModel.personsCount,
                  personQuantity: (bigModel.personQuantity ?? 0).toInt(),
                  personVendorName: bigModel.personVendorName,
                  idNumber: bigModel.idNumber,
                  supplyingCard: bigModel.supplyingCard);
              await updateClientDialog(updateClient!,bigModel.id!);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            if (_dataGridController.selectedIndex < 0) {
              Fluttertoast.showToast(
                  msg: "من فضلك اختار العميل!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.amber,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              var id = CustomersCubit.get(contextCubit)
                  .list[_dataGridController.selectedIndex]
                  .id;

              AlertDialog alert = AlertDialog(
                title: const Text(
                  "حذف عميل",
                  textDirection: TextDirection.rtl,
                ),
                content: const Text(
                  "هل انت متاكد من حذف هذا العميل",
                  textDirection: TextDirection.rtl,
                ),
                actions: [
                  TextButton(
                    child: const Text("الغاء"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("تاكيد"),
                    onPressed: () {
                      CustomersCubit.get(contextCubit).deleteClient(id!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        ),
      ];
    }
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      CustomersCubit customer = CustomersCubit.get(contextCubit);

      customer.getAllClient();
      customer.listSearch.clear();
      customer.isSelected = 0;
      _searchTextController.clear();
    });
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: _isSearching
              ? const BackButton(
                  color: Colors.blue,
                )
              : Container(),
          title: _isSearching
              ? _buildSearchField()
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'جدول العملاء',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
          actions: _buildAppBarActions(),
        ),
        body: _isSearching ? searchWidget() : mainWidget(),
      ),
    );
  }

  Widget mainWidget() => BlocProvider(
      create: (context) => CustomersCubit()..getAllClient(),
      child: BlocConsumer<CustomersCubit, CustomersState>(
        listener: (context, state) {},
        builder: (context, state) {

          if (state is UpdateCustomersLoading) {
            return showLoadingIndicator();
          } else if (state is UpdateCustomersSuccess) {
            Fluttertoast.showToast(
                msg: "تم التعديل بنجاح",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.of(dialogContext!).pop();
            controllerName.clear();
            controllerPersonNum.clear();
            controllerPersonQun.clear();
            controllerVendor.clear();
            controllerId.clear();
            controllerSupplyingCard.clear();

          } else if (state is UpdateCustomersField) {
            Fluttertoast.showToast(
                msg: "لا توجد بيانات لهذا السلعه",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }

          if (state is DeleteCustomersLoading) {
            return showLoadingIndicator();
          } else if (state is DeleteCustomersSuccess) {
            Fluttertoast.showToast(
                msg: "تم الحذف بنجاح",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (state is DeleteCustomersField) {
            Fluttertoast.showToast(
                msg: "لا يمكن الحذف",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          contextCubit = context;
          CustomersCubit customersCubit = CustomersCubit.get(context);
          _orderInfoDataSource = OrderInfoDataSource(
            CustomersCubit.get(context).list.length,
            CustomersCubit.get(context).list,
          );
          //   _orderInfoDataSource.addListener();
          return Column(
            children: [
              Expanded(
                flex: 10,
                child: ConditionalBuilder(
                  condition: state is! CustomersLoading,
                  builder: (context) =>
                      LayoutBuilder(builder: (context, constraint) {
                    return Column(
                      children: [
                        SizedBox(
                            height: constraint.maxHeight,
                            width: constraint.maxWidth,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: SfDataGrid(
                                  source: _orderInfoDataSource,
                                  columnWidthMode:
                                      ColumnWidthMode.fitByCellValue,
                                  controller: _dataGridController,
                                  selectionMode: SelectionMode.single,
                                  navigationMode: GridNavigationMode.row,
                                  columns: <GridColumn>[
                                    GridColumn(
                                        columnName: 'No',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.centerRight,
                                            child: const Center(
                                              child: Text(
                                                'م',
                                              ),
                                            ))),
                                    GridColumn(
                                        columnName: 'Barcode',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text('الباركود'))),
                                    GridColumn(
                                        columnName: 'ClientName',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'اسم العميل',
                                              overflow: TextOverflow.fade,
                                            ))),
                                    GridColumn(
                                        columnWidthMode: ColumnWidthMode.auto,
                                        columnName: 'PersonsCount',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'عدد الافراد',
                                              overflow: TextOverflow.fade,
                                            ))),
                                    GridColumn(
                                        columnWidthMode: ColumnWidthMode.auto,
                                        columnName: 'PersonQuantity',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'حصه الفرد',
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                            ))),
                                    GridColumn(
                                        columnName: 'PersonVendorName',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'التاجر التابع له',
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                            ))),
                                  ]),
                            )),

                        //  height: dataPagerHeight,
                      ],
                    );
                  }),
                  fallback: (context) {
                    _dataGridController.selectedIndex=-1;
                    return showLoadingIndicator();
                  },                ),
              ),
              Expanded(
                flex: 1,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 60,
                          width: 80,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  controller.position.animateTo(
                                    controller.position.minScrollExtent,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    curve: Curves.easeInOut,
                                  );
                                  customersCubit.changePage(1);
                                  customersCubit.isSelected = 0;
                                },
                                icon: const Icon(Icons.first_page)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: SizedBox(
                          height: 60,
                          child: ListView.builder(
                            controller: controller,
                            scrollDirection: Axis.horizontal,
                            itemCount: customersCubit.pageCount,
                            itemBuilder: (context, position) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    customersCubit.changePage(position + 1);
                                    customersCubit.isSelected = position;
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          customersCubit.isSelected == position
                                              ? Colors.blue
                                              : Colors.transparent,
                                      child: Center(
                                        child: Text(
                                          "${position + 1}",
                                          style: const TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 60,
                          width: 80,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  final contentSize =
                                      controller.position.viewportDimension +
                                          controller.position.maxScrollExtent;

                                  final target = contentSize;

                                  controller.position.animateTo(
                                    target,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                  customersCubit
                                      .changePage(customersCubit.pageCount);
                                  customersCubit.isSelected =
                                      customersCubit.pageCount - 1;
                                },
                                icon: const Icon(Icons.last_page)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ));

  Widget searchWidget() {
    return BlocProvider(
        create: (context) => CustomersCubit(),
        child: BlocConsumer<CustomersCubit, CustomersState>(
          listener: (context, state) {},
          builder: (context, state) {
            contextCubit = context;
            CustomersCubit customersCubit = CustomersCubit.get(context);

            if (customersCubit.listSearch.isEmpty) {
              return Container();
            } else {
              _orderInfoDataSource = OrderInfoDataSource(
                CustomersCubit.get(context).listSearch.length,
                CustomersCubit.get(context).listSearch,
              );


              if (state is UpdateCustomersLoading) {
                return showLoadingIndicator();
              } else if (state is UpdateCustomersSuccess) {
                Fluttertoast.showToast(
                    msg: "تم التعديل بنجاح",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);

                Navigator.of(dialogContext!).pop();
                controllerName.clear();
                controllerPersonNum.clear();
                controllerPersonQun.clear();
                controllerVendor.clear();
                controllerId.clear();
                controllerSupplyingCard.clear();

              } else if (state is UpdateCustomersField) {
                Fluttertoast.showToast(
                    msg: "لا توجد بيانات لهذا السلعه",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

              if (state is DeleteCustomersLoading) {
                return showLoadingIndicator();
              } else if (state is DeleteCustomersSuccess) {
                Fluttertoast.showToast(
                    msg: "تم الحذف بنجاح",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (state is DeleteCustomersField) {
                Fluttertoast.showToast(
                    msg: "لا يمكن الحذف",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

              return Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: ConditionalBuilder(
                      condition: state is! CustomersLoading,
                      builder: (context) =>
                          LayoutBuilder(builder: (context, constraint) {
                        return Column(
                          children: [
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: SfDataGrid(
                                    source: _orderInfoDataSource,
                                    columnWidthMode:
                                        ColumnWidthMode.fitByCellValue,
                                    controller: _dataGridController,
                                    selectionMode: SelectionMode.single,
                                    navigationMode: GridNavigationMode.row,
                                    columns: <GridColumn>[
                                      GridColumn(
                                          columnName: 'No',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.centerRight,
                                              child: const Center(
                                                child: Text(
                                                  'م',
                                                ),
                                              ))),
                                      GridColumn(
                                          columnName: 'Barcode',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text('الباركود'))),
                                      GridColumn(
                                          columnName: 'ClientName',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'اسم العميل',
                                                overflow: TextOverflow.fade,
                                              ))),
                                      GridColumn(
                                          columnWidthMode: ColumnWidthMode.auto,
                                          columnName: 'PersonsCount',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'عدد الافراد',
                                                overflow: TextOverflow.fade,
                                              ))),
                                      GridColumn(
                                          columnWidthMode: ColumnWidthMode.auto,
                                          columnName: 'PersonQuantity',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'حصه الفرد',
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                              ))),
                                      GridColumn(
                                          columnName: 'PersonVendorName',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'التاجر التابع له',
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                              ))),
                                    ]),
                              ),
                            ),
                          ],
                        );
                      }),
                      fallback: (context) => showLoadingIndicator(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 60,
                              width: 80,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      controller.position.animateTo(
                                        controller.position.minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        curve: Curves.easeInOut,
                                      );
                                      customersCubit.changePageSearch(
                                          1, _searchTextController.text.trim());
                                      customersCubit.isSelected = 0;
                                    },
                                    icon: const Icon(Icons.first_page)),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: SizedBox(
                              height: 60,
                              child: ListView.builder(
                                controller: controller,
                                scrollDirection: Axis.horizontal,
                                itemCount: customersCubit.pageCount,
                                itemBuilder: (context, position) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        customersCubit.changePageSearch(
                                            position + 1,
                                            _searchTextController.text.trim());
                                        customersCubit.isSelected = position;
                                      },
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              customersCubit.isSelected ==
                                                      position
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                          child: Center(
                                            child: Text(
                                              "${position + 1}",
                                              style: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 60,
                              width: 80,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      final contentSize = controller
                                              .position.viewportDimension +
                                          controller.position.maxScrollExtent;

                                      final target = contentSize;

                                      controller.position.animateTo(
                                        target,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                      customersCubit.changePageSearch(
                                          customersCubit.pageCount,
                                          _searchTextController.text.trim());
                                      customersCubit.isSelected =
                                          customersCubit.pageCount - 1;
                                    },
                                    icon: const Icon(Icons.last_page)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }

  Widget showLoadingIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );

  BuildContext? dialogContext;
  Future updateClientDialog(NewClient client,String id) {
    controllerName.text = client.name!;
    controllerVendor.text = client.personVendorName!;
    controllerPersonQun.text = client.personQuantity!.toString();
    controllerPersonNum.text = client.personsCount!.toString();
    controllerId.text = client.idNumber!;
    controllerSupplyingCard.text = client.supplyingCard!;

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: const Center(
                  child: Text(
                "حاله العميل",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )),
              content: SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: createDialog()),
              actions: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          icon: Image.asset("assets/images/save.png"),
                          label: const Text('حفظ'),
                          onPressed: () {
                            if (controllerName.text.isNotEmpty &&
                                controllerPersonNum.text.isNotEmpty &&
                                controllerPersonQun.text.isNotEmpty &&
                                controllerVendor.text.isNotEmpty &&
                                controllerId.text.isNotEmpty &&
                                controllerSupplyingCard.text.isNotEmpty) {
                              isSave = true;
                              newClient = NewClient(
                                name: controllerName.text,
                                personsCount:
                                    int.parse(controllerPersonNum.text),
                                personQuantity:
                                    int.parse(controllerPersonQun.text),
                                personVendorName: controllerVendor.text,
                                idNumber: controllerId.text,
                                supplyingCard: controllerSupplyingCard.text,
                              );
                              dialogContext= context;
                              CustomersCubit.get(contextCubit)
                                  .updateClient(id, newClient!);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "برجاء اكمال البايانات",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
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
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          icon: Image.asset("assets/images/cansel.png"),
                          label: const Text('الغاء'),
                          onPressed: () {
                            isSave = false;
                            Navigator.of(context).pop();
                            controllerName.clear();
                            controllerPersonNum.clear();
                            controllerPersonQun.clear();
                            controllerVendor.clear();
                            controllerId.clear();
                            controllerSupplyingCard.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  Widget createDialog() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              autofocus: true,
              controller: controllerName,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.rtl,
                border: OutlineInputBorder(),
                hintText: 'اسم العميل',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'اسم العميل',
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
              controller: controllerPersonNum,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.rtl,
                border: OutlineInputBorder(),
                hintText: 'عدد الافراد',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'عدد الافراد',
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
              controller: controllerPersonQun,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.rtl,
                border: OutlineInputBorder(),
                hintText: 'حصه الفرد',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'حصه الفرد',
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
              controller: controllerVendor,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.rtl,
                border: OutlineInputBorder(),
                hintText: 'التاجر الخاص به',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'التاجر الخاص به',
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
              controller: controllerId,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.rtl,
                border: OutlineInputBorder(),
                hintText: 'البطاقه الشخصيه',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'البطاقه الشخصيه',
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
              controller: controllerSupplyingCard,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.rtl,
                border: OutlineInputBorder(),
                hintText: 'بطاقه التموين',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'بطاقه التموين',
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

class OrderInfoDataSource extends DataGridSource {
  int i = 10;
  List<Datum> list = [];
  List<Datum> list0 = [];

  OrderInfoDataSource(this.i, this.list) {
    paginatedDataSource = list.getRange(0, i).toList();
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor() {
      int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return Colors.white10;
      } else {
        return Colors.black38;
      }
    }

    TextStyle? getSelectionTextStyle() {
      return _dataGridController.selectedRows.contains(row)
          ? const TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.red,
            )
          : null;
    }

    Decoration? getSelectionBorderStyle() {
      return _dataGridController.selectedRows.contains(row)
          ? BoxDecoration(border: Border.all(color: Colors.red))
          : null;
    }

    return DataGridRowAdapter(
        color: getBackgroundColor(),
        cells: row.getCells().map<Widget>((e) {
          return Container(
            decoration: getSelectionBorderStyle(),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value.toString(),
              style: getSelectionTextStyle(),
            ),
          );
        }).toList());
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedDataSource.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'No', value: dataGridRow.no),
        DataGridCell(columnName: 'Barcode', value: dataGridRow.barcode),
        DataGridCell(columnName: 'ClientName', value: dataGridRow.clientName),
        DataGridCell(
            columnName: 'PersonsCount', value: dataGridRow.personsCount),
        DataGridCell(
            columnName: 'PersonQuantity', value: dataGridRow.personQuantity),
        DataGridCell(
            columnName: 'PersonVendorName',
            value: dataGridRow.personVendorName),
      ]);
    }).toList(growable: false);
  }
}
