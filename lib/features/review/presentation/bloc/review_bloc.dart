import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_reviews.dart';
import '../../domain/usecases/add_review.dart' as add_review_uc;
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviews getReviews;
  final add_review_uc.AddReview addReview;

  ReviewBloc({
    required this.getReviews,
    required this.addReview,
  }) : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<AddReview>(_onAddReview);
  }

  void _onLoadReviews(LoadReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await getReviews(GetReviewsParams(event.productId));
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewsLoaded(reviews)),
    );
  }

  void _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    final result = await addReview(add_review_uc.AddReviewParams(event.review));
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewAdded()),
    );
  }
}