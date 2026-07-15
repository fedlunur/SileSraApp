import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:silesra/features/House/domain/repo/house_repo.dart';

class GetHouseById {
  final HouseRepository repository;

  GetHouseById(this.repository);

  Future<HouseModel> call(String id) async {
    return await repository.getHouseById(id);
  }
}
