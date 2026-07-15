// ServiceOrBusinessType Entity
import 'package:silesra/features/Service/data/model/service_model.dart';

class ServiceOrBusinessTypeEntity {
  final String? id;
  final String name;
  final String? busienssOrServiceType;
  final String? businessLocation;
  final String? title;
  final double payment;
  final String? description;
  final List<String>? serviceImage;

  ServiceOrBusinessTypeEntity({
    this.id,
    required this.name,
    this.busienssOrServiceType,
    this.businessLocation,
    this.title,
    required this.payment,
    this.description,
    this.serviceImage,
  });
}

// ServiceOrBusinessType Repository Interface
abstract class ServiceOrBusinessTypeRepository {
  Future<List<ServiceOrBusinessType>> getServiceOrBusinessTypes({required int page, required int pageSize});
  Future<ServiceOrBusinessType> getServiceOrBusinessTypeById(String id);
  Future<void> addServiceOrBusinessType(
      ServiceOrBusinessType serviceOrBusinessType);
  Future<void> updateServiceOrBusinessType(
      ServiceOrBusinessTypeEntity serviceOrBusinessType);
  Future<void> deleteServiceOrBusinessType(String id);
}

// Use Cases
class GetServiceOrBusinessTypes {
  final ServiceOrBusinessTypeRepository repository;

  GetServiceOrBusinessTypes(this.repository);

  Future<List<ServiceOrBusinessType>> call( {required int page, required int pageSize}) async {
    return await repository.getServiceOrBusinessTypes(page: page, pageSize: pageSize);
  }
}

class GetServiceOrBusinessTypeById {
  final ServiceOrBusinessTypeRepository repository;

  GetServiceOrBusinessTypeById(this.repository);

  Future<ServiceOrBusinessType> call(String id) async {
    return await repository.getServiceOrBusinessTypeById(id);
  }
}

class AddServiceOrBusinessType {
  final ServiceOrBusinessTypeRepository repository;

  AddServiceOrBusinessType(this.repository);

  Future<void> call(ServiceOrBusinessType serviceOrBusinessType) async {
    return await repository.addServiceOrBusinessType(serviceOrBusinessType);
  }
}

class UpdateServiceOrBusinessType {
  final ServiceOrBusinessTypeRepository repository;

  UpdateServiceOrBusinessType(this.repository);

  Future<void> call(ServiceOrBusinessTypeEntity serviceOrBusinessType) async {
    return await repository.updateServiceOrBusinessType(serviceOrBusinessType);
  }
}

class DeleteServiceOrBusinessType {
  final ServiceOrBusinessTypeRepository repository;

  DeleteServiceOrBusinessType(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteServiceOrBusinessType(id);
  }
}
