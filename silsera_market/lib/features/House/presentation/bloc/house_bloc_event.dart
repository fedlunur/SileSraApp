import 'package:silesra/features/House/data/model/house_model.dart';

abstract class HouseEvent {}

/// Fetch the first page or refresh data
class FetchHouses extends HouseEvent {}

/// Fetch the next page for infinite scroll
class FetchMoreHouses extends HouseEvent {}

/// Fetch a house by ID
class FetchHouseById extends HouseEvent {
  final String id;
  FetchHouseById(this.id);
}

/// Add a new house
class AddHouseEvent extends HouseEvent {
  final HouseModel house;
  AddHouseEvent(this.house);
}

/// Update an existing house
class UpdateHouseEvent extends HouseEvent {
  final HouseModel house;
  UpdateHouseEvent(this.house);
}

/// Delete a house by ID
class DeleteHouseEvent extends HouseEvent {
  final String id;
  DeleteHouseEvent(this.id);
}
