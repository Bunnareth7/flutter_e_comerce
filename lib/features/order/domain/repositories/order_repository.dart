import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, void>> saveOrder(Order order);
}