import '../models/order_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<OrderModel> placeOrder(OrderModel order);
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  @override
  Future<OrderModel> placeOrder(OrderModel order) async {
    await Future.delayed(const Duration(seconds: 2));
    return order;
  }
}