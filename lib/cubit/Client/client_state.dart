part of 'client_cubit.dart';

@immutable
abstract class ClientState {}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState{}
class ClientSuccess extends ClientState{}
class ClientField extends ClientState{}

class PrintingLoading extends ClientState{}
class PrintingSuccess extends ClientState{}
class PrintingsField extends ClientState{}
class PrintingFinish extends ClientState{}
class KillFinish extends ClientState{}
class KillFinishError extends ClientState{}
class getIps extends ClientState{}

