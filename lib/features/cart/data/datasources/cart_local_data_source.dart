import 'package:sqflite/sqflite.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Database database;
  CartLocalDataSourceImpl({required this.database});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final maps = await database.query('cart_items');
    return maps.map((e) => CartItemModel.fromJson(e)).toList();
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    final exist = await database.query('cart_items', where: 'productId = ?', whereArgs: [item.productId]);
    if (exist.isNotEmpty) {
      await database.rawUpdate('UPDATE cart_items SET quantity = quantity + 1 WHERE productId = ?', [item.productId]);
    } else {
      await database.insert('cart_items', item.toJson());
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final exist = await database.query('cart_items', where: 'productId = ?', whereArgs: [productId]);
    if (exist.isNotEmpty) {
      final qty = exist.first['quantity'] as int;
      if (qty > 1) {
        await database.update('cart_items', {'quantity': qty - 1}, where: 'productId = ?', whereArgs: [productId]);
      } else {
        await database.delete('cart_items', where: 'productId = ?', whereArgs: [productId]);
      }
    }
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await database.delete('cart_items', where: 'productId = ?', whereArgs: [productId]);
    } else {
      await database.update('cart_items', {'quantity': quantity}, where: 'productId = ?', whereArgs: [productId]);
    }
  }

  @override
  Future<void> clearCart() async {
    await database.delete('cart_items');
  }
}