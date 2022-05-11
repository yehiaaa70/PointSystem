import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../Models/MachineModel.dart';
import '../../Services/Api/get_http_services.dart';

part 'machine_state.dart';

class MachineCubit extends Cubit<MachineState> {
  MachineCubit() : super(MachineInitial());

  static MachineCubit get(context) => BlocProvider.of(context);

  MachineModel? machineModel;
  List<Details> detail = [];


  void getMachineId(String id,String machineId) {
    emit(MachineLoadingState());
    GetHttpServices.getMachineId(id, machineId).then((value) {
      machineModel = value;
      detail = value.details!;
      emit(MachineSuccessState());
    });
  }
}
