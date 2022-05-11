part of 'items_cubit.dart';

@immutable
abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState{}
class ItemsSuccess extends ItemsState{}
class ItemsField extends ItemsState{}

class GetOneItemsLoading extends ItemsState{}
class GetOneItemsSuccess extends ItemsState{}
class GetOneItemsField extends ItemsState{}

class PostItemsLoading extends ItemsState{}
class PostItemsSuccess extends ItemsState{}
class PostItemsField extends ItemsState{}
class PostItemsFrequent extends ItemsState{}
class BarcodeItemsFrequent extends ItemsState{}

class UpdateItemsLoading extends ItemsState{}
class UpdateItemsSuccess extends ItemsState{}
class UpdateItemsField extends ItemsState{}

class DeleteItemsLoading extends ItemsState{}
class DeleteItemsSuccess extends ItemsState{}
class DeleteItemsField extends ItemsState{}


class ClientLoading extends ItemsState{}
class ClientSuccess extends ItemsState{}
class ClientField extends ItemsState{}


class PrintingLoadingItem extends ItemsState{}
class PrintingFinishItem extends ItemsState{}
class PrintingSuccessItem extends ItemsState{}
class PrintingFieldItem extends ItemsState{}


class KillFinishItem extends ItemsState{}
class KillFinishErrorItem extends ItemsState{}
class getIpsItem extends ItemsState{}


