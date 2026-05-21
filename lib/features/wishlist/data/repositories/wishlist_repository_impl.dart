import 'package:dartz/dartz.dart';
import 'package:e_com_app/features/wishlist/domain/entities/wishlist_item.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_data_source.dart';
import '../models/wishlist_item_model.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<WishlistItem>>> getWishlistItems() async {
    try {
      final items = await localDataSource.getWishlistItems();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(
      String productId, String productName, double price, String imageUrl) async {
    try {
      final item = WishlistItemModel(
        productId: productId,
        productName: productName,
        price: price,
        imageUrl: imageUrl,
      );
      await localDataSource.addToWishlist(item);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String productId) async {
    try {
      await localDataSource.removeFromWishlist(productId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isInWishlist(String productId) async {
    try {
      final result = await localDataSource.isInWishlist(productId);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}