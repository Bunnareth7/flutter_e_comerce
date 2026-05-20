import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_cart_item_quantity.dart';
import '../../domain/usecases/clear_cart.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final UpdateCartItemQuantity updateQuantity;
  final ClearCart clearCart;

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
    final result = await addToCart(AddToCartParams(event.productId, event.productName, event.price, event.imageUrl));
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(LoadCart()),
    );
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final result = await removeFromCart(RemoveFromCartParams(event.productId));
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(LoadCart()),
    );
  }

  void _onUpdateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    final result = await updateQuantity(UpdateCartItemQuantityParams(event.productId, event.quantity));
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