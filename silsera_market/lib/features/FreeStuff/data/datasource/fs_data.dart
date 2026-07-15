// FreeStaffOrItem Remote Data Source
import 'package:dio/dio.dart';
import 'package:silesra/features/FreeStuff/data/model/free_stuff_model.dart';

import 'package:silesra/core/config/settings.dart';
import 'package:silesra/features/FreeStuff/domain/free_stuff_domain.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';

abstract class FreeStaffOrItemRemoteDataSource {
  Future<List<FreeStaffOrItem>> getFreeStaffOrItems();
  Future<FreeStaffOrItem> getFreeStaffOrItemById(String id);
  Future<void> addFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem);
  Future<void> updateFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem);
  Future<void> deleteFreeStaffOrItem(String id);
}

class FreeStaffOrItemRemoteDataSourceImpl
    implements FreeStaffOrItemRemoteDataSource {
  final Dio dio;
  BaseService<FreeStaffOrItem> baseService;
  FreeStaffOrItemRemoteDataSourceImpl(
      {required this.dio, required this.baseService});

  @override
  Future<List<FreeStaffOrItem>> getFreeStaffOrItems(
      {int page = 1, int pageSize = 10}) async {
    print(" XXXXXXXX   Fetched Service Data $page and $pageSize");
    final response = await baseService.getRequestModelData(
      'freestafforitem', // No query parameters here
      page: page,
      pageSize: pageSize,
    );

    final freestfs = (response.data['data'] as List)
        .map((e) => FreeStaffOrItem.from_dict(e))
        .toList();
    await updateImages('Freestafs', freestfs);
    return freestfs;
  }

  @override
  Future<FreeStaffOrItem> getFreeStaffOrItemById(String id) async {
    final response = await dio.get(baseUrl+ '/freestafforitem/$id');
    return FreeStaffOrItem.from_dict(response.data);
  }

  @override
  Future<void> addFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem) async {
    await dio.post('/freestafforitem', data: freeStaffOrItem.to_dict());
  }

  @override
  Future<void> updateFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem) async {
    await dio.put('/freestafforitem/${freeStaffOrItem.id}',
        data: freeStaffOrItem.to_dict());
  }

  @override
  Future<void> deleteFreeStaffOrItem(String id) async {
    await dio.delete('/freestafforitem/$id');
  }
}

// // FreeStaffOrItem Repository Implementation
// abstract class FreeStaffOrItemRepository {
//   Future<List<FreeStaffOrItem>> getFreeStaffOrItems();
//   Future<FreeStaffOrItem> getFreeStaffOrItemById(String id);
//   Future<void> addFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem);
//   Future<void> updateFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem);
//   Future<void> deleteFreeStaffOrItem(String id);
// }

class FreeStaffOrItemRepositoryImpl implements FreeStaffOrItemRepository {
  final FreeStaffOrItemRemoteDataSource remoteDataSource;

  FreeStaffOrItemRepositoryImpl({required this.remoteDataSource});

  // @override
  // Future<List<FreeStaffOrItem>> getFreeStaffOrItems() async {
  //   return await remoteDataSource.getFreeStaffOrItems();
  // }

  @override
  Future<FreeStaffOrItem> getFreeStaffOrItemById(String id) async {
    return await remoteDataSource.getFreeStaffOrItemById(id);
  }

  @override
  Future<void> addFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem) async {
    return await remoteDataSource.addFreeStaffOrItem(freeStaffOrItem);
  }

  @override
  Future<void> updateFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem) async {
    return await remoteDataSource.updateFreeStaffOrItem(freeStaffOrItem);
  }

  @override
  Future<void> deleteFreeStaffOrItem(String id) async {
    return await remoteDataSource.deleteFreeStaffOrItem(id);
  }

  @override
  Future<List<FreeStaffOrItem>> getFreeStaffOrItems(
      {required int page, required int pageSize}) async {
    return await remoteDataSource.getFreeStaffOrItems();
  }
}
