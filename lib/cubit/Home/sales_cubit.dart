import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Models/client_model.dart';
import '../../Models/statistical_model.dart';
import '../../Services/Api/get_http_services.dart';
import '../../Services/Api/post_http_services.dart';
import 'dart:math';
part 'sales_state.dart';


class SalesCubit extends Cubit<SalesState> {
  SalesCubit() : super(SalesInitial());

  static SalesCubit get(context) => BlocProvider.of(context);
  StatisticalModel statisticalModel =  StatisticalModel();
  List<Graph> myGraph = [];
  String date = DateFormat.yMMMd().format(DateTime.now());
  String allTimeFormatted = DateFormat('KK:mm a').format(DateTime.now());
  TooltipBehavior tooltip = TooltipBehavior(enable: true);
  ClientModel clientModel = ClientModel();

  List<int> maxGraph=[];
  addList(){
      for(int i=0;i<7;i++) {
        maxGraph.add(myGraph[i].pointsCount!);
      }
      print(maxGraph.reduce(max));
  }
  void getStatistical() {
    emit(PointsLoadingState());
    GetHttpServices.getStatistical().then((value) {
      statisticalModel = value;
      myGraph = value.graph!;
      addList();
      emit(PointsSuccessState());
    }).catchError((onError) {
      emit(PointsLoadingErrorState());
    });
  }

  String postMonthBalance()  {
    emit(MonthlyLoading());
    PostHttpServices.postMonthBalance().then((value) {
      emit(MonthlySuccess());
      return"Done";
    }).catchError((onError) {
      emit(MonthlyField());
      return "Faild";
    });
    return"Nothing";
  }

  void getClientByBarcode(String page) {
    emit(ClientMainLoading());
    GetHttpServices.getClientByBarcode(page).then((value) {
      clientModel = value;
      print("clientModel.name");
      print(clientModel.name);
      emit(ClientMainSuccess());
    }).catchError((onError) {
      print("onError");
      print(onError);
      emit(ClientMainField());
    });
  }

  void finishPrint(){
    emit(PointsSuccessState());
  }

}
