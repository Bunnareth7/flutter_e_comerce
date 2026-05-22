import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';
import '../widgets/order_summary.dart';
import '../widgets/payment_method_selector.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is CartLoaded) {
            final items = cartState.items;
            final total = cartState.totalPrice;
            return BlocProvider(
              create: (_) => sl<CheckoutBloc>(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          ...items.map(
                            (item) => OrderSummaryItem(
                              name: item.productName,
                              quantity: item.quantity,
                              price: item.price,
                              imageUrl: item.imageUrl,
                            ),
                          ),
                          const Divider(),
                          Text(
                            'Total: \$${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          const PaymentMethodSelector(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocConsumer<CheckoutBloc, CheckoutState>(
                      listener: (context, state) {
                        if (state is CheckoutSuccess) {
                          context.read<CartBloc>().add(ClearCart());
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Order placed! ID: ${state.orderId}',
                              ),
                            ),
                          );
                        } else if (state is CheckoutError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, checkoutState) {
                        if (checkoutState is CheckoutLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            // ✅ Added missing onPressed
                            onPressed: () {
                              context.read<CheckoutBloc>().add(
                                PlaceOrderEvent(items, total),
                              );
                            },
                            child: const Text('Place Order'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Cart is empty'));
        },
      ),
    );
  }
}
