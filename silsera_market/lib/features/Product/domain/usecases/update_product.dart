import 'package:dartz/dartz.dart';
import 'package:silesra/core/errors%20copy/failure.dart';
import 'package:silesra/features/Product/domain/entities/product_entitiy.dart';
import 'package:silesra/features/Product/domain/repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';


class UpdateProductUseCase implements UseCase<Future<Either<Failure, Product>>, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.product, params.id);
  }
}

class UpdateProductParams {
  final Product product;
  final String id;

  UpdateProductParams({required this.product, required this.id});
}
