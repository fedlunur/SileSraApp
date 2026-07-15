import 'package:dartz/dartz.dart';
import 'package:silesra/core/errors%20copy/failure.dart';
import 'package:silesra/features/Product/domain/entities/product_entitiy.dart';

abstract class ProductRepository {
  /// Fetches a list of all products (generic, house, car, etc.)
  Future<Either<Failure, List<Product>>> getProducts();

  /// Fetches a specific product by its ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Creates a new product
  Future<Either<Failure, Product>> createProduct(Product product);

  /// Updates an existing product by its ID
  Future<Either<Failure, Product>> updateProduct(Product product, String id);

  /// Deletes a product by its ID
  Future<Either<Failure, void>> deleteProduct(String id);

  /// Fetches a list of houses
  Future<Either<Failure, List<Product>>> getHouses();

  /// Fetches a list of cars
  Future<Either<Failure, List<Product>>> getCars();

  /// Fetches a list of products dynamically by model name
  Future<Either<Failure, List<Product>>> getGenericList(String modelName);

  /// Searches for products dynamically by model name and query
  Future<Either<Failure, List<Product>>> searchGenericProducts(String modelName, String query);

  /// Fetches a specific house by its ID
  Future<Either<Failure, Product>> getHouseById(String id);

  /// Fetches a specific car by its ID
  Future<Either<Failure, Product>> getCarById(String id);
}
