import '../../../cart/domain/entities/cart_item.dart';

abstract class CheckoutEvent {}

class PlaceOrderEvent extends CheckoutEvent {
  final List<CartItem> items;
  final double total;
  PlaceOrderEvent(this.items, this.total);
}