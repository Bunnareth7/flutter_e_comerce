import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/search_history_item.dart';

abstract class SearchHistoryRepository {
  Future<Either<Failure, List<SearchHistoryItem>>> getRecentSearches({int limit = 10});
  Future<Either<Failure, void>> addSearch(String query);
  Future<Either<Failure, void>> clearHistory();
}