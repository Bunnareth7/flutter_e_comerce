import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

class RemoveFromWishlistParams {
  final String productId;
  RemoveFromWishlistParams(this.productId);
}

class RemoveFromWishlist implements UseCase<void, RemoveFromWishlistParams> {
  final WishlistRepository repository;
  RemoveFromWishlist(this.repository);
  @override
  Future<Either<Failure, void>> call(RemoveFromWishlistParams params) =>
      repository.removeFromWishlist(params.productId);
}