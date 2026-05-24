import '../../domain/entities/search_history_item.dart';

abstract class SearchHistoryState {}

class SearchHistoryInitial extends SearchHistoryState {}

class SearchHistoryLoading extends SearchHistoryState {}

class SearchHistoryLoaded extends SearchHistoryState {
  final List<SearchHistoryItem> history;
  SearchHistoryLoaded(this.history);
}

class SearchHistoryError extends SearchHistoryState {
  final String message;
  SearchHistoryError(this.message);
}