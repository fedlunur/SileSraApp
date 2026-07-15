// Remote Data Source
import 'package:dio/dio.dart';

import 'package:silesra/features/Accessory/data/accessory_model.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';

// Remote Data Source
// Remote Data Source

// Remote Data Source

abstract class AccessoryRemoteDataSource {
  Future<List<AccessoryModel>> getAccessories({int page, int pageSize});
}

class AccessoryRemoteDataSourceImpl implements AccessoryRemoteDataSource {
  final Dio dio;
  final BaseService<AccessoryModel> baseService;

  AccessoryRemoteDataSourceImpl({required this.dio, required this.baseService});

  @override
  Future<List<AccessoryModel>> getAccessories(
      {int page = 1, int pageSize = 10}) async {
    try {
      final response = await baseService.getRequestModelData(
        'accessory', // Endpoint for accessories
        page: page,
        pageSize: pageSize,
      );

      // Parse the response data into a list of AccessoryModel
      final accessories = (response.data['data'] as List)
          .map((json) => AccessoryModel.fromJson(json))
          .toList();

      // Update images for the fetched accessories
      await updateImages('Accessory', accessories);

      return accessories;
    } catch (e) {
      throw Exception('Failed to fetch accessories: $e');
    }
  }
}
