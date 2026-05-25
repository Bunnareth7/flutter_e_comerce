import '../../../../../features/order/domain/entities/order.dart';

abstract class AdminOrderState {}

class AdminOrderInitial extends AdminOrderState {}

class AdminOrderLoading extends AdminOrderState {}

class AdminOrdersLoaded extends AdminOrderState {
  final List<Order> orders;
  AdminOrdersLoaded(this.orders);
}

class AdminOrderError extends AdminOrderState {
  final String message;
  AdminOrderError(this.message);
}