import 'package:dartz/dartz.dart';
import 'package:silesra/core/errors%20copy/failure.dart';
import 'package:silesra/core/usecases/no_param_use_cases.dart';
import 'package:silesra/features/Product/domain/entities/product_entitiy.dart';
import 'package:silesra/features/Product/domain/repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';


class GetProductsUseCase implements UseCase<Future<Either<Failure, List<Product>>>, NoParamsUseCase> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParamsUseCase params) async {
    return await repository.getProducts();
  }
}