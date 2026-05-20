import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';
import '../../../checkout/presentation/screens/checkout_screen.dart';
import '../../../../injection_container.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartBloc>()..add(LoadCart()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              if (state.items.isEmpty) {
                return const Center(child: Text('Your cart is empty'));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return CartItemTile(
                          item: item,
                          onIncrement: () {
                            context.read<CartBloc>().add(
                                  UpdateCartItemQuantity(
                                    item.productId,
                                    item.quantity + 1,
                                  ),
                                );
                          },
                          onDecrement: () {
                            if (item.quantity > 1) {
                              context.read<CartBloc>().add(
                                    UpdateCartItemQuantity(
                                      item.productId,
                                      item.quantity - 1,
                                    ),
                                  );
                            } else {
                              context.read<CartBloc>().add(RemoveFromCart(item.productId));
                            }
                          },
                          onRemove: () {
                            context.read<CartBloc>().add(RemoveFromCart(item.productId));
                          },
                        );
                      },
                    ),
                  ),
                  CartSummary(
                    total: state.totalPrice,
                    itemCount: state.totalItems,
                    onCheckout: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      );
                    },
                    onClear: () {
                      context.read<CartBloc>().add(ClearCart());
                    },
                  ),
                ],
              );
            } else if (state is CartError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}