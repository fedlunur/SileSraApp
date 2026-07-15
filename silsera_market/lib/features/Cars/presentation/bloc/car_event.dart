import 'package:silesra/features/Cars/data/models/car_model.dart';

abstract class CarEvent {}

/// Fetch the first page or refresh data
class FetchCars extends CarEvent {}

/// Fetch the next page for infinite scroll
class FetchMoreCars extends CarEvent {}

/// Fetch a car by ID
class FetchCarById extends CarEvent {
  final String id;
  FetchCarById(this.id);
}

/// Add a new car
class AddCarEvent extends CarEvent {
  final CarModel car;
  AddCarEvent(this.car);
}

/// Update an existing car
class UpdateCarEvent extends CarEvent {
  final CarModel car;
  UpdateCarEvent(this.car);
}

/// Delete a car by ID
class DeleteCarEvent extends CarEvent {
  final String id;
  DeleteCarEvent(this.id);
}
