import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/product/domain/entities/product.dart';
import '../repositories/admin_product_repository.dart';

class AdminUpdateProductParams {
  final Product product;
  AdminUpdateProductParams(this.product);
}

class AdminUpdateProduct implements UseCase<void, AdminUpdateProductParams> {
  final AdminProductRepository repository;
  AdminUpdateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(AdminUpdateProductParams params) =>
      repository.updateProduct(params.product);
}