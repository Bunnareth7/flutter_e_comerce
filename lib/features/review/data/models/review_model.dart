import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required String id,
    required String productId,
    required String userName,
    required double rating,
    required String comment,
    required DateTime date,
  }) : super(
          id: id,
          productId: productId,
          userName: userName,
          rating: rating,
          comment: comment,
          date: date,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      productId: json['productId'],
      userName: json['userName'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}