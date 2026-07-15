import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Cars/domain/entity/car_entitiy.dart';

abstract class CarRepository {
  Future<List<CarModel>> getCars({required int page, required int pageSize});
  Future<CarModel> getCarById(String id);
  Future<void> addCar(CarModel car);
  Future<void> updateCar(Car car);
  Future<void> deleteCar(String id);
}
