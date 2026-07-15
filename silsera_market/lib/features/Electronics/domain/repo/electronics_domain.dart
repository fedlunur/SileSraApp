import 'package:silesra/features/Electronics/data/datasource/remote_data_source.dart';
import 'package:silesra/features/Electronics/data/model/electronics_model.dart';

abstract class ElectronicsRepository {
  Future<List<ElectronicsModel>> getElectronics({required int page, required int pageSize});
  Future<ElectronicsModel> getElectronicsById(String id);
  Future<void> addElectronics(ElectronicsModel electronics);
  Future<void> updateElectronics(ElectronicsModel electronics);
  Future<void> deleteElectronics(String id);
}

class ElectronicsRepositoryImpl implements ElectronicsRepository {
  final ElectronicsRemoteDataSource remoteDataSource;

  ElectronicsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ElectronicsModel>> getElectronics({int page = 1, int pageSize = 10}) async {
    return await remoteDataSource.getElectronics();
  }

  @override
  Future<ElectronicsModel> getElectronicsById(String id) async {
    return await remoteDataSource.getElectronicsById(id);
  }

  @override
  Future<void> addElectronics(ElectronicsModel electronics) async {
    return await remoteDataSource.addElectronics(electronics);
  }

  @override
  Future<void> updateElectronics(ElectronicsModel electronics) async {
    return await remoteDataSource.updateElectronics(electronics);
  }

  @override
  Future<void> deleteElectronics(String id) async {
    return await remoteDataSource.deleteElectronics(id);
  }
}
