import 'package:silesra/features/House/data/model/house_model.dart';

abstract class HouseState {}

class HouseInitial extends HouseState {}

class HouseLoading extends HouseState {}

class HouseLoaded extends HouseState {
  final List<HouseModel> houses;
  final bool hasReachedMax;

  HouseLoaded({required this.houses, this.hasReachedMax = false});

  HouseLoaded copyWith({
    List<HouseModel>? houses,
    bool? hasReachedMax,
  }) {
    return HouseLoaded(
      houses: houses ?? this.houses,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class HouseDetailLoaded extends HouseState {
  final HouseModel house;

  HouseDetailLoaded(this.house);
}

class HouseOperationSuccess extends HouseState {}

class HouseError extends HouseState {
  final String message;

  HouseError(this.message);
}

class HousePaginationError extends HouseState {
  final String message;

  HousePaginationError(this.message);
}
