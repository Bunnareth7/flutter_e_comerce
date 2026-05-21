import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: '1', name: 'Wireless Headphones',
      description: 'Noise cancelling bluetooth headphones with 30h battery.',
      price: 79.99,
      imageUrls: [
        'https://picsum.photos/400/400?random=1',
        'https://picsum.photos/400/400?random=2',
        'https://picsum.photos/400/400?random=3',
      ],
      category: 'Electronics', stockQuantity: 10,
      rating: 4.7, reviewCount: 230, discountPercent: 15,
      sizes: [], colors: ['Black', 'White', 'Blue'],
    ),
    ProductModel(
      id: '2', name: 'Running Shoes',
      description: 'Lightweight mesh running shoes.',
      price: 120.0,
      imageUrls: [
        'https://picsum.photos/400/400?random=4',
        'https://picsum.photos/400/400?random=5',
      ],
      category: 'Sports', stockQuantity: 20,
      rating: 4.3, reviewCount: 89,
      sizes: ['US 8', 'US 9', 'US 10'], colors: ['Red', 'Blue'],
    ),
    ProductModel(
      id: '3', name: 'Smart Watch',
      description: 'Fitness tracker with heart rate & GPS.',
      price: 249.99,
      imageUrls: [
        'https://picsum.photos/400/400?random=6',
        'https://picsum.photos/400/400?random=7',
      ],
      category: 'Electronics', stockQuantity: 5,
      rating: 4.8, reviewCount: 512, discountPercent: 20,
      sizes: [], colors: ['Black', 'Silver'],
    ),
    ProductModel(
      id: '4', name: 'Backpack',
      description: 'Water-resistant laptop backpack.',
      price: 45.50,
      imageUrls: [
        'https://picsum.photos/400/400?random=8',
        'https://picsum.photos/400/400?random=9',
      ],
      category: 'Accessories', stockQuantity: 30,
      rating: 4.1, reviewCount: 45,
      sizes: [], colors: ['Gray', 'Navy'],
    ),
    ProductModel(
      id: '5', name: 'Coffee Mug',
      description: 'Thermal insulated travel mug.',
      price: 15.99,
      imageUrls: [
        'https://picsum.photos/400/400?random=10',
      ],
      category: 'Home', stockQuantity: 50,
      rating: 4.5, reviewCount: 120, discountPercent: 10,
      sizes: ['Small', 'Large'], colors: ['White', 'Black'],
    ),
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockProducts;
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProducts.firstWhere((p) => p.id == id);
  }
}