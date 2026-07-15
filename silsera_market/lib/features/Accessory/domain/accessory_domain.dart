// Use Case
import 'package:silesra/features/Accessory/data/accessory_data.dart';
import 'package:silesra/features/Accessory/data/accessory_model.dart';

class GetAccessoryUseCase {
  final AccessoryRemoteDataSourceImpl repository;
  GetAccessoryUseCase( this.repository);

  Future<List<AccessoryModel>> call(
      {required int page, required int pageSize}) async {
    return await repository.getAccessories(page: page, pageSize: pageSize);
  }
}
