// lib/data/datasources/car_data_source.dart
import 'package:silesra/features/Cars/data/models/car_model.dart';

abstract class CarDataSource {
  Future<List<CarModel>> getCars();
  Future<CarModel> getCarDetails(int id);
}
