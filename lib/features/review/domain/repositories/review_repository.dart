import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/review.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<Review>>> getReviewsByProduct(String productId);
  Future<Either<Failure, void>> addReview(Review review);
}