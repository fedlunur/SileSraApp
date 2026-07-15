import 'package:dartz/dartz.dart';
import 'package:silesra/core/errors%20copy/failure.dart';
import 'package:silesra/features/Product/domain/repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteProductUseCase implements UseCase<Future<Either<Failure, void>>, String> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteProduct(id);
  }
}
