import 'package:e_com_app/features/wishlist/domain/entities/wishlist_item.dart';

import '../../domain/entities/wishlist_item.dart';

class WishlistItemModel extends WishlistItem {
  WishlistItemModel({
    required String productId,
    required String productName,
    required double price,
    required String imageUrl,
  }) : super(productId: productId, productName: productName, price: price, imageUrl: imageUrl);

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      productId: json['productId'],
      productName: json['productName'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}