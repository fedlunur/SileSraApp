
import 'package:silesra/features/Fashion/data/model/fashion_model.dart';


abstract class FashionState {}

class FashionInitial extends FashionState {}

class FashionLoading extends FashionState {}

class FashionLoaded extends FashionState {
  final List<FashionModel> fashions;
  final bool hasReachedMax;

  FashionLoaded({required this.fashions, this.hasReachedMax = false});

  FashionLoaded copyWith({
    List<FashionModel>? fashions,
    bool? hasReachedMax,
  }) {
    return FashionLoaded(
      fashions: fashions ?? this.fashions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class FashionDetailLoaded extends FashionState {
  final FashionModel fashion;

  FashionDetailLoaded(this.fashion);
}

class FashionOperationSuccess extends FashionState {}

class FashionError extends FashionState {
  final String message;

  FashionError(this.message);
}

class FashionPaginationError extends FashionState {
  final String message;

  FashionPaginationError(this.message);
}
