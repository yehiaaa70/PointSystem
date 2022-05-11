import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_project/Models/new_client.dart';
import 'package:test_project/Services/Api/post_http_services.dart';

import '../../Models/all_client_model.dart';
import '../../Services/Api/delete_http_services.dart';
import '../../Services/Api/get_http_services.dart';
import '../../Services/Api/update_http_services.dart';

part 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit() : super(CustomersInitial());

  static CustomersCubit get(context) => BlocProvider.of(context);
  int numberOfPage = 1;
  int pageCount = 0;
  List<Datum> list = [];
  List<Datum> listSearch = [];
  int isSelected = 0;
  String? error;
   String added='' ;


  void getAllClient() {
    emit(CustomersLoading());
    GetHttpServices.getAllClient(numberOfPage.toString()).then((value) {
      list = value.data!;
      pageCount = value.pagesCount!;
      emit(CustomersSuccess());
    }).catchError((onError) {
      emit(CustomersField());
    });
  }

  void getAllClientSearch(String search) {
    emit(CustomersLoading());
    GetHttpServices.getAllClientSearch("$numberOfPage",search).then((value) {
      listSearch = value.data!;
      pageCount = value.pagesCount!;
      emit(CustomersSuccess());
    }).catchError((onError) {
      emit(CustomersField());
    });
  }

  void postClient(NewClient newClient)  {
    emit(PostCustomersLoading());
    PostHttpServices.postClients(newClient).then((value) {
      if(value=="اسم العميل متكرر"){
        added=value;
        emit(PostCustomersFrequent());
      }else{
        added="";
        getAllClient();
        emit(PostCustomersSuccess());
      }
    }).catchError((onError) {
      emit(PostCustomersField());
    });
  }

  void deleteClient(String id) {
    emit(CustomersLoading());
    DeleteHttpServices.deleteClients(id).then((value) {
      emit(CustomersSuccess());
      getAllClient();
    }).catchError((onError) {
      emit(CustomersField());
    });
  }

  void updateClient(String id, NewClient client) {
    emit(UpdateCustomersLoading());
    UpdateHttpServices.updateClients(id, client).then((value) {
      print("تمم با عم الحج انا هنا");
      getAllClient();
      emit(UpdateCustomersSuccess());
    }).catchError((onError) {
      emit(UpdateCustomersField());
    });
  }

  changePage(int position) {
    numberOfPage = position;
    getAllClient();
  }

  changePageSearch(int position,search) {
    numberOfPage = position;
    getAllClientSearch(search);
  }



}
