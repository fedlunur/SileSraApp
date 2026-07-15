import 'package:silesra/features/Electronics/data/model/electronics_model.dart';
import 'package:silesra/features/Electronics/domain/repo/electronics_domain.dart';

class GetElectronicsUseCase {
  final ElectronicsRepository repository;

  GetElectronicsUseCase({required this.repository});

  Future<List<ElectronicsModel>> call({required int page, required int pageSize}) async {
    return await repository.getElectronics(page: page, pageSize: pageSize);
  }
}