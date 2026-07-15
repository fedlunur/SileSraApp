import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Cars/data/remote/remote_data_car_impl.dart';
import 'package:silesra/features/Cars/domain/entity/car_entitiy.dart';

import 'package:silesra/features/Cars/domain/repositories/car_repository.dart';

class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource remoteDataSource;

  CarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CarModel>> getCars({int page = 1, int pageSize = 10}) async {
    return await remoteDataSource.getCars(page: page, pageSize: pageSize);
  }

  @override
  Future<CarModel> getCarById(String id) async {
    return await remoteDataSource.getCarById(id);
  }

  @override
  Future<void> addCar(CarModel car) async {
    return await remoteDataSource.addCar(car);
  }

  @override
  Future<void> deleteCar(String id) async {
    return await remoteDataSource.deleteCar(id);
  }

  @override
  Future<void> updateCar(Car car) {
    // TODO: implement updateCar
    throw UnimplementedError();
  }
}
