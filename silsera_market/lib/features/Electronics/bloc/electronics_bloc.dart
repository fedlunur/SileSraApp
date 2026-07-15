import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/Electronics/data/model/electronics_model.dart';
import 'package:silesra/features/Electronics/domain/usecases/usecases.dart';

part 'electronics_event.dart';
part 'electronics_state.dart';



class ElectronicsBloc extends Bloc<ElectronicsEvent, ElectronicsState> {
  final GetElectronicsUseCase getElectronicsUseCase;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false; // Track whether a request is in progress

  ElectronicsBloc({required this.getElectronicsUseCase}) : super(ElectronicsInitial()) {
    on<FetchElectronics>(_onFetchElectronics);
    on<FetchMoreElectronics>(_onFetchMoreElectronics);
  }

  Future<void> _onFetchElectronics(
      FetchElectronics event, Emitter<ElectronicsState> emit) async {
    _currentPage = 1; // Reset pagination on new fetch
    try {
      emit(ElectronicsLoading());
      final newElectronics =
          await getElectronicsUseCase(page: _currentPage, pageSize: _pageSize);

      emit(ElectronicsLoaded(
        electronics: newElectronics,
        hasReachedMax: newElectronics.length < _pageSize,
      ));

      _currentPage++;
    } catch (e) {
      emit(ElectronicsError(e.toString()));
    }
  }

  Future<void> _onFetchMoreElectronics(
      FetchMoreElectronics event, Emitter<ElectronicsState> emit) async {
    if (state is ElectronicsLoaded) {
      final currentState = state as ElectronicsLoaded;

      // Prevent redundant API calls
      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true; // Mark as fetching

      try {
        final electronics =
            await getElectronicsUseCase(page: _currentPage, pageSize: _pageSize);
        print(
            "Fetched ${electronics.length} electronics. hasReachedMax: ${electronics.length < _pageSize}");

        if (electronics.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true)); // No more data
        } else {
          emit(currentState.copyWith(
            electronics: currentState.electronics + electronics,
            hasReachedMax: electronics.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(ElectronicsPaginationError(e.toString()));
      } finally {
        _isFetching = false; // Mark as not fetching
      }
    }
  }
}
