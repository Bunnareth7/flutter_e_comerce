import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    required String productId,
    required String productName,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) : super(productId: productId, productName: productName, price: price, imageUrl: imageUrl, quantity: quantity);

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      productName: json['productName'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}