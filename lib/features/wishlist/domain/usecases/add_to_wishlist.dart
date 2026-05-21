import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

class AddToWishlistParams {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  AddToWishlistParams(this.productId, this.productName, this.price, this.imageUrl);
}

class AddToWishlist implements UseCase<void, AddToWishlistParams> {
  final WishlistRepository repository;
  AddToWishlist(this.repository);
  @override
  Future<Either<Failure, void>> call(AddToWishlistParams params) =>
      repository.addToWishlist(params.productId, params.productName, params.price, params.imageUrl);
}