abstract class SearchHistoryEvent {}

class LoadSearchHistory extends SearchHistoryEvent {}

class AddSearchQuery extends SearchHistoryEvent {
  final String query;
  AddSearchQuery(this.query);
}

class ClearSearchHistory extends SearchHistoryEvent {}