// House Repository Interface
import 'package:silesra/features/House/data/model/house_model.dart';

abstract class HouseRepository {
  Future<List<HouseModel>> getHouses({required int page, required int pageSize});
  Future<HouseModel> getHouseById(String id);
  Future<void> addHouse(HouseModel house);
  Future<void> updateHouse(HouseModel house);
  Future<void> deleteHouse(String id);
}
