import 'package:dartz/dartz.dart';
import 'package:silesra/core/errors%20copy/failure.dart';
import 'package:silesra/features/Product/domain/entities/product_entitiy.dart';
import 'package:silesra/features/Product/domain/repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';


class CreateProductUseCase implements UseCase<Future<Either<Failure, Product>>, Product> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(Product product) async {
    return await repository.createProduct(product);
  }
}
