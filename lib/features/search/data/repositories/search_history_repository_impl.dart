import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/search_history_item.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../datasources/search_history_local_data_source.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  final SearchHistoryLocalDataSource localDataSource;

  SearchHistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SearchHistoryItem>>> getRecentSearches({int limit = 10}) async {
    try {
      final items = await localDataSource.getRecentSearches(limit: limit);
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addSearch(String query) async {
    try {
      await localDataSource.addSearch(query);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}