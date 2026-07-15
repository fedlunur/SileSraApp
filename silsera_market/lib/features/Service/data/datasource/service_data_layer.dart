// ServiceOrBusinessType Remote Data Source

import 'package:dio/dio.dart';
import 'package:silesra/features/POST/BaseService.dart';

import 'package:silesra/features/POST/download_image.dart';
import 'package:silesra/features/Service/data/model/service_model.dart';
import 'package:silesra/features/Service/domain/service_domain_layer.dart';

abstract class ServiceOrBusinessTypeRemoteDataSource {
  Future<List<ServiceOrBusinessType>> getServiceOrBusinessTypes();
  Future<ServiceOrBusinessType> getServiceOrBusinessTypeById(String id);
  Future<void> addServiceOrBusinessType(
      ServiceOrBusinessType serviceOrBusinessType);
  Future<void> updateServiceOrBusinessType(
      ServiceOrBusinessTypeEntity serviceOrBusinessType);
  Future<void> deleteServiceOrBusinessType(String id);
}

class ServiceOrBusinessTypeRemoteDataSourceImpl
    implements ServiceOrBusinessTypeRemoteDataSource {
  final Dio dio;
  BaseService<ServiceOrBusinessType> baseService;
  ServiceOrBusinessTypeRemoteDataSourceImpl(
      {required this.dio, required this.baseService});

  @override
  Future<List<ServiceOrBusinessType>> getServiceOrBusinessTypes(
      {int page = 1, int pageSize = 10}) async {
    print(" XXXXXXXX   Fetched Service Data $page and $pageSize");
    final response = await baseService.getRequestModelData(
      'service', // No query parameters here
      page: page,
      pageSize: pageSize,
    );
    final res = (response.data['data'] as List)
        .map((e) => ServiceOrBusinessType.from_dict(e))
        .toList();

    await updateImages('service', res);
    return res;
  }

  @override
  Future<ServiceOrBusinessType> getServiceOrBusinessTypeById(String id) async {
    final response = await dio.get('/service/$id');
    return ServiceOrBusinessType.from_dict(response.data);
  }

  @override
  Future<void> addServiceOrBusinessType(
      ServiceOrBusinessType serviceOrBusinessType) async {
    await dio.post('/service', data: serviceOrBusinessType.to_dict());
  }

  @override
  Future<void> updateServiceOrBusinessType(
      ServiceOrBusinessTypeEntity serviceOrBusinessType) async {
    await dio.put('/service/${serviceOrBusinessType.id}',
        data: serviceOrBusinessType.toString());
  }

  @override
  Future<void> deleteServiceOrBusinessType(String id) async {
    await dio.delete('/service/$id');
  }
}

// ServiceOrBusinessType Repository Implementation
class ServiceOrBusinessTypeRepositoryImpl
    implements ServiceOrBusinessTypeRepository {
  final ServiceOrBusinessTypeRemoteDataSource remoteDataSource;

  ServiceOrBusinessTypeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ServiceOrBusinessType> getServiceOrBusinessTypeById(String id) async {
    return await remoteDataSource.getServiceOrBusinessTypeById(id);
  }

  @override
  Future<void> addServiceOrBusinessType(
      ServiceOrBusinessType serviceOrBusinessType) async {
    return await remoteDataSource
        .addServiceOrBusinessType(serviceOrBusinessType);
  }

  @override
  Future<void> updateServiceOrBusinessType(
      ServiceOrBusinessTypeEntity serviceOrBusinessType) async {
    return await remoteDataSource
        .updateServiceOrBusinessType(serviceOrBusinessType);
  }

  @override
  Future<void> deleteServiceOrBusinessType(String id) async {
    return await remoteDataSource.deleteServiceOrBusinessType(id);
  }

  @override
  Future<List<ServiceOrBusinessType>> getServiceOrBusinessTypes(
      {required int page, required int pageSize}) {
    return remoteDataSource.getServiceOrBusinessTypes();
  }
}
