import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/product/domain/entities/product.dart';
import '../repositories/admin_product_repository.dart';

class AdminGetProducts implements UseCase<List<Product>, NoParams> {
  final AdminProductRepository repository;
  AdminGetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) =>
      repository.getProducts();
}