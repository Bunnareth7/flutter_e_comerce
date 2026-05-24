import 'package:dartz/dartz.dart';
import 'package:e_com_app/features/wishlist/domain/entities/wishlist_item.dart';
import '../../../../core/error/failures.dart';
import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getWishlistItems();
  Future<Either<Failure, void>> addToWishlist(String productId, String productName, double price, String imageUrl);
  Future<Either<Failure, void>> removeFromWishlist(String productId);
  Future<Either<Failure, bool>> isInWishlist(String productId);
  Future<Either<Failure, void>> clearWishlist();
}