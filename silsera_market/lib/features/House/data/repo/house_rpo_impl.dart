import 'package:silesra/features/House/data/datasources/remote/remote_datasource_house.dart';
import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:silesra/features/House/domain/repo/house_repo.dart';

class HouseRepositoryImpl implements HouseRepository {
  final HouseRemoteDataSource remoteDataSource;

  HouseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HouseModel>> getHouses({int page = 1, int pageSize = 10}) async {
    return await remoteDataSource.getHouses(page: page, pageSize: pageSize);
  }

  @override
  Future<HouseModel> getHouseById(String id) async {
    return await remoteDataSource.getHouseById(id);
  }

  @override
  Future<void> addHouse(HouseModel house) async {
    return await remoteDataSource.addHouse(house);
  }

  @override
  Future<void> updateHouse(HouseModel house) async {
    return await remoteDataSource.updateHouse(house);
  }

  @override
  Future<void> deleteHouse(String id) async {
    return await remoteDataSource.deleteHouse(id);
  }
}
