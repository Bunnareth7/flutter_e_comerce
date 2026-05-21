import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

class CheckWishlistParams {
  final String productId;
  CheckWishlistParams(this.productId);
}

class CheckWishlist implements UseCase<bool, CheckWishlistParams> {
  final WishlistRepository repository;
  CheckWishlist(this.repository);
  @override
  Future<Either<Failure, bool>> call(CheckWishlistParams params) =>
      repository.isInWishlist(params.productId);
}