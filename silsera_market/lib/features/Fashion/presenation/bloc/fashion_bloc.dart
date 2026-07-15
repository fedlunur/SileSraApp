
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/Fashion/domain/usecases.dart';
import 'package:silesra/features/Fashion/presenation/bloc/fashion_event.dart';
import 'package:silesra/features/Fashion/presenation/bloc/fashion_state.dart';




class FashionBloc extends Bloc<FashionEvent, FashionState> {
  final GetFashionsUseCase getFashionsUseCase;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false; // Track whether a request is in progress

  FashionBloc({required this.getFashionsUseCase}) : super(FashionInitial()) {
    on<FetchFashions>(_onFetchFashions);
    on<FetchMoreFashions>(_onFetchMoreFashions);
  }

  Future<void> _onFetchFashions(
      FetchFashions event, Emitter<FashionState> emit) async {
    _currentPage = 1; // Reset pagination on new fetch
    try {
      emit(FashionLoading());
      final newFashions =
          await getFashionsUseCase(page: _currentPage, pageSize: _pageSize);

      emit(FashionLoaded(
        fashions: newFashions,
        hasReachedMax: newFashions.length < _pageSize,
      ));

      _currentPage++;
    } catch (e) {
      emit(FashionPaginationError(e.toString()));
    }
  }

  Future<void> _onFetchMoreFashions(
      FetchMoreFashions event, Emitter<FashionState> emit) async {
    if (state is FashionLoaded) {
      final currentState = state as FashionLoaded;

      // Prevent redundant API calls
      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true; // Mark as fetching

      try {
        final fashions =
            await getFashionsUseCase(page: _currentPage, pageSize: _pageSize);
        print(
            "Fetched ${fashions.length} fashions. hasReachedMax: ${fashions.length < _pageSize}");

        if (fashions.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true)); // No more data
        } else {
          emit(currentState.copyWith(
            fashions: currentState.fashions + fashions,
            hasReachedMax: fashions.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(FashionPaginationError(e.toString()));
      } finally {
        _isFetching = false; // Mark as not fetching
      }
    }
  }
}
