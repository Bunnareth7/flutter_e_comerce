import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByIdParams {
  final String id;
  GetProductByIdParams(this.id);
}

class GetProductById implements UseCase<Product, GetProductByIdParams> {
  final ProductRepository repository;
  GetProductById(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductByIdParams params) {
    return repository.getProductById(params.id);
  }
}