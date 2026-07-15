part of 'accessory_bloc.dart';

abstract class AccessoryEvent {}

/// Fetch the first page or refresh data
class AccessoryFetchEvent extends AccessoryEvent {}

/// Fetch the next page for infinite scroll
class FetchMoreAccessories extends AccessoryEvent {}
