part of 'sales_cubit.dart';

@immutable
abstract class SalesState {}

class SalesInitial extends SalesState {}

class PointsLoadingState extends SalesState {}

class PointsSuccessState extends SalesState {}

class PointsLoadingErrorState extends SalesState {}


class MonthlyLoading extends SalesState {}
class MonthlySuccess extends SalesState {}
class MonthlyField extends SalesState {}

class ClientMainLoading extends SalesState{}
class ClientMainSuccess extends SalesState{}
class ClientMainField extends SalesState{}
class ClientMainFinish extends SalesState{}

