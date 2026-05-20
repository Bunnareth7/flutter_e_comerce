import 'package:dartz/dartz.dart' hide Order;
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
  Future<Either<Failure, void>> call(SaveOrderParams params) =>
      repository.saveOrder(params.order);
}