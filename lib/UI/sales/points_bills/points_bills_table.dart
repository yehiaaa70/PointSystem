import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Models/points_bills_model.dart';
import '../../../cubit/PointsBills/point_bills_cubit.dart';

class PointsBillsTable extends StatefulWidget {
  const PointsBillsTable({Key? key}) : super(key: key);

  @override
  _PointsBillsTableState createState() => _PointsBillsTableState();
}
final controller = ScrollController();

String pageNum = "1";
int numOfPage = 1;
List<Data> paginatedDataSource = [];

class _PointsBillsTableState extends State<PointsBillsTable> {
  late OrderInfoDataSource _orderInfoDataSource;

  @override
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('جدول العمليات',style: TextStyle(color: Colors.blue),),
          ),
        ),
        body: BlocProvider(
            create: (context) => PointBillsCubit()..getPointsBills(),
            child: BlocConsumer<PointBillsCubit, PointBillsState>(
              listener: (context, state) {},
              builder: (context, state) {
                PointBillsCubit pointBillsCubit = PointBillsCubit.get(context);
                _orderInfoDataSource = OrderInfoDataSource(
                  pointBillsCubit.myData.length,
                  pointBillsCubit.myData,
                );
                return Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: ConditionalBuilder(
                        condition: state is PointBillsSuccessState,
                        builder: (context) =>
                            LayoutBuilder(builder: (context, constraint) {
                          return Column(
                            children: [
                              SizedBox(
                                  height: constraint.maxHeight ,
                                  width: constraint.maxWidth,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: SfDataGrid(
                                        onCellTap: (details) {
                                        },
                                        source: _orderInfoDataSource,
                                        columnWidthMode:
                                            ColumnWidthMode.fitByCellValue,
                                        columns: <GridColumn>[
                                          GridColumn(
                                              columnName: 'Id',
                                              label: Container(
                                                  padding: const EdgeInsets.all(6.0),
                                                  alignment: Alignment.centerRight,
                                                  child: const Center(
                                                    child:  Text(
                                                      'م',
                                                    ),
                                                  ))),
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
                                              columnName: 'Date',
                                              label: Container(
                                                  padding: const EdgeInsets.all(6.0),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'التاريخ',
                                                    overflow: TextOverflow.fade,
                                                  ))),
                                          GridColumn(
                                              columnWidthMode: ColumnWidthMode.auto,
                                              columnName: 'TypeName',
                                              label: Container(
                                                  padding: const EdgeInsets.all(6.0),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'النوع',
                                                    overflow: TextOverflow.fade,
                                                  ))),
                                          GridColumn(
                                              columnWidthMode: ColumnWidthMode.auto,
                                              columnName: 'TotalPoints',
                                              label: Container(
                                                  padding: const EdgeInsets.all(6.0),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'اجمالى النقاط',
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                  ))),
                                          GridColumn(
                                              columnName: 'MachineName',
                                              label: Container(
                                                  padding: const EdgeInsets.all(6.0),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'الماكينه',
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                  ))),
                                        ]),
                                  )),

                            ],
                          );
                        }),
                        // pointBillsCubit.incrementPage(),
                        // pointBillsCubit.decrementPage()),
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
                                            duration: const Duration(
                                                milliseconds: 1000),
                                            curve: Curves.easeInOut,
                                          );
                                          pointBillsCubit.changePage(1);
                                          pointBillsCubit.isSelected = 0;
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
                                    itemCount: pointBillsCubit.pageCount,
                                    itemBuilder: (context, position) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            pointBillsCubit
                                                .changePage(position + 1);
                                            pointBillsCubit.isSelected = position;
                                          },
                                          child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: CircleAvatar(
                                              backgroundColor: pointBillsCubit.isSelected ==
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
                                          pointBillsCubit.changePage(
                                              pointBillsCubit.pageCount);
                                          pointBillsCubit.isSelected =
                                              pointBillsCubit.pageCount - 1;
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
            )),
      ),
    );
  }



  Widget showLoadingIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );
}

class OrderInfoDataSource extends DataGridSource {
  int i = 0;
  List<Data> list = [];

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
      await Future.delayed(const Duration(milliseconds: 9000));
      paginatedDataSource =
          list.getRange(startRowIndex, endIndex).toList(growable: false);
      buildPaginatedDataGridRows();
      // notifyListeners();
    } else {
      paginatedDataSource = [];
    }
    return true;
  }

  @override
  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 5));
    buildPaginatedDataGridRows();
    notifyListeners();
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
    // notifyListeners();

    return DataGridRowAdapter(
        color: getBackgroundColor(),
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedDataSource.map<DataGridRow>((dataGridRow) {
      notifyListeners();
      return DataGridRow(cells: [
        DataGridCell(columnName: 'Id', value: dataGridRow.id),
        DataGridCell(columnName: 'ClientName', value: dataGridRow.clientName),
        DataGridCell(columnName: 'Date', value: dataGridRow.insertedDate),
        DataGridCell(columnName: 'TypeName', value: dataGridRow.typeName),
        DataGridCell(columnName: 'TotalPoints', value: dataGridRow.totalPoints),
        DataGridCell(columnName: 'MachineName', value: dataGridRow.machineName),
      ]);
    }).toList(growable: false);
  }
}
