import 'package:dio/dio.dart';

import 'package:silesra/features/Fashion/data/model/fashion_model.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';
import 'package:silesra/core/config/settings.dart';

abstract class FashionRemoteDataSource {
  Future<List<FashionModel>> getFashions();
  Future<FashionModel> getFashionById(String id);
  Future<void> addFashion(FashionModel fashion);
  Future<void> updateFashion(FashionModel fashion);
  Future<void> deleteFashion(String id);
}

class FashionRemoteDataSourceImpl implements FashionRemoteDataSource {
  final Dio dio;
  BaseService<FashionModel> baseService;
  FashionRemoteDataSourceImpl({required this.dio, required this.baseService});

  @override
  Future<List<FashionModel>> getFashions(
      {int page = 1, int pageSize = 10}) async {
    print(
        " %%%%%%%%%%%%%%%%%%%%%%%   Backe end called with $page and $pageSize");
    final response = await baseService.getRequestModelData(
      'fashion', // No query parameters here
      page: page,
      pageSize: pageSize,
    );

    final data = (response.data['data'] as List)
        .map((e) => FashionModel.from_dict(e))
        .toList();

    await updateImages('fashion', data);
    return data;
  }

  @override
  Future<FashionModel> getFashionById(String id) async {
    final response = await dio.get('/fashions/$id');
    return FashionModel.from_dict(response.data);
  }

  @override
  Future<void> addFashion(FashionModel fashion) async {
    final response =
        await dio.post('$baseUrl/fashion/', data: fashion.to_dict());
    return response.data;
  }

  @override
  Future<void> updateFashion(FashionModel fashion) async {
    await dio.put('$baseUrl/fashions/${fashion.id}', data: fashion.to_dict());
  }

  @override
  Future<void> deleteFashion(String id) async {
    await dio.delete('$baseUrl/fashions/$id');
  }
}
