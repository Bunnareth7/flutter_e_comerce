import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceFirestore implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs
        .map((doc) => ProductModel.fromJson({'id': doc.id, ...doc.data()!}))
        .toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (doc.exists) {
      return ProductModel.fromJson({'id': doc.id, ...doc.data()!});
    }
    throw Exception('Product not found');
  }
}