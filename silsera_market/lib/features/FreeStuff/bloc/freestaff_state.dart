part of 'freestaff_bloc.dart';

abstract class FreestaffState {}

class FreestaffInitial extends FreestaffState {}

class FreestaffLoading extends FreestaffState {}

class FreestaffLoaded extends FreestaffState {
  final List<FreeStaffOrItem> freestaff;
  final bool hasReachedMax;

  FreestaffLoaded({
    required this.freestaff,
    this.hasReachedMax = false,
  });

  FreestaffLoaded copyWith({
    List<FreeStaffOrItem>? freestaff,
    bool? hasReachedMax,
  }) {
    return FreestaffLoaded(
      freestaff: freestaff ?? this.freestaff,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class FreestaffError extends FreestaffState {
  final String message;
  FreestaffError(this.message);
}

class FreestaffPaginationError extends FreestaffState {
  final String message;
  FreestaffPaginationError(this.message);
}
