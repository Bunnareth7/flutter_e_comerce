import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemQuantityParams {
  final String productId;
  final int quantity;
  UpdateCartItemQuantityParams(this.productId, this.quantity);
}

class UpdateCartItemQuantity implements UseCase<void, UpdateCartItemQuantityParams> {
  final CartRepository repository;
  UpdateCartItemQuantity(this.repository);
  @override
  Future<Either<Failure, void>> call(UpdateCartItemQuantityParams params) =>
      repository.updateQuantity(params.productId, params.quantity);
}