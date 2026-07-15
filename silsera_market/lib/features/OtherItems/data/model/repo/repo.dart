import 'package:silesra/features/OtherItems/data/datasource/remotedatasource.dart';
import 'package:silesra/features/OtherItems/data/model/otheritem_model.dart';

abstract class OtherItemRepository {
  Future<List<OtherItem>> getOtherItems({required int page, required int pageSize});
  Future<OtherItem> getOtherItemById(String id);
  Future<void> addOtherItem(OtherItem otherItem);
  Future<void> updateOtherItem(OtherItem otherItem);
  Future<void> deleteOtherItem(String id);
}

class OtherItemRepositoryImpl implements OtherItemRepository {
  final OtherItemRemoteDataSource remoteDataSource;

  OtherItemRepositoryImpl({required this.remoteDataSource});

  // @override
  // Future<List<OtherItem>> getOtherItems() async {
  //   return await remoteDataSource.getOtherItems();
  // }

  @override
  Future<OtherItem> getOtherItemById(String id) async {
    return await remoteDataSource.getOtherItemById(id);
  }

  @override
  Future<void> addOtherItem(OtherItem otherItem) async {
    return await remoteDataSource.addOtherItem(otherItem);
  }

  @override
  Future<void> updateOtherItem(OtherItem otherItem) async {
    return await remoteDataSource.updateOtherItem(otherItem);
  }

  @override
  Future<void> deleteOtherItem(String id) async {
    return await remoteDataSource.deleteOtherItem(id);
  }
  
  @override
  Future<List<OtherItem>> getOtherItems({required int page, required int pageSize}) async {
    // TODO: implement getOtherItems
   return await remoteDataSource.getOtherItems();
  }
}