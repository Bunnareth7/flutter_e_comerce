class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;         // was single imageUrl
  final String category;
  final bool isAvailable;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final double? discountPercent;
  final List<String> sizes;            // optional size variants
  final List<String> colors;           // optional color names (e.g., "Red", "Blue")

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    this.category = 'General',
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.discountPercent,
    this.sizes = const [],
    this.colors = const [],
  });
}