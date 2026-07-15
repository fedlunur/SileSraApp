import 'package:silesra/features/Fashion/data/model/fashion_model.dart';
import 'package:silesra/features/Fashion/domain/fashion_domain.dart';

class GetFashionsUseCase {
  final FashionRepository repository;

  GetFashionsUseCase({required this.repository});

  Future<List<FashionModel>> call({required int page, required int pageSize}) async {
    return await repository.getFashions(page: page, pageSize: pageSize);
  }
}


  

