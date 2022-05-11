part of 'point_bills_cubit.dart';

@immutable
abstract class PointBillsState {}

class PointBillsInitial extends PointBillsState {}

class PointBillsLoadingState extends PointBillsState {}

class PointBillsSuccessState extends PointBillsState {}

class PointBillsLoadingErrorState extends PointBillsState {}

class PointBillsNextPageState extends PointBillsState {}

class PointBillsPreviousPageState extends PointBillsState {}

