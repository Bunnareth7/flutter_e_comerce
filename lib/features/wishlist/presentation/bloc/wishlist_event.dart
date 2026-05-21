abstract class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;

  ToggleWishlist(this.productId, this.productName, this.price, this.imageUrl);
}

class CheckWishlistStatus extends WishlistEvent {
  final String productId;
  CheckWishlistStatus(this.productId);
}