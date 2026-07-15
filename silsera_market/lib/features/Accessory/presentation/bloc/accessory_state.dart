part of 'accessory_bloc.dart';

abstract class AccessoryState {}

class AccessoryInitial extends AccessoryState {}

class AccessoryLoading extends AccessoryState {}

class AccessoryLoaded extends AccessoryState {
  final List<AccessoryModel> accessories;
  final bool hasReachedMax;

  AccessoryLoaded({required this.accessories, this.hasReachedMax = false});

  AccessoryLoaded copyWith({
    List<AccessoryModel>? accessories,
    bool? hasReachedMax,
  }) {
    return AccessoryLoaded(
      accessories: accessories ?? this.accessories,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class AccessoryError extends AccessoryState {
  final String message;

  AccessoryError(this.message);
}

class AccessoryPaginationError extends AccessoryState {
  final String message;

  AccessoryPaginationError(this.message);
}