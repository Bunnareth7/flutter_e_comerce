import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/place_order.dart';
import '../../../order/domain/usecases/save_order.dart';
import '../../../order/domain/entities/order.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PlaceOrder placeOrder;
  final SaveOrder saveOrder;

  CheckoutBloc({
    required this.placeOrder,
    required this.saveOrder,
  }) : super(CheckoutInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  void _onPlaceOrder(PlaceOrderEvent event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    final result = await placeOrder(PlaceOrderParams(event.items, event.total));
    result.fold(
      (failure) => emit(CheckoutError(failure.message)),
      (order) async {
        await saveOrder(SaveOrderParams(order));
        emit(CheckoutSuccess(order.id));
      },
    );
  }
}