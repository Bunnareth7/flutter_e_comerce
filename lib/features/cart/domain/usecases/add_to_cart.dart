import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class AddToCartParams {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  AddToCartParams(this.productId, this.productName, this.price, this.imageUrl);
}

class AddToCart implements UseCase<void, AddToCartParams> {
  final CartRepository repository;
  AddToCart(this.repository);
  @override
  Future<Either<Failure, void>> call(AddToCartParams params) =>
      repository.addToCart(params.productId, params.productName, params.price, params.imageUrl);
}