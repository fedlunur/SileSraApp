import 'package:dio/dio.dart';
import 'package:silesra/features/OtherItems/data/model/otheritem_model.dart';

import 'package:silesra/core/config/settings.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';

abstract class OtherItemRemoteDataSource {
  Future<List<OtherItem>> getOtherItems();
  Future<OtherItem> getOtherItemById(String id);
  Future<void> addOtherItem(OtherItem otherItem);
  Future<void> updateOtherItem(OtherItem otherItem);
  Future<void> deleteOtherItem(String id);
}

class OtherItemRemoteDataSourceImpl implements OtherItemRemoteDataSource {
  final Dio dio;
  BaseService<OtherItem> baseService;
  OtherItemRemoteDataSourceImpl({required this.dio, required this.baseService});

  @override
  Future<List<OtherItem>> getOtherItems(
      {int page = 1, int pageSize = 10}) async {
    final response = await baseService.getRequestModelData(
      'otheritem', // No query parameters here
      page: page,
      pageSize: pageSize,
    );

    final otherItems = (response.data['data'] as List)
        .map((e) => OtherItem.from_dict(e))
        .toList();
    await updateImages('Other', otherItems);

    return otherItems;
  }

  @override
  Future<OtherItem> getOtherItemById(String id) async {
    final response = await dio.get('$baseUrl/otheritem/$id');
    return OtherItem.from_dict(response.data);
  }

  @override
  Future<void> addOtherItem(OtherItem otherItem) async {
    await dio.post('$baseUrl/otheritem', data: otherItem.to_dict());
  }

  @override
  Future<void> updateOtherItem(OtherItem otherItem) async {
    await dio.put('$baseUrl/otheritem/${otherItem.id}',
        data: otherItem.to_dict());
  }

  @override
  Future<void> deleteOtherItem(String id) async {
    await dio.delete('$baseUrl/otheritem/$id');
  }
}
