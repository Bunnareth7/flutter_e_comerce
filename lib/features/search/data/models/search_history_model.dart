import '../../domain/entities/search_history_item.dart';

class SearchHistoryModel extends SearchHistoryItem {
  SearchHistoryModel({
    required int id,
    required String query,
    required DateTime timestamp,
  }) : super(id: id, query: query, timestamp: timestamp);

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      id: json['id'] as int,
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}