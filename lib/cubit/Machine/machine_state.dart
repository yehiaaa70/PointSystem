part of 'machine_cubit.dart';

@immutable
abstract class MachineState {}

class MachineInitial extends MachineState {}


class MachineLoadingState extends MachineState {}

class MachineSuccessState extends MachineState {}

class MachineLoadingErrorState extends MachineState {}
