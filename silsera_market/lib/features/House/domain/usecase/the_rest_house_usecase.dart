import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:silesra/features/House/domain/repo/house_repo.dart';

class AddHouse {
  final HouseRepository repository;

  AddHouse(this.repository);

  Future<void> call(HouseModel house) async {
    return await repository.addHouse(house);
  }
}

class UpdateHouse {
  final HouseRepository repository;

  UpdateHouse(this.repository);

  Future<void> call(HouseModel house) async {
    return await repository.updateHouse(house);
  }
}

class DeleteHouse {
  final HouseRepository repository;

  DeleteHouse(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteHouse(id);
  }
}
