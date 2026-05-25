import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../features/product/domain/entities/product.dart';

abstract class AdminProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, void>> addProduct(Product product);
  Future<Either<Failure, void>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
}