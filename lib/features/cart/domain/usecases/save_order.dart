import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class SaveOrderParams {
  final Order order;
  SaveOrderParams(this.order);
}

class SaveOrder implements UseCase<void, SaveOrderParams> {
  final OrderRepository repository;
  SaveOrder(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveOrderParams params) {
    return repository.saveOrder(params.order);
  }
}