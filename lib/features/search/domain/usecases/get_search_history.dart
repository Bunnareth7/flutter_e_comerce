import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_history_item.dart';
import '../repositories/search_history_repository.dart';

class GetSearchHistoryParams {
  final int limit;
  GetSearchHistoryParams({this.limit = 10});
}

class GetSearchHistory implements UseCase<List<SearchHistoryItem>, GetSearchHistoryParams> {
  final SearchHistoryRepository repository;
  GetSearchHistory(this.repository);

  @override
  Future<Either<Failure, List<SearchHistoryItem>>> call(GetSearchHistoryParams params) async {
    return repository.getRecentSearches(limit: params.limit);
  }
}