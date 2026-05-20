import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../../../cart/domain/entities/cart_item.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, Order>> placeOrder(List<CartItem> items, double total);
}