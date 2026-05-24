import 'package:sqflite/sqflite.dart';
import '../models/review_model.dart';

abstract class ReviewLocalDataSource {
  Future<List<ReviewModel>> getReviewsByProduct(String productId);
  Future<void> addReview(ReviewModel review);
}

class ReviewLocalDataSourceImpl implements ReviewLocalDataSource {
  final Database database;

  ReviewLocalDataSourceImpl({required this.database});

  @override
  Future<List<ReviewModel>> getReviewsByProduct(String productId) async {
    final maps = await database.query(
      'reviews',
      where: 'productId = ?',
      whereArgs: [productId],
      orderBy: 'date DESC',
    );
    return maps.map((e) => ReviewModel.fromJson(e)).toList();
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    await database.insert('reviews', review.toJson());
  }
}