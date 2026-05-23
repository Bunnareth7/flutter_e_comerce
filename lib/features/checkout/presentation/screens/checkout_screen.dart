import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../address/presentation/bloc/address_bloc.dart';
import '../../../address/presentation/bloc/address_event.dart';
import '../../../address/presentation/bloc/address_state.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';
import '../widgets/order_summary.dart';
import '../widgets/payment_method_selector.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedAddressId;

  @override
  Widget build(BuildContext context) {
    // Make sure addresses are loaded
    context.read<AddressBloc>().add(LoadAddresses());

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

                          // ----- Address Selection -----
                          BlocBuilder<AddressBloc, AddressState>(
                            builder: (context, addressState) {
                              if (addressState is AddressesLoaded) {
                                final addresses = addressState.addresses;
                                if (addresses.isEmpty) {
                                  return const ListTile(
                                    title: Text('No addresses saved'),
                                    subtitle: Text('Please add one in Profile'),
                                  );
                                }
                                return DropdownButtonFormField<String>(
                                  value: _selectedAddressId,
                                  decoration: const InputDecoration(
                                    labelText: 'Shipping Address',
                                  ),
                                  items: addresses.map((addr) {
                                    return DropdownMenuItem<String>(
                                      value: addr.id,
                                      child: Text(
                                        '${addr.fullName}, ${addr.street}, ${addr.city}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (selectedId) {
                                    setState(() {
                                      _selectedAddressId = selectedId;
                                    });
                                  },
                                );
                              }
                              return const LinearProgressIndicator();
                            },
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
                          // Close the payment dialog if it's still open
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                          context.read<CartBloc>().add(ClearCart());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Order placed! ID: ${state.orderId}',
                              ),
                            ),
                          );
                        } else if (state is CheckoutError) {
                          // Close the payment dialog and show error
                          Navigator.of(context).pop();
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
                            onPressed: () {
                              if (_selectedAddressId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select a shipping address',
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Build the address string
                              final addressBloc = context.read<AddressBloc>();
                              String? addressString;
                              if (addressBloc.state is AddressesLoaded) {
                                final addresses =
                                    (addressBloc.state as AddressesLoaded)
                                        .addresses;
                                final selected = addresses.firstWhere(
                                  (a) => a.id == _selectedAddressId,
                                );
                                addressString =
                                    '${selected.fullName}, ${selected.street}, ${selected.city}, ${selected.state} ${selected.zip}, ${selected.phone}';
                              }

                              // Show payment processing dialog
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const AlertDialog(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 20),
                                      Text('Processing payment...'),
                                    ],
                                  ),
                                ),
                              );

                              // Place the order
                              context.read<CheckoutBloc>().add(
                                PlaceOrderEvent(
                                  items,
                                  total,
                                  shippingAddress: addressString,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
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
