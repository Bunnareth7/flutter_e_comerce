import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

class ClearWishlist implements UseCase<void, NoParams> {
  final WishlistRepository repository;
  ClearWishlist(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.clearWishlist();
  }
}