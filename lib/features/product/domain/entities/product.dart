class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final int stockQuantity;
  final double rating;             // NEW
  final int reviewCount;           // NEW
  final double? discountPercent;   // NEW – nullable, show old price if >0

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category = 'General',
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.discountPercent,
  });
}