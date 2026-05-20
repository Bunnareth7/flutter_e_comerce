import 'package:e_com_app/features/product/data/model/product_model.dart';

import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _mockProducts = [
    ProductModel(id: '1', name: 'Headphones', description: 'Noise cancelling', price: 79.99, imageUrl: 'https://via.placeholder.com/150', category: 'Electronics', stockQuantity: 10),
    ProductModel(id: '2', name: 'Shoes', description: 'Running', price: 120.0, imageUrl: 'https://via.placeholder.com/150', category: 'Sports', stockQuantity: 20),
    ProductModel(id: '3', name: 'Watch', description: 'Smart', price: 249.99, imageUrl: 'https://via.placeholder.com/150', category: 'Electronics', stockQuantity: 5),
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