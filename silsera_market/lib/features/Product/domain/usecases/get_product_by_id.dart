import 'package:dartz/dartz.dart';
import 'package:silesra/core/errors%20copy/failure.dart';
import 'package:silesra/features/Product/domain/entities/product_entitiy.dart';
import 'package:silesra/features/Product/domain/repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';


class GetProductByIdUseCase implements UseCase<Future<Either<Failure, Product>>, String> {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(String id) async {
    return await repository.getProductById(id);
  }
}
