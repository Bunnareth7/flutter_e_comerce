import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

class GetReviewsParams {
  final String productId;
  GetReviewsParams(this.productId);
}

class GetReviews implements UseCase<List<Review>, GetReviewsParams> {
  final ReviewRepository repository;
  GetReviews(this.repository);

  @override
  Future<Either<Failure, List<Review>>> call(GetReviewsParams params) =>
      repository.getReviewsByProduct(params.productId);
}