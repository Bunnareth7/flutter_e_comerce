import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_local_data_source.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewLocalDataSource localDataSource;

  ReviewRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Review>>> getReviewsByProduct(String productId) async {
    try {
      final reviews = await localDataSource.getReviewsByProduct(productId);
      return Right(reviews);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addReview(Review review) async {
    try {
      final model = ReviewModel(
        id: review.id,
        productId: review.productId,
        userName: review.userName,
        rating: review.rating,
        comment: review.comment,
        date: review.date,
      );
      await localDataSource.addReview(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}