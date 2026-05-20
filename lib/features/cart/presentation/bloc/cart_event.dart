abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;

  AddToCart(this.productId, this.productName, this.price, this.imageUrl);
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int quantity;
  UpdateCartItemQuantity(this.productId, this.quantity);
}

class ClearCart extends CartEvent {}