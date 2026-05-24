import 'package:sqflite/sqflite.dart';
import '../models/wishlist_item_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistItemModel>> getWishlistItems();
  Future<void> addToWishlist(WishlistItemModel item);
  Future<void> removeFromWishlist(String productId);
  Future<bool> isInWishlist(String productId);
  Future<void> clearWishlist();   // ← new
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final Database database;

  WishlistLocalDataSourceImpl({required this.database});

  @override
  Future<List<WishlistItemModel>> getWishlistItems() async {
    final maps = await database.query('wishlist_items');
    return maps.map((e) => WishlistItemModel.fromJson(e)).toList();
  }

  @override
  Future<void> addToWishlist(WishlistItemModel item) async {
    await database.insert('wishlist_items', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    await database.delete('wishlist_items', where: 'productId = ?', whereArgs: [productId]);
  }

  @override
  Future<bool> isInWishlist(String productId) async {
    final result = await database.query('wishlist_items',
        where: 'productId = ?', whereArgs: [productId]);
    return result.isNotEmpty;
  }

  @override
  Future<void> clearWishlist() async {
    await database.delete('wishlist_items');
  }
}