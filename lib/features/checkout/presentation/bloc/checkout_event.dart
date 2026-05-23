import '../../../cart/domain/entities/cart_item.dart';

abstract class CheckoutEvent {}

class PlaceOrderEvent extends CheckoutEvent {
  final List<CartItem> items;
  final double total;
  final String? shippingAddress;

  PlaceOrderEvent(this.items, this.total, {this.shippingAddress});
}