import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Cars/domain/entity/car_entitiy.dart';
import 'package:silesra/features/Cars/domain/repositories/car_repository.dart';

class GetCars {
  final CarRepository repository;

  GetCars(this.repository);

  Future<List<CarModel>> call(
      {required int page, required int pageSize}) async {
    return await repository.getCars(page: page, pageSize: pageSize);
  }
}

class GetCarById {
  final CarRepository repository;

  GetCarById(this.repository);

  Future<CarModel> call(String id) async {
    return await repository.getCarById(id);
  }
}

class AddCar {
  final CarRepository repository;

  AddCar(this.repository);

  Future<void> call(CarModel car) async {
    return await repository.addCar(car);
  }
}

class UpdateCar {
  final CarRepository repository;

  UpdateCar(this.repository);

  Future<void> call(Car car) async {
    return await repository.updateCar(car);
  }
}

class DeleteCar {
  final CarRepository repository;

  DeleteCar(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteCar(id);
  }
}
