import 'package:dartz/dartz.dart';
import 'package:silesra/core/errors%20copy/failure.dart';
import 'package:silesra/features/Product/domain/entities/product_entitiy.dart';
import 'package:silesra/features/Product/domain/usecases/get_generic_list.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:silesra/features/Product/domain/repositories/product_repository.dart';

class SearchGenericProductsUseCase
    implements UseCase<Future<Either<Failure, List<Product>>>, ParamsUseCase> {
  final ProductRepository repository;

  SearchGenericProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(ParamsUseCase params) async {
    return await repository.searchGenericProducts(
        params.query ?? '', params.modelName ?? '');
  }
}
