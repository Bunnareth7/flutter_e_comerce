import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_product_repository.dart';

class AdminDeleteProductParams {
  final String productId;
  AdminDeleteProductParams(this.productId);
}

class AdminDeleteProduct implements UseCase<void, AdminDeleteProductParams> {
  final AdminProductRepository repository;
  AdminDeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(AdminDeleteProductParams params) =>
      repository.deleteProduct(params.productId);
}