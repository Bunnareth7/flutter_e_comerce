import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addToCart(String productId, String productName, double price, String imageUrl);
  Future<Either<Failure, void>> removeFromCart(String productId);
  Future<Either<Failure, void>> updateQuantity(String productId, int quantity);
  Future<Either<Failure, void>> clearCart();
}