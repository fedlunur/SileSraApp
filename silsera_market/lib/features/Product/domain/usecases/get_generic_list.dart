import 'package:dartz/dartz.dart';
import 'package:silesra/core/errors%20copy/failure.dart';
import 'package:silesra/features/Product/domain/entities/product_entitiy.dart';
import 'package:silesra/features/Product/domain/repositories/product_repository.dart';

import '../../../../core/usecases/usecase.dart';

class GetCarByIdUseCase implements UseCase<Future<Either<Failure, Product>>, ParamsUseCase> {
  final ProductRepository repository;

  GetCarByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(ParamsUseCase params) async {
    return await repository.getCarById(params.id);
  }
}

class ParamsUseCase {
  final String id;

  ParamsUseCase({required this.id});

  String? get query => null;

  String? get modelName => null;
}
