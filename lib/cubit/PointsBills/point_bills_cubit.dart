import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_project/Services/Api/get_http_services.dart';

import '../../Models/points_bills_model.dart';

part 'point_bills_state.dart';

class PointBillsCubit extends Cubit<PointBillsState> {
  PointBillsCubit() : super(PointBillsInitial());

  static PointBillsCubit get(context) => BlocProvider.of(context);
  PointsBillsModel? pointsBillsModel;

  List<Data> myData = [];
  int pageCount = 0;
  int numberOfPage = 1;
  int isSelected = 0;

  void getPointsBills() {
    emit(PointBillsLoadingState());
    GetHttpServices.getPointsBills("$numberOfPage").then((value) {
      pointsBillsModel = value;
      pageCount = value.pagesCount!;
      myData = value.data!;
      emit(PointBillsSuccessState());
    }).catchError((onError) {
      emit(PointBillsLoadingErrorState());
    });
  }

  void changePage(int position) {
    numberOfPage = position;
    getPointsBills();
  }

  void incrementPage() {
    numberOfPage++;
    getPointsBills();
  }

  void decrementPage() {
    numberOfPage--;
    if (numberOfPage < 1) {
      numberOfPage = 1;
      getPointsBills();
    } else {
      getPointsBills();
    }
  }
}
