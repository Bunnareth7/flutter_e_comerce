import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCartParams {
  final String productId;
  RemoveFromCartParams(this.productId);
}

class RemoveFromCart implements UseCase<void, RemoveFromCartParams> {
  final CartRepository repository;
  RemoveFromCart(this.repository);
  @override
  Future<Either<Failure, void>> call(RemoveFromCartParams params) =>
      repository.removeFromCart(params.productId);
}