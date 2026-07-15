// ServiceOrBusinessType Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/Service/data/model/service_model.dart';
import 'package:silesra/features/Service/domain/service_domain_layer.dart';

class ServiceOrBusinessTypeBloc extends Bloc<ServiceOrBusinessTypeEvent, ServiceOrBusinessTypeState> {
  final GetServiceOrBusinessTypes getServiceOrBusinessTypes;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false; // Track whether a request is in progress

  ServiceOrBusinessTypeBloc({required this.getServiceOrBusinessTypes})
      : super(ServiceOrBusinessTypeInitial()) {
    on<FetchServiceOrBusinessTypes>(_onFetchServiceOrBusinessTypes);
    on<FetchMoreServiceOrBusinessTypes>(_onFetchMoreServiceOrBusinessTypes);
  }

  Future<void> _onFetchServiceOrBusinessTypes(
      FetchServiceOrBusinessTypes event, Emitter<ServiceOrBusinessTypeState> emit) async {
    _currentPage = 1; // Reset pagination on new fetch
    try {
      emit(ServiceOrBusinessTypeLoading());
      final newServiceOrBusinessTypes =
          await getServiceOrBusinessTypes(page: _currentPage, pageSize: _pageSize);

      emit(ServiceOrBusinessTypeLoaded(
        serviceOrBusinessTypes: newServiceOrBusinessTypes,
        hasReachedMax: newServiceOrBusinessTypes.length < _pageSize,
      ));

      _currentPage++;
    } catch (e) {
      emit(ServiceOrBusinessTypeError(e.toString()));
    }
  }

  Future<void> _onFetchMoreServiceOrBusinessTypes(
      FetchMoreServiceOrBusinessTypes event, Emitter<ServiceOrBusinessTypeState> emit) async {
    if (state is ServiceOrBusinessTypeLoaded) {
      final currentState = state as ServiceOrBusinessTypeLoaded;

      // Prevent redundant API calls
      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true; // Mark as fetching

      try {
        final serviceOrBusinessTypes =
            await getServiceOrBusinessTypes(page: _currentPage, pageSize: _pageSize);
        print(
            "Fetched ${serviceOrBusinessTypes.length} serviceOrBusinessTypes. hasReachedMax: ${serviceOrBusinessTypes.length < _pageSize}");

        if (serviceOrBusinessTypes.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true)); // No more data
        } else {
          emit(currentState.copyWith(
            serviceOrBusinessTypes: currentState.serviceOrBusinessTypes + serviceOrBusinessTypes,
            hasReachedMax: serviceOrBusinessTypes.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(ServiceOrBusinessTypePaginationError(e.toString()));
      } finally {
        _isFetching = false; // Mark as not fetching
      }
    }
  }
}

// ServiceOrBusinessType Events and States
abstract class ServiceOrBusinessTypeEvent {}

class FetchServiceOrBusinessTypes extends ServiceOrBusinessTypeEvent {}

class FetchMoreServiceOrBusinessTypes extends ServiceOrBusinessTypeEvent {}


// Now states 
abstract class ServiceOrBusinessTypeState {}

class ServiceOrBusinessTypeInitial extends ServiceOrBusinessTypeState {}

class ServiceOrBusinessTypeLoading extends ServiceOrBusinessTypeState {}

class ServiceOrBusinessTypeLoaded extends ServiceOrBusinessTypeState {
  final List<ServiceOrBusinessType> serviceOrBusinessTypes;
  final bool hasReachedMax;

  ServiceOrBusinessTypeLoaded({
    required this.serviceOrBusinessTypes,
    this.hasReachedMax = false,
  });

  ServiceOrBusinessTypeLoaded copyWith({
    List<ServiceOrBusinessType>? serviceOrBusinessTypes,
    bool? hasReachedMax,
  }) {
    return ServiceOrBusinessTypeLoaded(
      serviceOrBusinessTypes: serviceOrBusinessTypes ?? this.serviceOrBusinessTypes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ServiceOrBusinessTypeDetailLoaded extends ServiceOrBusinessTypeState {
  final ServiceOrBusinessType serviceOrBusinessType;

  ServiceOrBusinessTypeDetailLoaded(this.serviceOrBusinessType);
}

class ServiceOrBusinessTypeOperationSuccess extends ServiceOrBusinessTypeState {}

class ServiceOrBusinessTypeError extends ServiceOrBusinessTypeState {
  final String message;

  ServiceOrBusinessTypeError(this.message);
}

class ServiceOrBusinessTypePaginationError extends ServiceOrBusinessTypeState {
  final String message;

  ServiceOrBusinessTypePaginationError(this.message);
}

