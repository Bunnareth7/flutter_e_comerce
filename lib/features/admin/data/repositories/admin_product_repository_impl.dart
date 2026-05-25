import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../features/product/data/models/product_model.dart';
import '../../domain/repositories/admin_product_repository.dart';
import '../../../../features/product/domain/entities/product.dart';

class AdminProductRepositoryImpl implements AdminProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson({'id': doc.id, ...doc.data()!}))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(Product product) async {
    try {
      final model = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrls: product.imageUrls,
        category: product.category,
        stockQuantity: product.stockQuantity,
        rating: product.rating,
        reviewCount: product.reviewCount,
        discountPercent: product.discountPercent,
        sizes: product.sizes,
        colors: product.colors,
      );
      await _firestore.collection('products').doc(product.id).set(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    return addProduct(product);
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}