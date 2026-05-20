import 'package:e_com_app/features/checkout/domain/entities/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_orders.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrders getOrders;

  OrderBloc({required this.getOrders}) : super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
  }

  void _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await getOrders(NoParams());
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) {
        // Explicit cast to List<Order>
        final orderList = orders.map((e) => e as Order).toList();
        emit(OrdersLoaded(orderList));
      },
    );
  }
}