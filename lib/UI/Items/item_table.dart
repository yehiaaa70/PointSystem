import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_project/Models/item_table_model.dart';
import 'package:test_project/UI/Items/post_items.dart';

import '../../Models/new_items.dart';
import '../../cubit/Items/items_cubit.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

final controller = ScrollController();

String pageNum = "1";
List<DataItem> paginatedDataSource = [];
final _dataGridController = DataGridController();

class _ItemsState extends State<Items> {
  late OrderInfoDataSource _orderInfoDataSource;

  List<DataItem> dataTable = [];
  int x = 0;
  int y = 0;
  int z = 0;
  NewItem? updateItems;

  BuildContext? contextCubit;
  BuildContext? contextDialog;

  updateWidget() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _orderInfoDataSource = OrderInfoDataSource(z, dataTable);
    _orderInfoDataSource.addListener(updateWidget);
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
        ItemsCubit items = ItemsCubit.get(contextCubit);
        items.numberOfPage = 1;
        items.getAllItemsSearch(_searchTextController.text.trim());
        items.isSelected = 0;
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
                  msg: "من فضلك اختار السلعه!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.amber,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              print("_dataGridController.selectedIndex");
              print(_dataGridController.selectedIndex);
              var bigModel = ItemsCubit.get(contextCubit)
                  .myDataSearch[_dataGridController.selectedIndex];
              ItemsCubit.get(contextCubit).getOneItems(bigModel.id!);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            if (_dataGridController.selectedIndex < 0) {
              Fluttertoast.showToast(
                  msg: "من فضلك اختار السلعه!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              var id = ItemsCubit.get(contextCubit)
                  .myDataSearch[_dataGridController.selectedIndex]
                  .id;

              AlertDialog alert = AlertDialog(
                title: const Text(
                  "حذف السلعه",
                  textDirection: TextDirection.rtl,
                ),
                content: const Text(
                  "هل انت متاكد من حذف هذه السلعه",
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
                      ItemsCubit.get(contextCubit).deleteItem(id!);
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
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostItems(choose: "add"),
                ));
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
              var bigModel = ItemsCubit.get(contextCubit)
                  .myData[_dataGridController.selectedIndex];
              ItemsCubit.get(contextCubit).getOneItems(bigModel.id!);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            if (_dataGridController.selectedIndex < 0) {
              Fluttertoast.showToast(
                  msg: "من فضلك اختار السلعه!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              var id = ItemsCubit.get(contextCubit)
                  .myData[_dataGridController.selectedIndex]
                  .id;

              AlertDialog alert = AlertDialog(
                title: const Text(
                  "حذف السلعه",
                  textDirection: TextDirection.rtl,
                ),
                content: const Text(
                  "هل انت متاكد من حذف هذه السلعه",
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
                      ItemsCubit.get(contextCubit).deleteItem(id!);
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
      ItemsCubit items = ItemsCubit.get(contextCubit);
      items.getAllItems();
      items.myDataSearch.clear();
      items.isSelected = 0;
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
                    'جدول السلع',
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
      create: (context) => ItemsCubit()..getAllItems(),
      child: BlocConsumer<ItemsCubit, ItemsState>(
        listener: (context, state) {},
        builder: (context, state) {

          contextCubit = context;
          ItemsCubit itemsCubit = ItemsCubit.get(context);
          _orderInfoDataSource = OrderInfoDataSource(
            ItemsCubit.get(context).myData.length,
            ItemsCubit.get(context).myData,
          );
          _orderInfoDataSource.addListener(updateWidget);

          if (state is GetOneItemsLoading) {
            Fluttertoast.showToast(
                msg: " السلعه",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            return showLoadingIndicator();
          } else if (state is GetOneItemsSuccess) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostItems(choose: "update",item: itemsCubit.oneItem),
                  ));
            });
          } else if (state is GetOneItemsField) {
            Fluttertoast.showToast(
                msg: "لا توجد بيانات لهذا السلعه",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }

          if (state is DeleteItemsLoading) {
            return showLoadingIndicator();
          } else if (state is DeleteItemsSuccess) {
            Fluttertoast.showToast(
                msg: "تم الحذف بنجاح",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (state is DeleteItemsField) {
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
                  condition: state is! ItemsLoading,
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
                                  columnWidthMode:
                                      ColumnWidthMode.fitByCellValue,
                                  controller: _dataGridController,
                                  selectionMode: SelectionMode.single,
                                  source: _orderInfoDataSource,
                                  navigationMode: GridNavigationMode.row,
                                  columns: <GridColumn>[
                                    GridColumn(
                                        columnName: 'No',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text('العدد'))),
                                    GridColumn(
                                        columnName: 'Barcode',
                                        columnWidthMode: ColumnWidthMode.auto,
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'الباركود',
                                              overflow: TextOverflow.fade,
                                            ))),
                                    GridColumn(
                                        columnName: 'ItemName',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'اسم السلعه',
                                              overflow: TextOverflow.fade,
                                            ))),
                                    GridColumn(
                                        columnWidthMode: ColumnWidthMode.auto,
                                        columnName: 'CategoryName',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'النوع',
                                              overflow: TextOverflow.fade,
                                            ))),
                                    GridColumn(
                                        columnWidthMode: ColumnWidthMode.auto,
                                        columnName: 'UnitName',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'وحدة البيع',
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                            ))),
                                    GridColumn(
                                        columnWidthMode: ColumnWidthMode.auto,
                                        columnName: 'PriceByPoint',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'السعر بالنقط',
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                            ))),
                                    GridColumn(
                                        columnWidthMode: ColumnWidthMode.auto,
                                        columnName: 'PriceByCurrency',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'السعر بالعمله',
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                            ))),
                                    GridColumn(
                                        columnWidthMode: ColumnWidthMode.auto,
                                        columnName: 'PurchasePrice',
                                        label: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'سعر الشراء',
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                            ))),
                                  ]),
                            )),
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
                                  itemsCubit.changePage(1);
                                  itemsCubit.isSelected = 0;
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
                            itemCount: itemsCubit.pageCount,
                            itemBuilder: (context, position) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    itemsCubit.changePage(position + 1);
                                    itemsCubit.isSelected = position;
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          itemsCubit.isSelected == position
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
                                  itemsCubit.changePage(itemsCubit.pageCount);
                                  itemsCubit.isSelected =
                                      itemsCubit.pageCount - 1;
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
        create: (context) => ItemsCubit()..getAllItems(),
        child: BlocConsumer<ItemsCubit, ItemsState>(
          listener: (context, state) {},
          builder: (context, state) {
            contextCubit = context;
            ItemsCubit itemsCubit = ItemsCubit.get(context);
            if (itemsCubit.myDataSearch.isEmpty) {
              return Container();
            } else {
              _orderInfoDataSource = OrderInfoDataSource(
                ItemsCubit.get(context).myDataSearch.length,
                ItemsCubit.get(context).myDataSearch,
              );
              _orderInfoDataSource.addListener(updateWidget);

              if (state is GetOneItemsLoading) {
                return showLoadingIndicator();
              } else if (state is GetOneItemsSuccess) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostItems(choose: "update",item: itemsCubit.oneItem),
                      ));
                });
              } else if (state is GetOneItemsField) {
                Fluttertoast.showToast(
                    msg: "لا توجد بيانات لهذا السلعه",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

              if (state is DeleteItemsLoading) {
                return showLoadingIndicator();
              } else if (state is DeleteItemsSuccess) {
                Fluttertoast.showToast(
                    msg: "تم الحذف بنجاح",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (state is DeleteItemsField) {
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
                      condition: state is! ItemsLoading,
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
                                    columnWidthMode:
                                        ColumnWidthMode.fitByCellValue,
                                    controller: _dataGridController,
                                    selectionMode: SelectionMode.single,
                                    source: _orderInfoDataSource,
                                    navigationMode: GridNavigationMode.row,
                                    columns: <GridColumn>[
                                      GridColumn(
                                          columnName: 'No',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text('العدد'))),
                                      GridColumn(
                                          columnName: 'Barcode',
                                          columnWidthMode: ColumnWidthMode.auto,
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'الباركود',
                                                overflow: TextOverflow.fade,
                                              ))),
                                      GridColumn(
                                          columnName: 'ItemName',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'اسم السلعه',
                                                overflow: TextOverflow.fade,
                                              ))),
                                      GridColumn(
                                          columnWidthMode: ColumnWidthMode.auto,
                                          columnName: 'CategoryName',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'النوع',
                                                overflow: TextOverflow.fade,
                                              ))),
                                      GridColumn(
                                          columnWidthMode: ColumnWidthMode.auto,
                                          columnName: 'UnitName',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'وحدة البيع',
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                              ))),
                                      GridColumn(
                                          columnWidthMode: ColumnWidthMode.auto,
                                          columnName: 'PriceByPoint',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'السعر بالنقط',
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                              ))),
                                      GridColumn(
                                          columnWidthMode: ColumnWidthMode.auto,
                                          columnName: 'PriceByCurrency',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'السعر بالعمله',
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                              ))),
                                      GridColumn(
                                          columnWidthMode: ColumnWidthMode.auto,
                                          columnName: 'PurchasePrice',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'سعر الشراء',
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                              ))),
                                    ]),
                              ),
                            ),
                          ],
                        );
                      }),
                      fallback: (context) {
                        _dataGridController.selectedIndex=-1;
                        return showLoadingIndicator();
                      },                    ),
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
                                      itemsCubit.changePageSearch(
                                          1, _searchTextController.text.trim());
                                      itemsCubit.isSelected = 0;
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
                                itemCount: itemsCubit.pageCount,
                                itemBuilder: (context, position) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        itemsCubit.changePageSearch(
                                            position + 1,
                                            _searchTextController.text.trim());
                                        itemsCubit.isSelected = position;
                                      },
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              itemsCubit.isSelected == position
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
                                      itemsCubit.changePageSearch(
                                          itemsCubit.pageCount,
                                          _searchTextController.text.trim());
                                      itemsCubit.isSelected =
                                          itemsCubit.pageCount - 1;
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
}

