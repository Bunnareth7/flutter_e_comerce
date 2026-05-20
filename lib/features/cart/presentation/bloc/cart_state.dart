import '../../domain/entities/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;
  final int totalItems;

  CartLoaded(this.items)
      : totalPrice = items.fold(0, (sum, item) => sum + (item.price * item.quantity)),
        totalItems = items.fold(0, (sum, item) => sum + item.quantity);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}