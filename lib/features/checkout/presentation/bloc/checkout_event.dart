import '../../../cart/domain/entities/cart_item.dart';

abstract class CheckoutEvent {}

class PlaceOrderEvent extends CheckoutEvent {
  final List<CartItem> items;
  final double total;
  final String? shippingAddress;
  final String? userEmail;

  PlaceOrderEvent(this.items, this.total, {this.shippingAddress, this.userEmail});
}