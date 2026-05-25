import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/product/domain/entities/product.dart';
import '../repositories/admin_product_repository.dart';

class AdminAddProductParams {
  final Product product;
  AdminAddProductParams(this.product);
}

class AdminAddProduct implements UseCase<void, AdminAddProductParams> {
  final AdminProductRepository repository;
  AdminAddProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(AdminAddProductParams params) =>
      repository.addProduct(params.product);
}