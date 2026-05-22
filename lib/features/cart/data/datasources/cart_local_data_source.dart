import 'package:sqflite/sqflite.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item, {int quantity = 1});
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Database database;

  CartLocalDataSourceImpl({required this.database});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final List<Map<String, dynamic>> maps = await database.query('cart_items');
    return maps.map((map) => CartItemModel.fromJson(map)).toList();
  }

  @override
  Future<void> addToCart(CartItemModel item, {int quantity = 1}) async {
    final existing = await database.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [item.productId],
    );

    if (existing.isNotEmpty) {
      final current = CartItemModel.fromJson(existing.first);
      await database.update(
        'cart_items',
        {'quantity': current.quantity + quantity},
        where: 'productId = ?',
        whereArgs: [item.productId],
      );
    } else {
      // Insert with the given quantity
      final newItem = CartItemModel(
        productId: item.productId,
        productName: item.productName,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: quantity,
      );
      await database.insert('cart_items', newItem.toJson());
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final existing = await database.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (existing.isNotEmpty) {
      final current = CartItemModel.fromJson(existing.first);
      if (current.quantity > 1) {
        await database.update(
          'cart_items',
          {'quantity': current.quantity - 1},
          where: 'productId = ?',
          whereArgs: [productId],
        );
      } else {
        await database.delete(
          'cart_items',
          where: 'productId = ?',
          whereArgs: [productId],
        );
      }
    }
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await database.delete(
        'cart_items',
        where: 'productId = ?',
        whereArgs: [productId],
      );
    } else {
      await database.update(
        'cart_items',
        {'quantity': quantity},
        where: 'productId = ?',
        whereArgs: [productId],
      );
    }
  }

  @override
  Future<void> clearCart() async {
    await database.delete('cart_items');
  }
}