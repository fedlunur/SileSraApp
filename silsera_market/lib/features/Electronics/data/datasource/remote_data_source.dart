import 'package:dio/dio.dart';

import 'package:silesra/features/Electronics/data/model/electronics_model.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';
import 'package:silesra/core/config/settings.dart';

abstract class ElectronicsRemoteDataSource {
  Future<List<ElectronicsModel>> getElectronics();
  Future<ElectronicsModel> getElectronicsById(String id);
  Future<void> addElectronics(ElectronicsModel electronics);
  Future<void> updateElectronics(ElectronicsModel electronics);
  Future<void> deleteElectronics(String id);
}

class ElectronicsRemoteDataSourceImpl implements ElectronicsRemoteDataSource {
  final Dio dio;
  BaseService<ElectronicsModel> baseService;
  ElectronicsRemoteDataSourceImpl(
      {required this.dio, required this.baseService});

  @override
  Future<List<ElectronicsModel>> getElectronics(
      {int page = 1, int pageSize = 10}) async {
    print("%%%%%%  Electonics back end with $page and $parseColor(rgba)");
    final response = await baseService.getRequestModelData(
      'electronics', // No query parameters here
      page: page,
      pageSize: pageSize,
    );

    final eldata = (response.data['data'] as List)
        .map((e) => ElectronicsModel.from_dict(e))
        .toList();

    await updateImages('electronics', eldata);
    return eldata;
  }

  @override
  Future<ElectronicsModel> getElectronicsById(String id) async {
    final response = await dio.get('/electronics/$id');
    return ElectronicsModel.from_dict(response.data);
  }

  @override
  Future<void> addElectronics(ElectronicsModel electronics) async {
    final response =
        await dio.post('$baseUrl/electronics/', data: electronics.to_dict());
    return response.data;
  }

  @override
  Future<void> updateElectronics(ElectronicsModel electronics) async {
    await dio.put('$baseUrl/electronics/${electronics.id}',
        data: electronics.to_dict());
  }

  @override
  Future<void> deleteElectronics(String id) async {
    await dio.delete('$baseUrl/electronics/$id');
  }
}
