part of 'electronics_bloc.dart';

abstract class ElectronicsState {}

class ElectronicsInitial extends ElectronicsState {}

class ElectronicsLoading extends ElectronicsState {}

class ElectronicsLoaded extends ElectronicsState {
  final List<ElectronicsModel> electronics;
  final bool hasReachedMax;

  ElectronicsLoaded({required this.electronics, this.hasReachedMax = false});

  ElectronicsLoaded copyWith({
    List<ElectronicsModel>? electronics,
    bool? hasReachedMax,
  }) {
    return ElectronicsLoaded(
      electronics: electronics ?? this.electronics,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ElectronicsDetailLoaded extends ElectronicsState {
  final ElectronicsModel electronics;

  ElectronicsDetailLoaded(this.electronics);
}

class ElectronicsOperationSuccess extends ElectronicsState {}

class ElectronicsError extends ElectronicsState {
  final String message;

  ElectronicsError(this.message);
}

class ElectronicsPaginationError extends ElectronicsState {
  final String message;

  ElectronicsPaginationError(this.message);
}
