import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/Cars/domain/entity/car_entitiy.dart';
import 'package:silesra/features/Cars/domain/usecases/car_usecase.dart';
import 'package:silesra/features/Cars/presentation/bloc/car_event.dart';
import 'package:silesra/features/Cars/presentation/bloc/car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final GetCars getCars;
  final GetCarById getCarById;
  final AddCar addCar;
  final UpdateCar updateCar;
  final DeleteCar deleteCar;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false; // Track whether a request is in progress

  CarBloc({
    required this.getCars,
    required this.getCarById,
    required this.addCar,
    required this.updateCar,
    required this.deleteCar,
  }) : super(CarInitial()) {
    on<FetchCars>(_onFetchCars);
    on<FetchMoreCars>(_onFetchMoreCars);
    on<FetchCarById>(_onFetchCarById);
    on<AddCarEvent>(_onAddCar);
    on<UpdateCarEvent>(_onUpdateCar);
    on<DeleteCarEvent>(_onDeleteCar);
  }

  Future<void> _onFetchCars(FetchCars event, Emitter<CarState> emit) async {
    _currentPage = 1; // Reset pagination on new fetch
    try {
      emit(CarLoading());
      final newCars = await getCars(page: _currentPage, pageSize: _pageSize);

      emit(CarLoaded(
        cars: newCars,
        hasReachedMax: newCars.length < _pageSize,
      ));

      _currentPage++;
    } catch (e) {
      emit(CarPaginationError(e.toString()));
    }
  }

  Future<void> _onFetchMoreCars(
      FetchMoreCars event, Emitter<CarState> emit) async {
    if (state is CarLoaded) {
      final currentState = state as CarLoaded;

      // Prevent redundant API calls
      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true; // Mark as fetching

      try {
        final cars = await getCars(page: _currentPage, pageSize: _pageSize);
        print(
            "Fetched ${cars.length} cars. hasReachedMax: ${cars.length < _pageSize}");

        if (cars.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true)); // No more data
        } else {
          emit(currentState.copyWith(
            cars: currentState.cars + cars,
            hasReachedMax: cars.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(CarPaginationError(e.toString()));
      } finally {
        _isFetching = false; // Mark as not fetching
      }
    }
  }

  Future<void> _onFetchCarById(
      FetchCarById event, Emitter<CarState> emit) async {
    try {
      emit(CarLoading());
      final car = await getCarById(event.id);
      emit(CarDetailLoaded(car)); // ✅ Fixed missing parameter
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onAddCar(AddCarEvent event, Emitter<CarState> emit) async {
    try {
      emit(CarLoading());
      await addCar(event.car);
      emit(CarOperationSuccess());
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onUpdateCar(UpdateCarEvent event, Emitter<CarState> emit) async {
    try {
      emit(CarLoading());
      await updateCar(event.car as Car);
      emit(CarOperationSuccess());
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onDeleteCar(DeleteCarEvent event, Emitter<CarState> emit) async {
    try {
      emit(CarLoading());
      await deleteCar(event.id);
      emit(CarOperationSuccess());
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }
}
