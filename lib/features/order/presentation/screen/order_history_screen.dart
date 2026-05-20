import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderInitial) {
          context.read<OrderBloc>().add(LoadOrders());
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrdersLoaded) {
          if (state.orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }
          return ListView.builder(
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.id.substring(0, 8)}',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('Date: ${order.date.toString().substring(0, 10)}'),
                      Text('Status: ${order.status}'),
                      const SizedBox(height: 8),
                      ...order.items.map((item) => Text(
                          '${item.productName} x ${item.quantity} - \$${item.price.toStringAsFixed(2)}')),
                      const Divider(),
                      Text('Total: \$${order.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is OrderError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}