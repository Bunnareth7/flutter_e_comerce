import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../entities/order.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrderParams {
  final List<CartItem> items;
  final double total;
  PlaceOrderParams(this.items, this.total);
}

class PlaceOrder implements UseCase<Order, PlaceOrderParams> {
  final CheckoutRepository repository;
  PlaceOrder(this.repository);
  @override
  Future<Either<Failure, Order>> call(PlaceOrderParams params) =>
      repository.placeOrder(params.items, params.total);
}