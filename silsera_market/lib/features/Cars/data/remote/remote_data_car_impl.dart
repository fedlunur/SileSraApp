import 'package:dio/dio.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Cars/domain/entity/car_entitiy.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';

abstract class CarRemoteDataSource {
  Future<List<CarModel>> getCars({required int page, required int pageSize});
  Future<CarModel> getCarById(String id);
  Future<void> addCar(CarModel car);
  Future<void> updateCar(Car car);
  Future<void> deleteCar(String id);
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final Dio dio;
  BaseService<CarModel> baseService;
  CarRemoteDataSourceImpl({required this.dio, required this.baseService});

  @override
  Future<List<CarModel>> getCars({int page = 1, int pageSize = 10}) async {
    final response = await baseService.getRequestModelData(
      'car', // No query parameters here
      page: page,
      pageSize: pageSize,
    );

    final houses = (response.data['data'] as List)
        .map((e) => CarModel.from_dict(e))
        .toList();

    await updateImages('houses', houses);
    return houses;
  }

  @override
  Future<CarModel> getCarById(String id) async {
    final response = await dio.get('/cars/$id');
    return CarModel.from_dict(response.data);
  }

  @override
  Future<void> addCar(CarModel car) async {
    final response = await dio.post('$baseUrl/car/', data: car.to_dict());
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
