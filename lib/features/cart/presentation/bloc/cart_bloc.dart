import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/add_to_cart.dart' as add_usecase;
import '../../domain/usecases/remove_from_cart.dart' as remove_usecase;
import '../../domain/usecases/update_cart_item_quantity.dart' as update_usecase;
import '../../domain/usecases/clear_cart.dart' as clear_usecase;
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final add_usecase.AddToCart addToCart;
  final remove_usecase.RemoveFromCart removeFromCart;
  final update_usecase.UpdateCartItemQuantity updateQuantity;
  final clear_usecase.ClearCart clearCart;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateQuantity,
    required this.clearCart,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await getCart(NoParams());
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final result = await addToCart(add_usecase.AddToCartParams(event.productId, event.productName, event.price, event.imageUrl));
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(LoadCart()),
    );
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final result = await removeFromCart(remove_usecase.RemoveFromCartParams(event.productId));
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(LoadCart()),
    );
  }

  void _onUpdateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    final result = await updateQuantity(update_usecase.UpdateCartItemQuantityParams(event.productId, event.quantity));
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(LoadCart()),
    );
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final result = await clearCart(NoParams());
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(LoadCart()),
    );
  }
}