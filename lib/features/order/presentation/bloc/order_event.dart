import 'package:flutter_bloc/flutter_bloc.dart';
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
      (orders) => emit(OrdersLoaded(orders)),
    );
  }
}