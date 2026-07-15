import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:silesra/features/House/domain/repo/house_repo.dart';

class GetHouses {
  final HouseRepository repository;

  GetHouses(this.repository);

  Future<List<HouseModel>> call({required int page, required int pageSize}) async {
    return await repository.getHouses(page: page, pageSize: pageSize);
  }
}

