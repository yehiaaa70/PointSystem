part of 'customers_cubit.dart';

@immutable
abstract class CustomersState {}

class CustomersInitial extends CustomersState {}

class CustomersLoading extends CustomersState{}
class CustomersSuccess extends CustomersState{}
class CustomersField extends CustomersState{}


class UpdateCustomersLoading extends CustomersState{}
class UpdateCustomersSuccess extends CustomersState{}
class UpdateCustomersField extends CustomersState{}

class DeleteCustomersLoading extends CustomersState{}
class DeleteCustomersSuccess extends CustomersState{}
class DeleteCustomersField extends CustomersState{}


class PostCustomersLoading extends CustomersState{}
class PostCustomersSuccess extends CustomersState{}
class PostCustomersField extends CustomersState{}
class PostCustomersFrequent extends CustomersState{}



