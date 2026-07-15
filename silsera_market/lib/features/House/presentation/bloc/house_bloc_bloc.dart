import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/House/domain/usecase/get_house_by_id.dart';
import 'package:silesra/features/House/domain/usecase/house_getusecase.dart';
import 'package:silesra/features/House/domain/usecase/the_rest_house_usecase.dart';
import 'package:silesra/features/House/presentation/bloc/house_bloc_event.dart';
import 'package:silesra/features/House/presentation/bloc/house_bloc_state.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  final GetHouses getHouses;
  final GetHouseById getHouseById;
  final AddHouse addHouse;
  final UpdateHouse updateHouse;
  final DeleteHouse deleteHouse;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false; // Track whether a request is in progress

  HouseBloc({
    required this.getHouses,
    required this.getHouseById,
    required this.addHouse,
    required this.updateHouse,
    required this.deleteHouse,
  }) : super(HouseInitial()) {
    on<FetchHouses>(_onFetchHouses);
    on<FetchMoreHouses>(_onFetchMoreHouses);
    on<FetchHouseById>(_onFetchHouseById);
  }

  Future<void> _onFetchHouses(
      FetchHouses event, Emitter<HouseState> emit) async {
    _currentPage = 1; // Reset pagination on new fetch
    try {
      emit(HouseLoading());
      final newHouses =
          await getHouses(page: _currentPage, pageSize: _pageSize);

      emit(HouseLoaded(
        houses: newHouses,
        hasReachedMax: newHouses.length < _pageSize,
      ));

      _currentPage++;
    } catch (e) {
      emit(HousePaginationError(e.toString()));
    }
  }

  Future<void> _onFetchMoreHouses(
      FetchMoreHouses event, Emitter<HouseState> emit) async {
    if (state is HouseLoaded) {
      final currentState = state as HouseLoaded;

      // Prevent redundant API calls
      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true; // Mark as fetching

      try {
        final houses = await getHouses(page: _currentPage, pageSize: _pageSize);
        print(
            "Fetched ${houses.length} houses. hasReachedMax: ${houses.length < _pageSize}");

        if (houses.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true)); // No more data
        } else {
          emit(currentState.copyWith(
            houses: currentState.houses + houses,
            hasReachedMax: houses.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(HousePaginationError(e.toString()));
      } finally {
        _isFetching = false; // Mark as not fetching
      }
    }
  }

  Future<void> _onFetchHouseById(
      FetchHouseById event, Emitter<HouseState> emit) async {
    try {
      emit(HouseLoading());
      final house = await getHouseById(event.id);
      emit(HouseDetailLoaded(house)); // ✅ Fixed missing parameter
    } catch (e) {
      emit(HouseError(e.toString()));
    }
  }
}
