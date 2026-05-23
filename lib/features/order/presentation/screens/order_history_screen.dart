import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load orders when screen first appears
    context.read<OrderBloc>().add(LoadOrders());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrdersLoaded) {
          if (state.orders.isEmpty) {
            return Center(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderBloc>().add(LoadOrders());
                },
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text('No orders yet')),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrderBloc>().add(LoadOrders());
            },
            child: ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailScreen(order: order),
                    ),
                  ),
                  child: Card(
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
                  ),
                );
              },
            ),
          );
        } else if (state is OrderError) {
          return Center(child: Text(state.message));
        }
        // OrderInitial or any other state – trigger load
        context.read<OrderBloc>().add(LoadOrders());
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}