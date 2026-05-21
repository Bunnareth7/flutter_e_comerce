import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: '1', name: 'Wireless Headphones',
      description: 'Noise cancelling bluetooth headphones with 30h battery. Immersive sound with deep bass.',
      price: 79.99,
      imageUrls: [
        'https://via.placeholder.com/300/FF6C63/FFFFFF?text=Headphones1',
        'https://via.placeholder.com/300/6C63FF/FFFFFF?text=Headphones2',
        'https://via.placeholder.com/300/63FF6C/FFFFFF?text=Headphones3',
      ],
      category: 'Electronics', stockQuantity: 10,
      rating: 4.7, reviewCount: 230, discountPercent: 15,
      sizes: [], colors: ['Black', 'White', 'Blue'],
    ),
    ProductModel(
      id: '2', name: 'Running Shoes',
      description: 'Lightweight mesh running shoes with responsive cushioning.',
      price: 120.0,
      imageUrls: [
        'https://via.placeholder.com/300/FF6C63/FFFFFF?text=Shoes1',
        'https://via.placeholder.com/300/6C63FF/FFFFFF?text=Shoes2',
      ],
      category: 'Sports', stockQuantity: 20,
      rating: 4.3, reviewCount: 89,
      sizes: ['US 8', 'US 9', 'US 10'], colors: ['Red', 'Blue'],
    ),
    ProductModel(
      id: '3', name: 'Smart Watch',
      description: 'Fitness tracker with heart rate & GPS. Water resistant up to 50m.',
      price: 249.99,
      imageUrls: [
        'https://via.placeholder.com/300/63FF6C/FFFFFF?text=Watch1',
        'https://via.placeholder.com/300/FF6C63/FFFFFF?text=Watch2',
      ],
      category: 'Electronics', stockQuantity: 5,
      rating: 4.8, reviewCount: 512, discountPercent: 20,
      sizes: [], colors: ['Black', 'Silver'],
    ),
    ProductModel(
      id: '4', name: 'Backpack',
      description: 'Water-resistant laptop backpack with USB charging port.',
      price: 45.50,
      imageUrls: [
        'https://via.placeholder.com/300/6C63FF/FFFFFF?text=Backpack1',
        'https://via.placeholder.com/300/FF6C63/FFFFFF?text=Backpack2',
      ],
      category: 'Accessories', stockQuantity: 30,
      rating: 4.1, reviewCount: 45,
      sizes: [], colors: ['Gray', 'Navy'],
    ),
    ProductModel(
      id: '5', name: 'Coffee Mug',
      description: 'Thermal insulated travel mug. Keeps drinks hot for 6 hours.',
      price: 15.99,
      imageUrls: [
        'https://via.placeholder.com/300/FF6C63/FFFFFF?text=Mug1',
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