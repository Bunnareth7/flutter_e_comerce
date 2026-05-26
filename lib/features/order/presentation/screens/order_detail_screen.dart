import 'package:flutter/material.dart';
import '../../domain/entities/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  int _simulatedStatusIndex(DateTime orderDate) {
    final age = DateTime.now().difference(orderDate);
    if (age.inMinutes < 1) return 0;
    if (age.inMinutes < 5) return 1;
    if (age.inHours < 1) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final statusIndex = _simulatedStatusIndex(order.date);
    const steps = ['Confirmed', 'Processing', 'Shipped', 'Delivered'];
    const icons = [
      Icons.check_circle,
      Icons.inventory_2,
      Icons.local_shipping,
      Icons.home
    ];
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            title: Text('Order #${order.id.substring(0, 8)}'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: order.status == 'confirmed'
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: order.status == 'confirmed'
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${order.date.toString().substring(0, 16)}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 24),
                  const Text('Tracking',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  ...List.generate(steps.length, (index) {
                    final isCompleted = index <= statusIndex;
                    final isCurrent = index == statusIndex;
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 40,
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  width: isCurrent ? 28 : 24,
                                  height: isCurrent ? 28 : 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted
                                        ? colorScheme.primary
                                        : Colors.grey.shade300,
                                    border: isCurrent
                                        ? Border.all(
                                            color: colorScheme.primary,
                                            width: 3)
                                        : null,
                                  ),
                                  child: Icon(
                                    icons[index],
                                    size: 14,
                                    color: isCompleted
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                                if (index < steps.length - 1)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      color: index < statusIndex
                                          ? colorScheme.primary
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Text(
                              steps[index],
                              style: TextStyle(
                                fontWeight: isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isCompleted
                                    ? Colors.black
                                    : Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text('Items',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                        child: ListTile(
                          title: Text(item.productName),
                          subtitle: Text(
                            '${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                          ),
                          trailing: Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Text('\$${order.total.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: colorScheme.primary)),
                    ],
                  ),
                  if (order.shippingAddress != null &&
                      order.shippingAddress!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text('Shipping Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(order.shippingAddress!,
                        style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}