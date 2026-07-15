// LostOrFound Remote Data Source
import 'package:dio/dio.dart';
import 'package:silesra/features/LOF/data/model/lof_model.dart';
import 'package:silesra/features/LOF/domain/lof_domain.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';

abstract class LostOrFoundRemoteDataSource {
  Future<List<LostOrFound>> getLostOrFounds();
  Future<LostOrFound> getLostOrFoundById(String id);
  Future<void> addLostOrFound(LostOrFound lostOrFound);
  Future<void> updateLostOrFound(LostOrFound lostOrFound);
  Future<void> deleteLostOrFound(String id);
}

class LostOrFoundRemoteDataSourceImpl implements LostOrFoundRemoteDataSource {
  final Dio dio;
  BaseService<LostOrFound> baseService;
  LostOrFoundRemoteDataSourceImpl(
      {required this.dio, required this.baseService});

  @override
  Future<List<LostOrFound>> getLostOrFounds(
      {int page = 1, int pageSize = 10}) async {
    final response = await baseService.getRequestModelData(
      'lostorfoud', // No query parameters here
      page: page,
      pageSize: pageSize,
    );
    final res = (response.data['data'] as List)
        .map((e) => LostOrFound.from_dict(e))
        .toList();

    await updateImages('Lostorfound', res);
    print(res);
    return res;
  }

  @override
  Future<LostOrFound> getLostOrFoundById(String id) async {
    final response = await dio.get('/lostorfounds/$id');
    return LostOrFound.from_dict(response.data);
  }

  @override
  Future<void> addLostOrFound(LostOrFound lostOrFound) async {
    await dio.post('/lostorfounds', data: lostOrFound.to_dict());
  }

  @override
  Future<void> updateLostOrFound(LostOrFound lostOrFound) async {
    await dio.put('/lostorfounds/${lostOrFound.id}',
        data: lostOrFound.to_dict());
  }

  @override
  Future<void> deleteLostOrFound(String id) async {
    await dio.delete('/lostorfounds/$id');
  }
}

// LostOrFound Repository Implementation
class LostOrFoundRepositoryImpl implements LostOrFoundRepository {
  final LostOrFoundRemoteDataSource remoteDataSource;

  LostOrFoundRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LostOrFound> getLostOrFoundById(String id) async {
    return await remoteDataSource.getLostOrFoundById(id);
  }

  @override
  Future<void> addLostOrFound(LostOrFound lostOrFound) async {
    return await remoteDataSource.addLostOrFound(lostOrFound);
  }

  @override
  Future<void> updateLostOrFound(LostOrFound lostOrFound) async {
    return await remoteDataSource.updateLostOrFound(lostOrFound);
  }

  @override
  Future<void> deleteLostOrFound(String id) async {
    return await remoteDataSource.deleteLostOrFound(id);
  }

  @override
  Future<List<LostOrFound>> getLostOrFounds(
      {required int page, required int pageSize}) {
    return remoteDataSource.getLostOrFounds();
  }
}
