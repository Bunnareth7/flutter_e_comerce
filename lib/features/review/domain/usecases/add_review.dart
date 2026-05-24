import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

class AddReviewParams {
  final Review review;
  AddReviewParams(this.review);
}

class AddReview implements UseCase<void, AddReviewParams> {
  final ReviewRepository repository;
  AddReview(this.repository);

  @override
  Future<Either<Failure, void>> call(AddReviewParams params) =>
      repository.addReview(params.review);
}