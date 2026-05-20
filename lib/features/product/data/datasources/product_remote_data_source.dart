import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: '1', name: 'Wireless Headphones',
      description: 'Noise cancelling bluetooth headphones with 30h battery',
      price: 79.99, imageUrl: 'https://via.placeholder.com/150',
      category: 'Electronics', stockQuantity: 10,
      rating: 4.7, reviewCount: 230, discountPercent: 15,
    ),
    ProductModel(
      id: '2', name: 'Running Shoes',
      description: 'Lightweight mesh running shoes',
      price: 120.0, imageUrl: 'https://cdn.salla.sa/RvPxw/9a80a5fc-4c6c-4e68-9995-6d1b8ee75003-1000x1000-cPMWSgDQTgiTccwFG4gYByjnP8WzMcoyzJ8k1grO.png',
      category: 'Sports', stockQuantity: 20,
      rating: 4.3, reviewCount: 89, discountPercent: null,
    ),
    ProductModel(
      id: '3', name: 'Smart Watch',
      description: 'Fitness tracker with heart rate & GPS',
      price: 249.99, imageUrl: 'https://via.placeholder.com/150',
      category: 'Electronics', stockQuantity: 5,
      rating: 4.8, reviewCount: 512, discountPercent: 20,
    ),
    ProductModel(
      id: '4', name: 'Backpack',
      description: 'Water-resistant laptop backpack',
      price: 45.50, imageUrl: 'https://via.placeholder.com/150',
      category: 'Accessories', stockQuantity: 30,
      rating: 4.1, reviewCount: 45, discountPercent: null,
    ),
    ProductModel(
      id: '5', name: 'Coffee Mug',
      description: 'Thermal insulated travel mug',
      price: 15.99, imageUrl: 'https://www.gohobi.co.uk/cdn/shop/products/il_fullxfull.3246747650_fnjy.jpg?v=1670423589',
      category: 'Home', stockQuantity: 50,
      rating: 4.5, reviewCount: 120, discountPercent: 10,
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