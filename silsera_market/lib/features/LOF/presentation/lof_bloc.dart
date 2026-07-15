// LostOrFound Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/LOF/data/model/lof_model.dart';
import 'package:silesra/features/LOF/domain/lof_domain.dart';

class LostOrFoundBloc extends Bloc<LostOrFoundEvent, LostOrFoundState> {
  final GetLostOrFounds getLostOrFounds;
  final GetLostOrFoundById getLostOrFoundById;
  final AddLostOrFound addLostOrFound;
  final UpdateLostOrFound updateLostOrFound;
  final DeleteLostOrFound deleteLostOrFound;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false;

  LostOrFoundBloc({
    required this.getLostOrFounds,
    required this.getLostOrFoundById,
    required this.addLostOrFound,
    required this.updateLostOrFound,
    required this.deleteLostOrFound,
  }) : super(LostOrFoundInitial()) {
    on<FetchLostOrFounds>(_onFetchLostOrFounds);
    on<FetchMoreLostOrFounds>(_onFetchMoreLostOrFounds);
    on<FetchLostOrFoundById>(_onFetchLostOrFoundById);
    on<AddLostOrFoundEvent>(_onAddLostOrFound);
    on<UpdateLostOrFoundEvent>(_onUpdateLostOrFound);
    on<DeleteLostOrFoundEvent>(_onDeleteLostOrFound);
  }

  Future<void> _onFetchLostOrFounds(
      FetchLostOrFounds event, Emitter<LostOrFoundState> emit) async {
    _currentPage = 1;
    emit(LostOrFoundLoading());
    try {
      final result = await getLostOrFounds(page: _currentPage, pageSize: _pageSize);
      emit(LostOrFoundLoaded(
        lostOrFounds: result,
        hasReachedMax: result.length < _pageSize,
      ));
      _currentPage++;
    } catch (e) {
      emit(LostOrFoundError(e.toString()));
    }
  }

  Future<void> _onFetchMoreLostOrFounds(
      FetchMoreLostOrFounds event, Emitter<LostOrFoundState> emit) async {
    if (state is LostOrFoundLoaded) {
      final currentState = state as LostOrFoundLoaded;
      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true;
      try {
        final result = await getLostOrFounds(page: _currentPage, pageSize: _pageSize);
        if (result.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(currentState.copyWith(
            lostOrFounds: currentState.lostOrFounds + result,
            hasReachedMax: result.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(LostOrFoundPaginationError(e.toString()));
      } finally {
        _isFetching = false;
      }
    }
  }

  Future<void> _onFetchLostOrFoundById(
      FetchLostOrFoundById event, Emitter<LostOrFoundState> emit) async {
    emit(LostOrFoundLoading());
    try {
      final result = await getLostOrFoundById(event.id);
      emit(LostOrFoundDetailLoaded(result));
    } catch (e) {
      emit(LostOrFoundError(e.toString()));
    }
  }

  Future<void> _onAddLostOrFound(
      AddLostOrFoundEvent event, Emitter<LostOrFoundState> emit) async {
    emit(LostOrFoundLoading());
    try {
      await addLostOrFound(event.lostOrFound);
      emit(LostOrFoundOperationSuccess());
    } catch (e) {
      emit(LostOrFoundError(e.toString()));
    }
  }

  Future<void> _onUpdateLostOrFound(
      UpdateLostOrFoundEvent event, Emitter<LostOrFoundState> emit) async {
    emit(LostOrFoundLoading());
    try {
      await updateLostOrFound(event.lostOrFound);
      emit(LostOrFoundOperationSuccess());
    } catch (e) {
      emit(LostOrFoundError(e.toString()));
    }
  }

  Future<void> _onDeleteLostOrFound(
      DeleteLostOrFoundEvent event, Emitter<LostOrFoundState> emit) async {
    emit(LostOrFoundLoading());
    try {
      await deleteLostOrFound(event.id);
      emit(LostOrFoundOperationSuccess());
    } catch (e) {
      emit(LostOrFoundError(e.toString()));
    }
  }
}

abstract class LostOrFoundEvent {}

class FetchLostOrFounds extends LostOrFoundEvent {}

class FetchMoreLostOrFounds extends LostOrFoundEvent {}

class FetchLostOrFoundById extends LostOrFoundEvent {
  final String id;
  FetchLostOrFoundById(this.id);
}

class AddLostOrFoundEvent extends LostOrFoundEvent {
  final LostOrFound lostOrFound;
  AddLostOrFoundEvent(this.lostOrFound);
}

class UpdateLostOrFoundEvent extends LostOrFoundEvent {
  final LostOrFound lostOrFound;
  UpdateLostOrFoundEvent(this.lostOrFound);
}

class DeleteLostOrFoundEvent extends LostOrFoundEvent {
  final String id;
  DeleteLostOrFoundEvent(this.id);
}
abstract class LostOrFoundState {}

class LostOrFoundInitial extends LostOrFoundState {}

class LostOrFoundLoading extends LostOrFoundState {}

class LostOrFoundLoaded extends LostOrFoundState {
  final List<LostOrFound> lostOrFounds;
  final bool hasReachedMax;

  LostOrFoundLoaded({
    required this.lostOrFounds,
    this.hasReachedMax = false,
  });

  LostOrFoundLoaded copyWith({
    List<LostOrFound>? lostOrFounds,
    bool? hasReachedMax,
  }) {
    return LostOrFoundLoaded(
      lostOrFounds: lostOrFounds ?? this.lostOrFounds,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class LostOrFoundDetailLoaded extends LostOrFoundState {
  final LostOrFound lostOrFound;
  LostOrFoundDetailLoaded(this.lostOrFound);
}

class LostOrFoundOperationSuccess extends LostOrFoundState {}

class LostOrFoundError extends LostOrFoundState {
  final String message;
  LostOrFoundError(this.message);
}

class LostOrFoundPaginationError extends LostOrFoundState {
  final String message;
  LostOrFoundPaginationError(this.message);
}
