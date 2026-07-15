part of 'other_item_bloc.dart';

abstract class OtherItemState {}

class OtherItemInitial extends OtherItemState {}

class OtherItemLoading extends OtherItemState {}

class OtherItemLoaded extends OtherItemState {
  final List<OtherItem> items;
  final bool hasReachedMax;

  OtherItemLoaded(this.items, {this.hasReachedMax = false});

  OtherItemLoaded copyWith({
    List<OtherItem>? items,
    bool? hasReachedMax,
  }) {
    return OtherItemLoaded(
      items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class OtherItemError extends OtherItemState {
  final String message;
  OtherItemError(this.message);
}

class OtherItemPaginationError extends OtherItemState {
  final String message;
  OtherItemPaginationError(this.message);
}