class OrderInfoDataSource extends DataGridSource {
  int i = 0;
  List<DataItem> list = [];

  OrderInfoDataSource(this.i, this.list) {
    paginatedDataSource = list.getRange(0, i).toList();
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startRowIndex = newPageIndex * i;
    int endIndex = startRowIndex + i;

    pageNum = "${newPageIndex + 1}";
    notifyListeners();

    if (startRowIndex < list.length && endIndex <= list.length) {
      await Future.delayed(const Duration(milliseconds: 2000));
      paginatedDataSource =
          list.getRange(startRowIndex, endIndex).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      paginatedDataSource = [];
    }
    return true;
  }

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
      notifyListeners();
      return DataGridRow(cells: [
        DataGridCell(columnName: 'No', value: dataGridRow.no),
        DataGridCell(columnName: 'Barcode', value: dataGridRow.barcode),
        DataGridCell(columnName: 'ItemName', value: dataGridRow.itemName),
        DataGridCell(
            columnName: 'CategoryName', value: dataGridRow.categoryName),
        DataGridCell(columnName: 'UnitName', value: dataGridRow.unitName),
        DataGridCell(
            columnName: 'PriceByPoint', value: dataGridRow.priceByPoint),
        DataGridCell(
            columnName: 'PriceByCurrency', value: dataGridRow.priceByCurrency),
        DataGridCell(
            columnName: 'PurchasePrice', value: dataGridRow.purchasePrice),
      ]);
    }).toList(growable: false);
  }
}
