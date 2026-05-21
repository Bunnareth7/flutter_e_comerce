import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required List<String> imageUrls,
    String category = 'General',
    bool isAvailable = true,
    int stockQuantity = 0,
    double rating = 4.5,
    int reviewCount = 0,
    double? discountPercent,
    List<String> sizes = const [],
    List<String> colors = const [],
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrls: imageUrls,
          category: category,
          isAvailable: isAvailable,
          stockQuantity: stockQuantity,
          rating: rating,
          reviewCount: reviewCount,
          discountPercent: discountPercent,
          sizes: sizes,
          colors: colors,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [json['imageUrl']?.toString() ?? 'https://via.placeholder.com/300'],
      category: json['category'] ?? 'General',
      isAvailable: json['isAvailable'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: json['reviewCount'] ?? 0,
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      sizes: (json['sizes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      colors: (json['colors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'category': category,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'discountPercent': discountPercent,
      'sizes': sizes,
      'colors': colors,
    };
  }
}