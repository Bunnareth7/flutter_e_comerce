import '../../domain/entities/review.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<Review> reviews;
  ReviewsLoaded(this.reviews);
}

class ReviewAdded extends ReviewState {}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}