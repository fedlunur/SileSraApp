import 'package:silesra/features/Fashion/data/model/fashion_model.dart';
import 'package:silesra/features/Fashion/data/remote/remote_data_source.dart';

abstract class FashionRepository {
  Future<List<FashionModel>> getFashions(
      {required int page, required int pageSize});
  Future<FashionModel> getFashionById(String id);
  Future<void> addFashion(FashionModel fashion);
  Future<void> updateFashion(FashionModel fashion);
  Future<void> deleteFashion(String id);
}

class FashionRepositoryImpl implements FashionRepository {
  final FashionRemoteDataSource remoteDataSource;

  FashionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FashionModel>> getFashions(
      {int page = 1, int pageSize = 10}) async {
    

    return await remoteDataSource.getFashions();
  }

  @override
  Future<void> addFashion(FashionModel fashion) {
    // TODO: implement addFashion
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFashion(String id) {
    // TODO: implement deleteFashion
    throw UnimplementedError();
  }

  @override
  Future<FashionModel> getFashionById(String id) {
    // TODO: implement getFashionById
    throw UnimplementedError();
  }

  @override
  Future<void> updateFashion(FashionModel fashion) {
    // TODO: implement updateFashion
    throw UnimplementedError();
  }
}
