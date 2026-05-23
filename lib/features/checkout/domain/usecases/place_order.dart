import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../entities/order.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrderParams {
  final List<CartItem> items;
  final double total;
  final String? shippingAddress;

  PlaceOrderParams(this.items, this.total, {this.shippingAddress});
}

class PlaceOrder implements UseCase<Order, PlaceOrderParams> {
  final CheckoutRepository repository;
  PlaceOrder(this.repository);

  @override
  Future<Either<Failure, Order>> call(PlaceOrderParams params) {
    return repository.placeOrder(
      params.items,
      params.total,
      shippingAddress: params.shippingAddress,
    );
  }
}