import 'package:flutter/material.dart';

class OrderSummaryItem extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  const OrderSummaryItem({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 50),
        ),
      ),
      title: Text(name),
      trailing: Text('$quantity x \$${price.toStringAsFixed(2)}'),
    );
  }
}