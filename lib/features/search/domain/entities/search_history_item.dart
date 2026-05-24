class SearchHistoryItem {
  final int id;
  final String query;
  final DateTime timestamp;

  SearchHistoryItem({
    required this.id,
    required this.query,
    required this.timestamp,
  });
}