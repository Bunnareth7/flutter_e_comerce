import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_history_repository.dart';

class AddSearchHistoryParams {
  final String query;
  AddSearchHistoryParams(this.query);
}

class AddSearchHistory implements UseCase<void, AddSearchHistoryParams> {
  final SearchHistoryRepository repository;
  AddSearchHistory(this.repository);

  @override
  Future<Either<Failure, void>> call(AddSearchHistoryParams params) async {
    return repository.addSearch(params.query);
  }
}