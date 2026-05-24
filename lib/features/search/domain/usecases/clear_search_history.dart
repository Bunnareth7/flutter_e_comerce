import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_history_repository.dart';

class ClearSearchHistory implements UseCase<void, NoParams> {
  final SearchHistoryRepository repository;
  ClearSearchHistory(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.clearHistory();
  }
}