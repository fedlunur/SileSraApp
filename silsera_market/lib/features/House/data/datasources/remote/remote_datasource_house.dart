// import 'dart:convert';
// import 'package:http/http.dart' as http;
// ignore_for_file: prefer_interpolation_to_compose_strings


import 'package:silesra/core/config/settings.dart';
import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:dio/dio.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';

// House Remote Data Source
abstract class HouseRemoteDataSource {
  Future<List<HouseModel>> getHouses(
      {required int page, required int pageSize});
  Future<HouseModel> getHouseById(String id);
  Future<void> addHouse(HouseModel house);
  Future<void> updateHouse(HouseModel house);
  Future<void> deleteHouse(String id);
}

class HouseRemoteDataSourceImpl implements HouseRemoteDataSource {
  final Dio dio;
  BaseService<HouseModel> baseService;
  HouseRemoteDataSourceImpl({required this.dio, required this.baseService});

  @override
  Future<List<HouseModel>> getHouses({int page = 1, int pageSize = 10}) async {
    final response = await baseService.getRequestModelData(
      'house', // No query parameters here
      page: page,
      pageSize: pageSize,
    );

    final houses = (response.data['data'] as List)
        .map((e) => HouseModel.fromJson(e))
        .toList();

    await updateImages('houses', houses);
    return houses;
  }

  @override
  Future<HouseModel> getHouseById(String id) async {
    final response = await dio.get('$baseUrl/house/$id');
    return HouseModel.fromJson(response.data);
  }

  @override
  Future<void> addHouse(HouseModel house) async {
    await dio.post('$baseUrl/house/', data: house.to_dict());
  }

  @override
  Future<void> updateHouse(HouseModel house) async {
    await dio.put('$baseUrl/house/${house.area}', data: house.to_dict());
  }

  @override
  Future<void> deleteHouse(String id) async {
    await dio.delete('$baseUrl/house/$id');
  }
}
