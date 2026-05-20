import 'package:dartz/dartz.dart' hide Order;
import '../../../cart/domain/entities/cart_item.dart';
export '../../../checkout/domain/entities/order.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = 'confirmed',
  });
}