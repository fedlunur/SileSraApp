import 'package:silesra/features/Cars/data/models/car_model.dart';


abstract class CarState {}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarLoaded extends CarState {
  final List<CarModel> cars;
  final bool hasReachedMax;

  CarLoaded({required this.cars, this.hasReachedMax = false});

  CarLoaded copyWith({
    List<CarModel>? cars,
    bool? hasReachedMax,
  }) {
    return CarLoaded(
      cars: cars ?? this.cars,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class CarDetailLoaded extends CarState {
  final CarModel car;

  CarDetailLoaded(this.car);
}

class CarOperationSuccess extends CarState {}

class CarError extends CarState {
  final String message;

  CarError(this.message);
}

class CarPaginationError extends CarState {
  final String message;

  CarPaginationError(this.message);
}
