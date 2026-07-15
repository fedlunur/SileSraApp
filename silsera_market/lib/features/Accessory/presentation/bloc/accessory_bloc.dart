import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/Accessory/data/accessory_model.dart';
import 'package:silesra/features/Accessory/domain/accessory_domain.dart';

part 'accessory_event.dart';
part 'accessory_state.dart';

class AccessoryBloc extends Bloc<AccessoryEvent, AccessoryState> {
  final GetAccessoryUseCase getAccessoryUseCase;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false; // Track whether a request is in progress

  AccessoryBloc({
    required this.getAccessoryUseCase,
  }) : super(AccessoryInitial()) {
    on<AccessoryFetchEvent>(_onAccessoryFetchEvent);
    on<FetchMoreAccessories>(_onFetchMoreAccessories);
  }

  Future<void> _onAccessoryFetchEvent(
      AccessoryFetchEvent event, Emitter<AccessoryState> emit) async {
    _currentPage = 1; // Reset pagination on new fetch
    try {
      emit(AccessoryLoading());
      final accessories =
          await getAccessoryUseCase(page: _currentPage, pageSize: _pageSize);

      emit(AccessoryLoaded(
        accessories: accessories,
        hasReachedMax: accessories.length < _pageSize,
      ));

      _currentPage++;
    } catch (e) {
      emit(AccessoryError(e.toString()));
    }
  }

  Future<void> _onFetchMoreAccessories(
      FetchMoreAccessories event, Emitter<AccessoryState> emit) async {
    if (state is AccessoryLoaded) {
      final currentState = state as AccessoryLoaded;

      // Prevent redundant API calls
      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true; // Mark as fetching

      try {
        final accessories =
            await getAccessoryUseCase(page: _currentPage, pageSize: _pageSize);
        print(
            "Fetched ${accessories.length} accessories. hasReachedMax: ${accessories.length < _pageSize}");

        if (accessories.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true)); // No more data
        } else {
          emit(currentState.copyWith(
            accessories: currentState.accessories + accessories,
            hasReachedMax: accessories.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(AccessoryPaginationError(e.toString()));
      } finally {
        _isFetching = false; // Mark as not fetching
      }
    }
  }
}
