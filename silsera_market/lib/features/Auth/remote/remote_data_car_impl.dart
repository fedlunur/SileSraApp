import 'package:dio/dio.dart';

import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Cars/domain/entity/car_entitiy.dart';
import 'package:silesra/core/config/settings.dart';

abstract class CarRemoteDataSource {
  Future<List<CarModel>> getCars();
  Future<CarModel> getCarById(String id);
  Future<void> addCar(CarModel car);
  Future<void> updateCar(Car car);
  Future<void> deleteCar(String id);
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final Dio dio;

  CarRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CarModel>> getCars() async {
    // print('$baseUrl/car');
    final response = await dio.get(baseUrl + '/car');
    print(response.data);
    return (response.data['result'] as List)
        .map((e) => CarModel.from_dict(e))
        .toList();
  }

  @override
  Future<CarModel> getCarById(String id) async {
    final response = await dio.get('/cars/$id');
    return CarModel.from_dict(response.data);
  }

  @override
  Future<void> addCar(CarModel car) async {
    final response = await dio.post('http://188.245.105.29:8888/api/car/',
        data: car.to_dict());
    return response.data;
  }

  @override
  Future<void> updateCar(Car car) async {
    await dio.put('$baseUrl/cars/${car.id}', data: car.toJson());
  }

  @override
  Future<void> deleteCar(String id) async {
    await dio.delete('$baseUrl/cars/$id');
  }
}
