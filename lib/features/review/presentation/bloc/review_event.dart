import '../../domain/entities/review.dart';

abstract class ReviewEvent {}

class LoadReviews extends ReviewEvent {
  final String productId;
  LoadReviews(this.productId);
}

class AddReview extends ReviewEvent {
  final Review review;
  AddReview(this.review);
}