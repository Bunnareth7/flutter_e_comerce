import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/place_order.dart';
import '../../../order/domain/usecases/save_order.dart';
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

  Future<void> _onPlaceOrder(
      PlaceOrderEvent event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    final result = await placeOrder(PlaceOrderParams(event.items, event.total));

    // ✅ Await the fold itself – both branches return Future<void>
    await result.fold<Future<void>>(
      (failure) async => emit(CheckoutError(failure.message)),
      (order) async {
        await saveOrder(SaveOrderParams(order));
        emit(CheckoutSuccess(order.id));
      },
    );
  }
}