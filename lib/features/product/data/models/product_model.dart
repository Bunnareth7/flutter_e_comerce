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
    // ---------- Safe number parsers (handles String, int, double) ----------
    int safeInt(dynamic value, [int fallback = 0]) {
      if (value == null) return fallback;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    double safeDouble(dynamic value, [double fallback = 0.0]) {
      if (value == null) return fallback;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? fallback;
      return fallback;
    }

    // ---------- Safe imageUrls parsing (flattens nested arrays) ----------
    List<String> parseImageUrls(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data
            .expand((e) => e is List ? e.map((x) => x.toString()) : [e.toString()])
            .toList();
      }
      if (data is String) return [data];
      return [];
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: safeDouble(json['price']),
      imageUrls: parseImageUrls(json['imageUrls']),
      category: json['category'] ?? 'General',
      isAvailable: json['isAvailable'] ?? true,
      stockQuantity: safeInt(json['stockQuantity']),
      rating: safeDouble(json['rating'], 4.5),
      reviewCount: safeInt(json['reviewCount']),
      discountPercent: json['discountPercent'] != null
          ? safeDouble(json['discountPercent'])
          : null,
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